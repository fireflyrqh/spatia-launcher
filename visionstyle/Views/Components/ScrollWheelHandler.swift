//
//  ScrollWheelHandler.swift
//  visionstyle
//
//  两指滑动（触控板滚轮事件）处理器
//  使用 NSEvent.addLocalMonitorForEvents 来捕获滚轮事件
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI
import AppKit

/// 滚轮事件处理视图修饰符 - 使用全局事件监听器
struct ScrollWheelHandlerModifier: ViewModifier {
    let appStateManager: AppStateManager
    
    @State private var eventMonitor: Any?
    @State private var accumulatedDeltaX: CGFloat = 0
    @State private var isScrolling = false
    @State private var hasTriggeredSwipe = false
    
    // 阈值设置
    private let swipeThreshold: CGFloat = 50
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                setupEventMonitor()
            }
            .onDisappear {
                removeEventMonitor()
            }
    }
    
    private func setupEventMonitor() {
        // 使用 addLocalMonitorForEvents 监听应用内的滚轮事件
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { event in
            handleScrollWheel(event)
            return event // 返回事件，让其他处理器也能接收
        }
    }
    
    private func removeEventMonitor() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    private func handleScrollWheel(_ event: NSEvent) {
        // 获取水平滚动增量
        let deltaX = event.scrollingDeltaX
        
        // 忽略垂直滚动为主的事件
        if abs(event.scrollingDeltaY) > abs(deltaX) * 2 {
            return
        }
        
        // 检测滚动阶段
        switch event.phase {
        case .began:
            // 开始新的滚动
            accumulatedDeltaX = 0
            isScrolling = true
            hasTriggeredSwipe = false
            
        case .changed:
            if isScrolling {
                accumulatedDeltaX += deltaX
                
                // 检查是否达到阈值
                if !hasTriggeredSwipe {
                    if accumulatedDeltaX > swipeThreshold {
                        // 向右滑动 -> 上一页
                        hasTriggeredSwipe = true
                        triggerPreviousPage()
                    } else if accumulatedDeltaX < -swipeThreshold {
                        // 向左滑动 -> 下一页
                        hasTriggeredSwipe = true
                        triggerNextPage()
                    }
                }
            }
            
        case .ended, .cancelled:
            isScrolling = false
            accumulatedDeltaX = 0
            hasTriggeredSwipe = false
            
        default:
            // 处理没有阶段信息的滚轮事件（如某些鼠标）
            if event.phase.rawValue == 0 && event.momentumPhase.rawValue == 0 {
                accumulatedDeltaX += deltaX
                
                if !hasTriggeredSwipe {
                    if accumulatedDeltaX > swipeThreshold {
                        hasTriggeredSwipe = true
                        triggerPreviousPage()
                        // 重置
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            accumulatedDeltaX = 0
                            hasTriggeredSwipe = false
                        }
                    } else if accumulatedDeltaX < -swipeThreshold {
                        hasTriggeredSwipe = true
                        triggerNextPage()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            accumulatedDeltaX = 0
                            hasTriggeredSwipe = false
                        }
                    }
                }
            }
        }
    }
    
    private func triggerNextPage() {
        DispatchQueue.main.async {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                appStateManager.nextPage()
            }
        }
    }
    
    private func triggerPreviousPage() {
        DispatchQueue.main.async {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                appStateManager.previousPage()
            }
        }
    }
}

/// View 扩展
extension View {
    func onScrollWheelHandler(appStateManager: AppStateManager) -> some View {
        self.modifier(ScrollWheelHandlerModifier(appStateManager: appStateManager))
    }
}
