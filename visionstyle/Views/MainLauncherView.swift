//
//  MainLauncherView.swift
//  visionstyle
//
//  SpatialLaunch 主启动器视图
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI

/// 主启动器视图
struct MainLauncherView: View {
    @State private var themeManager = ThemeManager()
    @State private var appStateManager = AppStateManager()
    
    @State private var showEnterAnimation = false
    @State private var contentOpacity: Double = 0
    @State private var showSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景层
                SpatialBackgroundView(
                    environment: themeManager.currentEnvironment,
                    useSystemWallpaper: themeManager.useSystemWallpaper,
                    spatialCustomBackgroundPath: themeManager.spatialCustomImagePath
                )
                
                // 主内容层 - 网格区域需要避开左侧 Dock
                mainContent(in: geometry.size)
                    .opacity(contentOpacity)
                    .scaleEffect(showEnterAnimation ? 1.0 : 0.92)
                
                // 左侧 Dock（仅空间模式显示）
                if themeManager.showSidebar {
                    sidebarDock
                        .opacity(contentOpacity)
                        .position(x: showEnterAnimation ? 50 : -10, y: geometry.size.height / 2)
                }
                
                // 右上角设置按钮（仅经典模式显示）
                // 移除经典模式设置按钮
                
                // 加载指示器
                if appStateManager.isLoading {
                    loadingIndicator
                }
                
