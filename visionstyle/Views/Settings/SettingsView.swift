//
//  SettingsView.swift
//  visionstyle
//
//  根据系统主题自适应的设置面板
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI

/// 设置视图面板 - 亮色/深色自适应
struct SettingsView: View {
    @Bindable var themeManager: ThemeManager
    var onClose: () -> Void
    
    @State private var showContent = false
    @Environment(\.colorScheme) private var colorScheme
    
    /// 主色调（根据系统主题）
    private var primaryColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    /// 次要色调
    private var secondaryColor: Color {
        colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.6)
    }
    
    /// 弱化色调
    private var tertiaryColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.4)
    }
    
    var body: some View {
        ZStack {
            // 背景遮罩
            Color.black.opacity(showContent ? 0.5 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissSettings()
                }
            
            // 设置面板
            VStack(spacing: 0) {
                // 标题栏
                headerView
                
                Divider()
                
                // 设置内容
                ScrollView {
                    VStack(spacing: 24) {
                        // 空间环境设置
                        environmentSection
                        
                        // 快捷键设置
                        shortcutSection
                        
                        // 关于
                        aboutSection
                    }
                    .padding(24)
                }
            }
            .frame(width: 480, height: 560)
            .background {
                // 系统主题自适应材质背景
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.3), radius: 40, x: 0, y: 20)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        colorScheme == .dark
                            ? LinearGradient(colors: [.white.opacity(0.25), .clear, .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [.white.opacity(0.8), .clear, .white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            }
            .scaleEffect(showContent ? 1.0 : 0.9)
            .opacity(showContent ? 1.0 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
    
    /// 标题栏
    private var headerView: some View {
        HStack {
            Text(L10n.Settings.title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(primaryColor)
            
            Spacer()
            
            Button {
                dismissSettings()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(secondaryColor)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }
    
    // 移除 themeSection
    
    /// 空间环境设置区域
    private var environmentSection: some View {
        AdaptiveSettingsSectionView(title: L10n.Settings.environment, icon: "mountain.2.fill") {
            VStack(spacing: 16) {
                // 系统壁纸开关
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.Settings.useSystemWallpaper)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(primaryColor)
                        Text(L10n.About.syncWallpaper)
                            .font(.system(size: 11))
                            .foregroundColor(tertiaryColor)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $themeManager.useSystemWallpaper)
                        .toggleStyle(.switch)
                        .tint(.blue)
                }
                .padding(.vertical, 4)
                
                // 如果关闭了系统壁纸，显示自定义环境选择
                if !themeManager.useSystemWallpaper {
                    Divider()
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(SpatialEnvironment.allCases) { env in
                            AdaptiveEnvironmentOptionView(
                                environment: env,
                                isSelected: themeManager.currentEnvironment == env,
                                onSelect: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        themeManager.currentEnvironment = env
                                    }
                                }
                            )
                        }
                    }
                    
                    // 空间模式自定义背景设置
                    if themeManager.currentEnvironment == .custom {
                        VStack(spacing: 12) {
                            Divider()
                                .padding(.vertical, 4)
                            
                            // 预览
                            if let path = themeManager.spatialCustomImagePath,
                               let image = NSImage(contentsOfFile: path) {
                                Image(nsImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                                    }
                            } else {
                                Text("请选择一张图片作为空间背景")
                                    .font(.system(size: 12))
                                    .foregroundColor(tertiaryColor)
                                    .frame(maxWidth: .infinity, minHeight: 40)
                            }
                            
                            // 按钮
                            HStack(spacing: 12) {
                                Button {
                                    themeManager.selectSpatialCustomImage()
                                } label: {
                                    Label(themeManager.spatialCustomImagePath == nil ? L10n.Settings.selectImage : L10n.Settings.changeImage, systemImage: "folder")
                                        .font(.system(size: 12))
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 移除 classicBackgroundSection
    
    /// 快捷键设置区域
    private var shortcutSection: some View {
        AdaptiveSettingsSectionView(title: L10n.Settings.shortcuts, icon: "command") {
            VStack(spacing: 8) {
                AdaptiveShortcutRow(action: L10n.Shortcut.toggle, shortcut: "⌥ Space")
                AdaptiveShortcutRow(action: L10n.Search.placeholder, shortcut: "⌘ F")
                AdaptiveShortcutRow(action: L10n.Shortcut.switchTheme, shortcut: "⌘ ⇧ T")
                AdaptiveShortcutRow(action: L10n.Shortcut.dragFolder, shortcut: L10n.Shortcut.dragFolderTip)
            }
        }
    }
    
    /// 关于区域
    private var aboutSection: some View {
        AdaptiveSettingsSectionView(title: L10n.Settings.about, icon: "info.circle.fill") {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("SpatialLaunch")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(primaryColor)
                    
                    Spacer()
                    
                    Text("v1.0.0")
                        .font(.system(size: 14))
                        .foregroundColor(tertiaryColor)
                }
                
                Text(L10n.About.description)
                    .font(.system(size: 13))
                    .foregroundColor(secondaryColor)
            }
        }
    }
    
    private func dismissSettings() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onClose()
        }
    }
}

/// 自适应设置区域容器
struct AdaptiveSettingsSectionView<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.6))
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.7))
            }
            
            content()
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.05))
                }
        }
    }
}

// AdaptiveThemeOptionRow Removed

/// 自适应环境选项视图
struct AdaptiveEnvironmentOptionView: View {
    let environment: SpatialEnvironment
    let isSelected: Bool
    var onSelect: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button {
            onSelect()
        } label: {
            VStack(spacing: 8) {
                // 自定义图片选项
                if environment == .custom {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .frame(height: 50)
                        .overlay {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 20))
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.6))
                            
                            if isSelected {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(.blue, lineWidth: 2)
                            }
                        }
                }
                // 真实图片环境 - 显示图片缩略图
                else if environment.hasRealImage {
                    Image(environment.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(.blue, lineWidth: 2)
                            }
                        }
                }
                // 渐变色环境 - 显示渐变色
                else {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: environment.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 50)
                        .overlay {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(.blue, lineWidth: 2)
                            }
                        }
                }
                
                Text(environment.localizedName)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

/// 自适应快捷键行
struct AdaptiveShortcutRow: View {
    let action: String
    let shortcut: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            Text(action)
                .font(.system(size: 13))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.7))
            
            Spacer()
            
            Text(shortcut)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.4))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.08))
                }
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        
        SettingsView(
            themeManager: ThemeManager(),
            onClose: {}
        )
    }
    .frame(width: 800, height: 700)
}
