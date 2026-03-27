//
//  SpatialBackgroundView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI
import SQLite3

/// 空间模式沉浸式背景视图
struct SpatialBackgroundView: View {
    var environment: SpatialEnvironment
    /// 是否使用系统桌面壁纸
    var useSystemWallpaper: Bool = true
    /// 空间模式自定义背景图片路径
    var spatialCustomBackgroundPath: String? = nil
    
    @State private var animateGradient = false
    @State private var systemWallpaperImage: NSImage?
    @State private var spatialCustomImage: NSImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. 系统桌面壁纸
                if useSystemWallpaper, let wallpaper = systemWallpaperImage {
                    Image(nsImage: wallpaper)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                // 2. 自定义上传的图片
                else if environment == .custom, let customImg = spatialCustomImage {
                    Image(nsImage: customImg)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                // 3. 内置环境图片
                else if !environment.imageName.isEmpty, let _ = NSImage(named: environment.imageName) {
                    Image(environment.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                // 4. 动态渐变（兜底）
                else {
                    immersiveBackground(for: environment, in: geometry.size)
                }
                
                // 添加微妙的暗角效果增强深度感
                vignetteOverlay(in: geometry.size)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            loadSystemWallpaper()
            loadSystemWallpaper()
            loadSpatialCustomImage()
            
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
        .onChange(of: useSystemWallpaper) { _, newValue in
            if newValue {
                loadSystemWallpaper()
            }
        }

        .onChange(of: spatialCustomBackgroundPath) { _, _ in
            loadSpatialCustomImage()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWorkspace.activeSpaceDidChangeNotification)) { _ in
            // 当切换空间时重新加载壁纸
            loadSystemWallpaper()
        }
    }
    

    
    /// 加载空间模式自定义背景图片
    private func loadSpatialCustomImage() {
        guard let path = spatialCustomBackgroundPath, !path.isEmpty else {
            spatialCustomImage = nil
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = NSImage(contentsOfFile: path) {
                DispatchQueue.main.async {
                    self.spatialCustomImage = image
                }
            }
        }
    }
    
    /// 加载系统桌面壁纸
    private func loadSystemWallpaper() {
        guard useSystemWallpaper else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            // 方法1: 从数据库读取真实壁纸路径
            if let dbPath = getWallpaperFromDatabase() {
                if let image = NSImage(contentsOfFile: dbPath) {
                    DispatchQueue.main.async {
                        self.systemWallpaperImage = image
                    }
                    return
                }
            }
            
            // 方法2: 使用 NSWorkspace API
            if let screen = NSScreen.main,
               let wallpaperURL = NSWorkspace.shared.desktopImageURL(for: screen),
               let image = NSImage(contentsOf: wallpaperURL) {
                DispatchQueue.main.async {
                    self.systemWallpaperImage = image
                }
                return
            }
            
            // 方法3: 尝试常见的壁纸位置
            let fallbackPaths = [
                "/System/Library/CoreServices/DefaultDesktop.heic",
                "/Library/Desktop Pictures/Monterey Graphic.heic"
            ]
            
            for path in fallbackPaths {
                if let image = NSImage(contentsOfFile: path) {
                    DispatchQueue.main.async {
                        self.systemWallpaperImage = image
                    }
                    return
                }
            }
        }
    }
    
    /// 从 desktoppicture.db 数据库读取当前壁纸路径
    private func getWallpaperFromDatabase() -> String? {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser.path
        let dbPath = "\(homeDir)/Library/Application Support/Dock/desktoppicture.db"
        
        // 检查数据库是否存在
        guard FileManager.default.fileExists(atPath: dbPath) else { return nil }
        
        var db: OpaquePointer?
        
        // 打开数据库（只读模式）
        guard sqlite3_open_v2(dbPath, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else {
            return nil
        }
        
        defer { sqlite3_close(db) }
        
        // 查询数据表获取壁纸路径
        let query = "SELECT value FROM data WHERE value LIKE '%.jpg' OR value LIKE '%.jpeg' OR value LIKE '%.png' OR value LIKE '%.heic' LIMIT 1;"
        
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return nil
        }
        
        defer { sqlite3_finalize(statement) }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            if let cString = sqlite3_column_text(statement, 0) {
                var path = String(cString: cString)
                
                // 展开 ~ 为完整路径
                if path.hasPrefix("~") {
                    path = path.replacingOccurrences(of: "~", with: homeDir)
                }
                
                // 检查文件是否存在
                if FileManager.default.fileExists(atPath: path) {
                    return path
                }
            }
        }
        
        return nil
    }
    
