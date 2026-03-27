//
//  AppReviewManager.swift
//  visionstyle
//
//  应用评分请求管理器
//  Created by SpatialLaunch Team on 2025/12/28.
//

import Foundation
import StoreKit
import AppKit

/// 应用评分管理器
final class AppReviewManager {
    
    /// 单例实例
    static let shared = AppReviewManager()
    
    /// 应用打开次数的 UserDefaults 键
    private let launchCountKey = "appLaunchCount"
    
    /// 是否已请求评分的 UserDefaults 键
    private let hasRequestedReviewKey = "hasRequestedReview"
    
    /// 触发评分请求的打开次数阈值
    private let reviewThreshold = 20
    
    private init() {}
    
    /// 记录应用打开次数并在适当时机请求评分
    func recordLaunchAndRequestReviewIfNeeded() {
        let defaults = UserDefaults.standard
        
        // 获取当前打开次数
        var launchCount = defaults.integer(forKey: launchCountKey)
        launchCount += 1
        
        // 保存新的打开次数
        defaults.set(launchCount, forKey: launchCountKey)
        
        print("📊 应用打开次数: \(launchCount)")
        
        // 检查是否达到评分请求条件（第20次打开时请求）
        if launchCount == reviewThreshold {
            requestReview()
        }
    }
    
    /// 请求应用评分
    private func requestReview() {
        print("⭐️ 请求应用评分...")
        
        // 延迟一小段时间，确保应用界面已完全加载
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // macOS 使用 SKStoreReviewController
            SKStoreReviewController.requestReview()
        }
    }
    
    /// 重置评分计数（用于测试）
    func resetLaunchCount() {
        UserDefaults.standard.set(0, forKey: launchCountKey)
        UserDefaults.standard.set(false, forKey: hasRequestedReviewKey)
        print("🔄 评分计数已重置")
    }
    
    /// 获取当前打开次数
    var currentLaunchCount: Int {
        UserDefaults.standard.integer(forKey: launchCountKey)
    }
}
