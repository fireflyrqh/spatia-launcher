//
//  PetWindowManager.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2026/01/30.
//

import AppKit
import SwiftUI

/// 管理桌面宠物的悬浮窗口
class PetWindowManager {
    static let shared = PetWindowManager()
    
    private var window: NSWindow?
    
    /// 显示宠物
    func showPet() {
        if window == nil {
            createWindow()
        }
        
        window?.makeKeyAndOrderFront(nil)
    }
    
    /// 隐藏宠物
    func hidePet() {
        window?.orderOut(nil)
    }
    
    private func createWindow() {
        // 创建无边框透明窗口，增加高度以容纳气泡
        let w = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 220, height: 260),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // 设置位置：屏幕右下角
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let x = screenFrame.maxX - 250
            let y = screenFrame.minY + 50
            w.setFrameOrigin(NSPoint(x: x, y: y))
        } else {
            w.center()
        }
        
        // 窗口属性
        // 使用比普通的 floating 更高的层级，并确保不会随应用失去焦点而隐藏
        w.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow))) 
        w.backgroundColor = .clear
        w.isOpaque = false
        w.hasShadow = false
        w.isMovableByWindowBackground = true
        // 添加 ignoresMouseEvents 逻辑（SwiftUI 会内部处理点击）
        w.ignoresMouseEvents = false
        
        // canJoinAllSpaces 和 fullScreenAuxiliary 确保多桌面和全屏下可见
        // stationary 确保它像个桌面挂件
        w.collectionBehavior = [
            .canJoinAllSpaces, 
            .fullScreenAuxiliary, 
            .stationary,
            .ignoresCycle
        ]
        
        // 加载 SwiftUI 视图
        let rootView = PetView()
        w.contentView = NSHostingView(rootView: rootView)
        
        self.window = w
    }
}
