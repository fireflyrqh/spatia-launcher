//
//  VisionOSAppIconView.swift
//  visionstyle
//
//  VisionOS 风格的应用图标视图
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI
import AppKit

/// VisionOS 风格应用图标视图
struct VisionOSAppIconView: View {
    let app: ScannedApp
    var onTap: () -> Void
    
    @State private var isHovered: Bool = false
    @State private var isPressed: Bool = false
    @State private var mousePosition: CGPoint = CGPoint(x: 50, y: 50)
    
    /// 图标尺寸
    private let iconSize: CGFloat = 100
    
    var body: some View {
        VStack(spacing: 10) {
            // 图标
            iconView
            
            // 应用名称
            Text(app.name)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(width: iconSize + 40)
                .shadow(color: .black.opacity(0.7), radius: 3, x: 0, y: 1)
        }
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
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
        // 右键上下文菜单
        .contextMenu {
            Button {
                openApp()
            } label: {
                Label("Open", systemImage: "arrow.up.forward.app")
            }
            
            Divider()
            
            Button {
                showInFinder()
            } label: {
                Label("Show in Finder", systemImage: "folder")
            }
            
            Button {
                getInfo()
            } label: {
                Label("Get Info", systemImage: "info.circle")
            }
            
            Button {
                quickLook()
            } label: {
                Label("Quick Look", systemImage: "eye")
            }
            
            Divider()
            
            Button {
                shareApp()
            } label: {
                Label("Share...", systemImage: "square.and.arrow.up")
            }
        }
        // 点击手势
        .onTapGesture {
            withAnimation(.spring(response: 0.15, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.15, dampingFraction: 0.6)) {
                    isPressed = false
                }
                onTap()
            }
        }
    }
    
    // MARK: - Context Menu Actions
    
    private func openApp() {
        let url = URL(fileURLWithPath: app.path)
        NSWorkspace.shared.openApplication(at: url, configuration: .init()) { _, _ in }
    }
    
    private func showInFinder() {
        let url = URL(fileURLWithPath: app.path)
        NSWorkspace.shared.selectFile(app.path, inFileViewerRootedAtPath: url.deletingLastPathComponent().path)
    }
    
    private func getInfo() {
        let script = """
        tell application "Finder"
            activate
            open information window of (POSIX file "\(app.path)" as alias)
        end tell
        """
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            appleScript.executeAndReturnError(&error)
        }
    }
    
    private func quickLook() {
        NSWorkspace.shared.selectFile(app.path, inFileViewerRootedAtPath: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let source = CGEventSource(stateID: .hidSystemState)
            let spaceDown = CGEvent(keyboardEventSource: source, virtualKey: 0x31, keyDown: true)
            let spaceUp = CGEvent(keyboardEventSource: source, virtualKey: 0x31, keyDown: false)
            spaceDown?.post(tap: .cghidEventTap)
            spaceUp?.post(tap: .cghidEventTap)
        }
    }
    
    private func shareApp() {
        let url = URL(fileURLWithPath: app.path)
        let picker = NSSharingServicePicker(items: [url])
        if let window = NSApp.keyWindow, let contentView = window.contentView {
            let mouseLocation = NSEvent.mouseLocation
            let windowLocation = window.convertPoint(fromScreen: mouseLocation)
            let viewLocation = contentView.convert(windowLocation, from: nil)
            picker.show(relativeTo: NSRect(origin: viewLocation, size: .zero), of: contentView, preferredEdge: .minY)
        }
    }
    
    /// 图标视图 - 保持原始高清图标
    private var iconView: some View {
        ZStack {
            // 悬浮时的外发光
            if isHovered {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        RadialGradient(
                            colors: [
                                .white.opacity(0.35),
                                .white.opacity(0.1),
                                .clear
                            ],
                            center: .center,
                            startRadius: iconSize * 0.3,
                            endRadius: iconSize * 0.65
                        )
                    )
                    .frame(width: iconSize * 1.35, height: iconSize * 1.35)
                    .blur(radius: 10)
            }
            
            // 原始高清图标
            Image(nsImage: app.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                // 玻璃高光效果
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: .white.opacity(isHovered ? 0.35 : 0.2), location: 0),
                                    .init(color: .white.opacity(0.05), location: 0.25),
                                    .init(color: .clear, location: 0.4)
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                }
                // 边框高光
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(isHovered ? 0.6 : 0.3),
                                    .white.opacity(0.1),
                                    .clear,
                                    .white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isHovered ? 1.8 : 1
                        )
                }
                // 阴影
                .shadow(color: .black.opacity(0.45), radius: isHovered ? 14 : 8, x: 0, y: isHovered ? 7 : 4)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
        }
        .scaleEffect(isPressed ? 0.92 : (isHovered ? 1.06 : 1.0))
        .offset(x: isHovered ? parallaxOffset.width * 0.3 : 0,
                y: isHovered ? parallaxOffset.height * 0.3 : 0)
        .rotation3DEffect(
            .degrees(isHovered ? tiltAngle.x : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .rotation3DEffect(
            .degrees(isHovered ? tiltAngle.y : 0),
            axis: (x: 1, y: 0, z: 0)
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .animation(.spring(response: 0.15, dampingFraction: 0.6), value: isPressed)
    }
    
    /// 3D 视差偏移
    private var parallaxOffset: CGSize {
        let maxOffset: CGFloat = 3
        let centerX = iconSize / 2
        let centerY = iconSize / 2
        
        return CGSize(
            width: ((mousePosition.x - centerX) / centerX) * maxOffset,
            height: ((mousePosition.y - centerY) / centerY) * maxOffset
        )
    }
    
    /// 3D 倾斜角度
    private var tiltAngle: (x: Double, y: Double) {
        let maxTilt: Double = 5
        let centerX = iconSize / 2
        let centerY = iconSize / 2
        
        let xTilt = ((mousePosition.x - centerX) / centerX) * maxTilt
        let yTilt = -((mousePosition.y - centerY) / centerY) * maxTilt
        
        return (x: xTilt, y: yTilt)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(hex: "8B7355"), Color(hex: "4A3C31")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        HStack(spacing: 50) {
            VisionOSAppIconView(
                app: ScannedApp(
                    name: "Safari",
                    bundleIdentifier: "com.apple.Safari",
                    path: "/Applications/Safari.app",
                    icon: NSWorkspace.shared.icon(forFile: "/Applications/Safari.app")
                ),
                onTap: {}
            )
        }
    }
    .frame(width: 300, height: 250)
}