                // 设置面板
                if showSettings {
                    SettingsView(
                        themeManager: themeManager,
                        onClose: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                showSettings = false
                            }
                        }
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                
                // 文件夹展开浮层
                if let folder = appStateManager.selectedFolder, case .folder(let id, let name, let apps) = folder {
                    FolderExpandedView(
                        folderId: id,
                        initialName: name,
                        apps: apps,
                        onClose: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                appStateManager.selectedFolder = nil
                            }
                        },
                        onAppTap: { app in
                            appStateManager.launchApp(app)
                            appStateManager.selectedFolder = nil
                        },
                        onRemoveApp: { bundleId in
                            withAnimation(.spring()) {
                                appStateManager.removeAppFromFolder(bundleId: bundleId, folderId: id)
                                // 更新当前的 view 状态或关闭
                                if let el = appStateManager.gridElements.first(where: { $0.id == id }),
                                   case .folder(_, _, let ids) = el,
                                   ids.count > 1 {
                                    let remaining = apps.filter { ids.contains($0.bundleIdentifier) }
                                    appStateManager.selectedFolder = .folder(id: id, name: name, apps: remaining)
                                } else {
                                    appStateManager.selectedFolder = nil
                                }
                            }
                        },
                        onRename: { newName in
                            appStateManager.renameFolder(id: id, newName: newName)
                            appStateManager.selectedFolder = .folder(id: id, name: newName, apps: apps)
                        }
                    )
                }

            }
            .onAppear {
                // 根据屏幕尺寸动态计算每页应用数量
                updateAppsPerPage(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                updateAppsPerPage(for: newSize)
            }
        }
        .ignoresSafeArea()
        // 两指滑动（滚轮事件）切换页面
        .onScrollWheelHandler(appStateManager: appStateManager)
        // 键盘左右箭头切换页面
        .onKeyPress(.leftArrow) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                appStateManager.previousPage()
            }
            return .handled
        }
        .onKeyPress(.rightArrow) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                appStateManager.nextPage()
            }
            return .handled
        }
        .onExitCommand {
            if showSettings {
                withAnimation {
                    showSettings = false
                }
            } else {
                NSApp.hide(nil)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .refreshApps)) { _ in
            appStateManager.loadApplications()
        }
        // Toggle theme handler removed
        .onAppear {
            // 直接启动主内容，不显示开屏动画
            startMainContent()
        }
    }
    
    /// 启动主内容
    private func startMainContent() {
        appStateManager.loadApplications()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
            showEnterAnimation = true
            contentOpacity = 1.0
        }
    }
    
    /// 根据屏幕尺寸更新每页应用数量
    private func updateAppsPerPage(for size: CGSize) {
        // 计算可用于网格的实际区域（减去搜索栏、分页指示器等）
        let availableHeight = size.height * 0.8 // 大约 80% 用于网格
        let availableWidth = size.width * 0.9   // 大约 90% 用于网格
        let gridSize = CGSize(width: availableWidth, height: availableHeight)
        
        let newAppsPerPage = ClassicGridLayout.calculateAppsPerPage(for: gridSize)
        
        // 只有当值变化时才更新，避免不必要的刷新
        if appStateManager.appsPerPage != newAppsPerPage {
            appStateManager.appsPerPage = newAppsPerPage
        }
    }
    
    /// 主内容区域
    @ViewBuilder
    private func mainContent(in size: CGSize) -> some View {
        // 计算左侧边距（给 Dock 留出空间）
        let leftPadding: CGFloat = themeManager.showSidebar ? 120 : 50
        let rightPadding: CGFloat = 50
        
        VStack(spacing: 0) {
            // 顶部搜索栏
            SearchBarView(searchText: $appStateManager.searchText)
                .padding(.top, 50)
            
            Spacer()
            
            // 应用网格区域
            appGridContent(in: size)
                .padding(.leading, leftPadding)
                .padding(.trailing, rightPadding)
            
            Spacer()
            
            // 底部页面指示器
            if appStateManager.totalPages > 1 {
                PageIndicatorView(
                    currentPage: appStateManager.currentPageIndex,
                    totalPages: appStateManager.totalPages,
                    onPageTap: { page in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            appStateManager.currentPageIndex = page
                        }
                    }
                )
                .padding(.bottom, 35)
            }
        }
    }
    
    /// 应用网格内容
    @ViewBuilder
    private func appGridContent(in size: CGSize) -> some View {
        switch themeManager.layoutMode {
        case .honeycomb:
            // VisionOS 蜂巢布局
            PaginatedHoneycombView(
                stateManager: appStateManager,
                themeManager: themeManager
            )
            .frame(height: size.height * 0.70)
        case .classic:
            // 经典网格布局（传统 Launchpad 风格）
            PaginatedClassicView(
                stateManager: appStateManager,
                themeManager: themeManager
            )
            .frame(height: size.height * 0.75)
        }
    }
    
    /// 左侧 Dock
    private var sidebarDock: some View {
        SidebarDockView(showSettings: $showSettings)
            .frame(width: 80)
    }
    
    /// 右上角设置按钮（经典模式）
    private var classicSettingsButton: some View {
        VStack {
            HStack {
                Spacer()
                
                ToolbarButton(
                    icon: "gearshape.fill",
                    action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showSettings = true
                        }
                    },
                    tooltip: "设置"
                )
            }
            .padding(.top, 18)
            .padding(.trailing, 18)
            
            Spacer()
        }
    }
    
    /// 加载指示器
    private var loadingIndicator: some View {
        VStack(spacing: 18) {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.5)
                .tint(.white)
            
            Text(L10n.Loading.scanning)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.85))
        }
        .padding(35)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
    }
}

/// 工具栏按钮 - 半透明玻璃设计
struct ToolbarButton: View {
    let icon: String
    let action: () -> Void
    let tooltip: String
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(isHovered ? 1.0 : 0.65))
                .frame(width: 36, height: 36)
                .background {
                    Circle()
                        .fill(.white.opacity(isHovered ? 0.25 : 0.12))
                        .background {
                            Circle()
                                .fill(.ultraThinMaterial.opacity(0.5))
                        }
                        .shadow(color: .black.opacity(0.15), radius: isHovered ? 10 : 6, x: 0, y: isHovered ? 4 : 2)
                }
                .overlay {
                    Circle()
                        .strokeBorder(.white.opacity(isHovered ? 0.4 : 0.2), lineWidth: 0.8)
                }
        }
        .buttonStyle(.plain)
        .scaleEffect(isHovered ? 1.1 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .help(tooltip)
    }
}

#Preview {
    MainLauncherView()
        .frame(width: 1400, height: 900)
}
