//
//  FolderContentView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI

/// VisionOS 风格文件夹内容弹窗视图
struct FolderContentView: View {
    let folderName: String
    let apps: [ScannedApp]
    let iconShape: IconShape
    var onAppTap: (ScannedApp) -> Void
    var onClose: () -> Void
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // 背景遮罩
            Color.black.opacity(showContent ? 0.5 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissFolder()
                }
            
            // 文件夹内容窗口
            VStack(spacing: 20) {
                // 标题栏
                HStack {
                    Text(folderName)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        dismissFolder()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                // 应用网格
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 20)
                ], spacing: 20) {
                    ForEach(apps) { app in
                        FolderAppIconView(
                            app: app,
                            iconShape: iconShape,
                            onTap: {
                                onAppTap(app)
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: 600)
            .background {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.4), radius: 40, x: 0, y: 20)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear, .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .scaleEffect(showContent ? 1.0 : 0.8)
            .opacity(showContent ? 1.0 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
    
    private func dismissFolder() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onClose()
        }
    }
}

/// 文件夹内的应用图标视图（较小尺寸）
struct FolderAppIconView: View {
    let app: ScannedApp
    let iconShape: IconShape
    var onTap: () -> Void
    
    @State private var isHovered: Bool = false
    @State private var isPressed: Bool = false
    
    private let iconSize: CGFloat = 80
    
    var body: some View {
        VStack(spacing: 8) {
            Image(nsImage: app.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .clipShape(
                    iconShape == .circle
                        ? AnyShape(Circle())
                        : AnyShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                )
                .overlay {
                    Group {
                        if iconShape == .circle {
                            Circle()
                                .strokeBorder(.white.opacity(isHovered ? 0.5 : 0.2), lineWidth: 1.5)
                        } else {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(.white.opacity(isHovered ? 0.5 : 0.2), lineWidth: 1.5)
                        }
                    }
                }
                .shadow(color: .black.opacity(0.3), radius: isHovered ? 15 : 8, x: 0, y: isHovered ? 8 : 4)
                .scaleEffect(isPressed ? 0.92 : (isHovered ? 1.1 : 1.0))
            
            Text(app.name)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: iconSize + 10)
        }
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                    onTap()
                }
        )
    }
}

/// 类型擦除的形状包装器
struct AnyShape: Shape, @unchecked Sendable {
    private let path: @Sendable (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        path = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        path(rect)
    }
}

#Preview {
    ZStack {
        Color.black
        
        FolderContentView(
            folderName: "工具",
            apps: [
                ScannedApp(
                    name: "Safari",
                    bundleIdentifier: "com.apple.Safari",
                    path: "/Applications/Safari.app",
                    icon: NSWorkspace.shared.icon(forFile: "/Applications/Safari.app")
                )
            ],
            iconShape: .circle,
            onAppTap: { _ in },
            onClose: {}
        )
    }
    .frame(width: 800, height: 600)
}