    /// 沉浸式背景
    @ViewBuilder
    private func immersiveBackground(for env: SpatialEnvironment, in size: CGSize) -> some View {
        let colors = env.gradientColors
        
        ZStack {
            // 基础渐变
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom
            )
            
            // 动态光晕
            RadialGradient(
                colors: [
                    colors[1].opacity(0.5),
                    colors[1].opacity(0.2),
                    .clear
                ],
                center: animateGradient ? UnitPoint(x: 0.7, y: 0.4) : UnitPoint(x: 0.3, y: 0.6),
                startRadius: 50,
                endRadius: size.width * 0.5
            )
            
            // 次级光晕
            if colors.count > 2 {
                RadialGradient(
                    colors: [
                        colors[2].opacity(0.3),
                        .clear
                    ],
                    center: animateGradient ? UnitPoint(x: 0.2, y: 0.7) : UnitPoint(x: 0.8, y: 0.3),
                    startRadius: 30,
                    endRadius: size.width * 0.35
                )
            }
            
            // 环境特定的暖光效果
            switch env {
            case .livingRoom:
                // 壁炉暖光
                RadialGradient(
                    colors: [
                        Color(hex: "FF6B00").opacity(0.15),
                        Color(hex: "8B4513").opacity(0.08),
                        .clear
                    ],
                    center: UnitPoint(x: 0.5, y: 0.65),
                    startRadius: 0,
                    endRadius: size.height * 0.4
                )
                
            case .darkStudy:
                // 台灯光
                RadialGradient(
                    colors: [
                        Color(hex: "FFD700").opacity(0.12),
                        .clear
                    ],
                    center: UnitPoint(x: 0.3, y: 0.4),
                    startRadius: 0,
                    endRadius: size.width * 0.25
                )
                
            case .auroraNight:
                // 极光效果
                RadialGradient(
                    colors: [
                        Color(hex: "00ff87").opacity(animateGradient ? 0.2 : 0.1),
                        Color(hex: "60efff").opacity(0.15),
                        .clear
                    ],
                    center: animateGradient ? UnitPoint(x: 0.3, y: 0.3) : UnitPoint(x: 0.7, y: 0.4),
                    startRadius: 50,
                    endRadius: size.width * 0.5
                )
                
            case .sunsetBeach:
                // 日落光晕
                RadialGradient(
                    colors: [
                        Color(hex: "ff9500").opacity(0.25),
                        Color(hex: "ff6b6b").opacity(0.15),
                        .clear
                    ],
                    center: UnitPoint(x: 0.5, y: 0.3),
                    startRadius: 50,
                    endRadius: size.width * 0.6
                )
                
            default:
                EmptyView()
            }
        }
    }
    
    /// 暗角效果
    private func vignetteOverlay(in size: CGSize) -> some View {
        RadialGradient(
            colors: [
                .clear,
                .clear,
                .black.opacity(0.15),
                .black.opacity(0.35)
            ],
            center: .center,
            startRadius: size.width * 0.3,
            endRadius: size.width * 0.8
        )
    }
}

/// NSVisualEffectView 包装器
struct VisualEffectBlur: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

#Preview {
    SpatialBackgroundView(environment: .livingRoom)
        .frame(width: 1200, height: 800)
}
