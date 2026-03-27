//
//  DragDropManager.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import Foundation
import SwiftUI

/// 拖拽放置管理器
@Observable
final class DragDropManager {
    /// 当前正在拖拽的应用
    var draggingApp: ScannedApp?
    
    /// 拖拽目标应用（用于创建文件夹）
    var dropTargetApp: ScannedApp?
    
    /// 拖拽悬停时间
    var hoverStartTime: Date?
    
    /// 是否显示文件夹创建提示
    var showFolderHint: Bool = false
    
    /// 文件夹创建阈值时间（秒）
    private let folderCreationThreshold: TimeInterval = 0.5
    
    /// 开始拖拽
    func startDragging(_ app: ScannedApp) {
        draggingApp = app
        dropTargetApp = nil
        hoverStartTime = nil
        showFolderHint = false
    }
    
    /// 悬停在目标上
    func hoverOver(_ target: ScannedApp) {
        guard draggingApp != nil, draggingApp?.id != target.id else { return }
        
        if dropTargetApp?.id != target.id {
            dropTargetApp = target
            hoverStartTime = Date()
            showFolderHint = false
        } else {
            // 检查是否达到文件夹创建时间
            if let startTime = hoverStartTime {
                let elapsed = Date().timeIntervalSince(startTime)
                if elapsed >= folderCreationThreshold {
                    showFolderHint = true
                }
            }
        }
    }
    
    /// 离开目标
    func leaveTarget() {
        dropTargetApp = nil
        hoverStartTime = nil
        showFolderHint = false
    }
    
    /// 结束拖拽
    func endDragging() -> (source: ScannedApp, target: ScannedApp, createFolder: Bool)? {
        guard let source = draggingApp else {
            reset()
            return nil
        }
        
        let result: (source: ScannedApp, target: ScannedApp, createFolder: Bool)?
        
        if let target = dropTargetApp, showFolderHint {
            result = (source, target, true)
        } else if let target = dropTargetApp {
            result = (source, target, false)
        } else {
            result = nil
        }
        
        reset()
        return result
    }
    
    /// 重置状态
    func reset() {
        draggingApp = nil
        dropTargetApp = nil
        hoverStartTime = nil
        showFolderHint = false
    }
}
