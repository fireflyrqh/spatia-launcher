//
//  SidebarDockView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI

/// 左侧固定坞视图 - 包含快捷应用和设置按钮
struct SidebarDockView: View {
    @Binding var showSettings: Bool
    @State private var hoveredItem: DockItem?
    @State private var isSettingsHovered: Bool = false
    
    /// Dock 中的固定项目
    private let dockItems: [DockItem] = [
        DockItem(name: "App Store", systemIcon: "bag.fill", color: .blue, bundleID: "com.apple.AppStore"),
        DockItem(name: "通讯录", systemIcon: "person.crop.circle.fill", color: .orange, bundleID: "com.apple.AddressBook"),
        DockItem(name: "照片", systemIcon: "photo.fill", color: .pink, bundleID: "com.apple.Photos")
    ]
    
    var body: some View {
        VStack(spacing: 14) {
            // 快捷应用
            ForEach(dockItems) { item in
                SidebarDockIconView(
                    item: item,
                    isHovered: hoveredItem == item
                )
                .onHover { isHovering in
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                        hoveredItem = isHovering ? item : nil
                    }
                }
                .onTapGesture {
                    launchDockApp(bundleID: item.bundleID)
                }
            }
            
            // 分隔线
            Capsule()
                .fill(.white.opacity(0.2))
                .frame(width: 28, height: 1)
                .padding(.vertical, 4)
            
            // 设置按钮
            SettingsButton(isHovered: isSettingsHovered) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showSettings = true
                }
            }
            .onHover { hovering in
                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                    isSettingsHovered = hovering
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 10)
        .background {
            Capsule()
                .fill(.white.opacity(0.12))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
        }
        .overlay {
            Capsule()
                .strokeBorder(.white.opacity(0.2), lineWidth: 0.6)
        }
    }
    
    /// 启动 Dock 应用
    private func launchDockApp(bundleID: String) {
        if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
            NSWorkspace.shared.openApplication(at: appURL, configuration: .init()) { _, error in
                if let error = error {
                    print("⚠️ 无法启动应用: \(error.localizedDescription)")
                }
            }
        }
    }
}

/// 设置按钮
struct SettingsButton: View {
    let isHovered: Bool
    let action: () -> Void
    
    private let iconSize: CGFloat = 40
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // 悬浮光晕
                if isHovered {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .gray.opacity(0.3),
                                    .gray.opacity(0.1),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: iconSize * 0.55
                            )
                        )
                        .frame(width: iconSize * 1.3, height: iconSize * 1.3)
                        .blur(radius: 4)
                }
                
                // 圆形背景
                Circle()
                    .fill(.white.opacity(isHovered ? 0.25 : 0.12))
                    .frame(width: iconSize, height: iconSize)
                    .shadow(color: .black.opacity(0.15), radius: isHovered ? 10 : 6, x: 0, y: isHovered ? 4 : 2)
                    .overlay {
                        Circle()
                            .strokeBorder(.white.opacity(isHovered ? 0.4 : 0.2), lineWidth: 0.8)
                    }
                
                // 齿轮图标
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(isHovered ? 0.9 : 0.7))
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isHovered ? 1.1 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovered)
        .help("设置")
    }
}

/// Dock 项目模型
struct DockItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let systemIcon: String
    let color: Color
    let bundleID: String
}

/// Sidebar Dock 图标视图
struct SidebarDockIconView: View {
    let item: DockItem
    let isHovered: Bool
    
    private let iconSize: CGFloat = 40
    
    var body: some View {
        ZStack {
            // 悬浮光晕
            if isHovered {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                item.color.opacity(0.25),
                                item.color.opacity(0.08),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: iconSize * 0.55
                        )
                    )
                    .frame(width: iconSize * 1.3, height: iconSize * 1.3)
                    .blur(radius: 4)
            }
            
            // 圆形背景
            Circle()
                .fill(.white.opacity(isHovered ? 0.25 : 0.12))
                .frame(width: iconSize, height: iconSize)
                .shadow(color: .black.opacity(0.15), radius: isHovered ? 10 : 6, x: 0, y: isHovered ? 4 : 2)
                .overlay {
                    Circle()
                        .strokeBorder(.white.opacity(isHovered ? 0.4 : 0.2), lineWidth: 0.8)
                }
            
            // 图标
            Image(systemName: item.systemIcon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [item.color, item.color.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .scaleEffect(isHovered ? 1.1 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovered)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(hex: "8B7355"), Color(hex: "5D4037")],
            startPoint: .top,
            endPoint: .bottom
        )
        
        SidebarDockView(showSettings: .constant(false))
    }
    .frame(width: 200, height: 400)
}
