//
//  AppIconView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI
import AppKit
import QuickLookUI

/// 应用图标视图 - VisionOS 风格圆形图标
struct AppIconView: View {
    let app: ScannedApp
    let iconShape: IconShape
    var onTap: () -> Void
    var onReorder: ((ScannedApp, ScannedApp) -> Void)? = nil
    
    @State private var isHovered: Bool = false
    @State private var mousePosition: CGPoint = CGPoint(x: 64, y: 64)
    @State private var isPressed: Bool = false
    @State private var isDragging: Bool = false
    @State private var dragOffset: CGSize = .zero
    
    /// 图标尺寸
    private let iconSize: CGFloat = 128
    
    var body: some View {
        VStack(spacing: 10) {
            // 图标容器
            ZStack {
                // 悬浮光晕效果
                if isHovered && !isDragging {
                    glowView
                }
                
                // 主图标
                iconImageView
            }
            .scaleEffect(isDragging ? 1.1 : (isPressed ? 0.95 : (isHovered ? 1.15 : 1.0)))
            .offset(x: isDragging ? dragOffset.width : (isHovered ? parallaxOffset.width : 0),
                    y: isDragging ? dragOffset.height : (isHovered ? parallaxOffset.height : 0))
            .rotation3DEffect(
                .degrees(isHovered && !isDragging ? tiltAngle.x : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .rotation3DEffect(
                .degrees(isHovered && !isDragging ? tiltAngle.y : 0),
                axis: (x: 1, y: 0, z: 0)
            )
            .opacity(isDragging ? 0.8 : 1.0)
            
            // 应用名称
            Text(app.name)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: iconSize + 20)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 1)
                .opacity(isDragging ? 0.6 : 1.0)
        }
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
        .onContinuousHover { phase in
            switch phase {
            case .active(let location):
                mousePosition = location
            case .ended:
                mousePosition = CGPoint(x: iconSize / 2, y: iconSize / 2)
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                    onTap()
                }
        )
        // 右键上下文菜单
        .contextMenu {
            // 打开应用
            Button {
                openApp()
            } label: {
                Label("Open", systemImage: "arrow.up.forward.app")
            }
            
            Divider()
            
            // 在 Finder 中显示
            Button {
                showInFinder()
            } label: {
                Label("Show in Finder", systemImage: "folder")
            }
            
            // 获取信息
            Button {
                getInfo()
            } label: {
                Label("Get Info", systemImage: "info.circle")
            }
            
            // 快速查看
            Button {
                quickLook()
            } label: {
                Label("Quick Look", systemImage: "eye")
            }
            
            Divider()
            
            // 分享
            Button {
                shareApp()
            } label: {
                Label("Share...", systemImage: "square.and.arrow.up")
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
    }
    
    // MARK: - Context Menu Actions
    
    /// 打开应用
    private func openApp() {
        let url = URL(fileURLWithPath: app.path)
        NSWorkspace.shared.openApplication(at: url, configuration: .init()) { _, error in
            if let error = error {
                print("⚠️ 打开应用失败: \(error.localizedDescription)")
            }
        }
    }
    
    /// 在 Finder 中显示
    private func showInFinder() {
        let url = URL(fileURLWithPath: app.path)
        NSWorkspace.shared.selectFile(app.path, inFileViewerRootedAtPath: url.deletingLastPathComponent().path)
    }
    
    /// 获取应用信息
    private func getInfo() {
        // 通过 AppleScript 打开 "获取信息" 窗口
        let script = """
        tell application "Finder"
            activate
            open information window of (POSIX file "\(app.path)" as alias)
        end tell
        """
        
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            appleScript.executeAndReturnError(&error)
            if let error = error {
                print("⚠️ 获取信息失败: \(error)")
            }
        }
    }
    
    /// 快速查看
    private func quickLook() {
        // 使用 QLPreviewPanel 显示快速查看
        NSWorkspace.shared.selectFile(app.path, inFileViewerRootedAtPath: "")
        
        // 模拟按下空格键触发快速查看
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let source = CGEventSource(stateID: .hidSystemState)
            let spaceDown = CGEvent(keyboardEventSource: source, virtualKey: 0x31, keyDown: true)
            let spaceUp = CGEvent(keyboardEventSource: source, virtualKey: 0x31, keyDown: false)
            spaceDown?.post(tap: .cghidEventTap)
            spaceUp?.post(tap: .cghidEventTap)
        }
    }
    
    /// 分享应用
    private func shareApp() {
        let url = URL(fileURLWithPath: app.path)
        let picker = NSSharingServicePicker(items: [url])
        
        // 获取当前窗口并显示分享菜单
        if let window = NSApp.keyWindow,
           let contentView = window.contentView {
            // 获取鼠标位置
            let mouseLocation = NSEvent.mouseLocation
            let windowLocation = window.convertPoint(fromScreen: mouseLocation)
            let viewLocation = contentView.convert(windowLocation, from: nil)
            
            picker.show(relativeTo: NSRect(origin: viewLocation, size: .zero), of: contentView, preferredEdge: .minY)
        }
    }
    
    /// 图标图片视图
    @ViewBuilder
    private var iconImageView: some View {
        Group {
            switch iconShape {
            case .circle:
                Image(nsImage: app.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isHovered ? 0.6 : 0.3),
                                        .white.opacity(0.1),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    }
                    .overlay {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isHovered ? 0.15 : 0.08),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                    }
                
            case .roundedRect:
                Image(nsImage: app.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isHovered ? 0.6 : 0.3),
                                        .white.opacity(0.1),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isHovered ? 0.15 : 0.08),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                    }
            }
        }
        .shadow(color: .black.opacity(0.4), radius: isHovered ? 25 : 15, x: 0, y: isHovered ? 15 : 8)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
    }
    
    /// 悬浮光晕视图
    @ViewBuilder
    private var glowView: some View {
        Group {
            switch iconShape {
            case .circle:
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.2),
                                .clear
                            ],
                            center: .center,
                            startRadius: iconSize * 0.3,
                            endRadius: iconSize * 0.8
                        )
                    )
            case .roundedRect:
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.2),
                                .clear
                            ],
                            center: .center,
                            startRadius: iconSize * 0.3,
                            endRadius: iconSize * 0.8
                        )
                    )
            }
        }
        .frame(width: iconSize * 1.4, height: iconSize * 1.4)
        .blur(radius: 20)
    }
    
    /// 3D 视差偏移
    private var parallaxOffset: CGSize {
        let maxOffset: CGFloat = 5
        let centerX = iconSize / 2
        let centerY = iconSize / 2
        
        return CGSize(
            width: ((mousePosition.x - centerX) / centerX) * maxOffset,
            height: ((mousePosition.y - centerY) / centerY) * maxOffset
        )
    }
    
    /// 3D 倾斜角度
    private var tiltAngle: (x: Double, y: Double) {
        let maxTilt: Double = 8
        let centerX = iconSize / 2
        let centerY = iconSize / 2
        
        let xTilt = ((mousePosition.x - centerX) / centerX) * maxTilt
        let yTilt = -((mousePosition.y - centerY) / centerY) * maxTilt
        
        return (x: xTilt, y: yTilt)
    }
}

#Preview {
    ZStack {
        Color.black
        
        AppIconView(
            app: ScannedApp(
                name: "Safari",
                bundleIdentifier: "com.apple.Safari",
                path: "/Applications/Safari.app",
                icon: NSWorkspace.shared.icon(forFile: "/Applications/Safari.app")
            ),
            iconShape: .circle,
            onTap: {}
        )
    }
    .frame(width: 300, height: 300)
}
