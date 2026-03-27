//
//  visionstyleApp.swift
//  visionstyle
//
//  SpatialLaunch - VisionOS 风格的 macOS 应用启动器
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI
import SwiftData

@main
struct SpatialLaunchApp: App {
    /// SwiftData 模型容器
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AppItem.self,
            FolderItem.self,
            PageConfig.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("无法创建 ModelContainer: \(error)")
        }
    }()
    
    /// App Delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainLauncherView()
                .frame(minWidth: 1200, minHeight: 800)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .modelContainer(sharedModelContainer)
        .commands {
            // 移除默认命令
            CommandGroup(replacing: .newItem) {}
            
            CommandMenu("视图") {
                Button("刷新应用列表") {
                    NotificationCenter.default.post(name: .refreshApps, object: nil)
                }
                .keyboardShortcut("r", modifiers: .command)
                
                Divider()
                
                Button("切换主题") {
                    NotificationCenter.default.post(name: .toggleTheme, object: nil)
                }
                .keyboardShortcut("t", modifiers: [.command, .shift])
                
                Divider()
                
                Button("隐藏启动器") {
                    NSApp.hide(nil)
                }
                .keyboardShortcut(.escape, modifiers: [])
            }
        }
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    /// ESC 键事件监听器
    private var escKeyMonitor: Any?
    
    func application(_ application: NSApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        // 禁止恢复之前的窗口状态（如全屏），确保每次都以自定义的无边框模式启动
        return false
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 隐藏系统菜单栏
        NSApp.presentationOptions = [.hideMenuBar, .hideDock]
        
        // 配置窗口
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setupWindow()
        }
        
        // 注册全局热键
        GlobalHotKeyManager.shared.registerHotKey {
            self.toggleLauncher()
        }
        
        // 注册 ESC 键监听器
        setupEscKeyMonitor()
        
        // 记录应用打开次数并在第20次时请求评分
        AppReviewManager.shared.recordLaunchAndRequestReviewIfNeeded()
        
        // 启动桌面宠物
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            PetWindowManager.shared.showPet()
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // 移除事件监听器
        if let monitor = escKeyMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    /// 设置 ESC 键监听器
    private func setupEscKeyMonitor() {
        escKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // 检查是否按下 ESC 键 (keyCode = 53)
            if event.keyCode == 53 {
                // 隐藏应用
                NSApp.hide(nil)
                return nil // 阻止事件继续传播
            }
            return event
        }
    }
    
    /// 设置窗口
    private func setupWindow() {
        guard let window = NSApp.windows.first else { return }
        
        // 安全检查：如果窗口当前处于系统全屏模式，先退出全屏
        if window.styleMask.contains(.fullScreen) {
            // 监听退出全屏通知，在退出后再应用样式
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(applyBorderlessStyle(_:)),
                name: NSWindow.didExitFullScreenNotification,
                object: window
            )
            window.toggleFullScreen(nil)
            return
        }
        
        // 直接应用无边框样式
        applyBorderlessStyle(nil)
    }
    
    /// 应用无边框样式（在非全屏模式下调用）
    @objc private func applyBorderlessStyle(_ notification: Notification?) {
        guard let window = (notification?.object as? NSWindow) ?? NSApp.windows.first else { return }
        
        // 移除监听器（如果是通过通知调用的）
        if notification != nil {
            NotificationCenter.default.removeObserver(self, name: NSWindow.didExitFullScreenNotification, object: window)
        }
        
        // 1. 设置无边框效果
        // 确保此时不包含 .fullScreen，否则会 Crash
        if !window.styleMask.contains(.fullScreen) {
            // 纯无边框不会带有默认圆角
            window.styleMask = [.borderless]
        }
        
        // 2. 隐藏标题栏组件
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        
        // 3. 透明背景
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        
        // 4. 设置层级 - .floating 保证覆盖 Dock 和 Deskto
        window.level = .floating
        
        // 5. 设置全屏 Frame
        if let screen = NSScreen.main {
            window.setFrame(screen.frame, display: true)
        }
        
        // 6. 行为设置
        window.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle, .fullScreenAuxiliary]
        window.isMovable = false
        window.isMovableByWindowBackground = false
    }
    
    // (移除了 windowDidExitFullScreen 和 enterFullScreen，因为不再使用系统全屏)
    
    /// 切换启动器显示/隐藏
    private func toggleLauncher() {
        if NSApp.isActive {
            NSApp.hide(nil)
        } else {
            NSApp.activate(ignoringOtherApps: true)
            // 重新确保全屏覆盖
            if let window = NSApp.windows.first, let screen = NSScreen.main {
                window.setFrame(screen.frame, display: true)
                window.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        // 应用激活时确保窗口可见
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let refreshApps = Notification.Name("refreshApps")
    static let toggleTheme = Notification.Name("toggleTheme")
}
