//
//  PetManager.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2026/01/30.
//

import Foundation
import SwiftUI
import Observation

/// 宠物动作类型
enum PetAction: String {
    case feed
    case wash
    case play
    
    var localizedName: String {
        switch self {
        case .feed: return L10n.Pet.feed
        case .wash: return L10n.Pet.wash
        case .play: return L10n.Pet.play
        }
    }
    
    var icon: String {
        switch self {
        case .feed: return "fork.knife"
        case .wash: return "drop.fill"
        case .play: return "gamecontroller.fill"
        }
    }
}

/// 宠物数据管理器
@Observable
final class PetManager {
    static let shared = PetManager()
    
    // MARK: - Properties
    
    /// 等级
    var level: Int {
        didSet { savestate() }
    }
    
    /// 当前经验值
    var experience: Int {
        didSet { savestate() }
    }
    
    /// 饥饿度 (0-100)
    var hunger: Double {
        didSet { savestate() }
    }
    
    /// 清洁度 (0-100)
    var cleanliness: Double {
        didSet { savestate() }
    }
    
    /// 快乐度 (0-100)
    var happiness: Double {
        didSet { savestate() }
    }
    
    /// 每日操作次数记录
    private var dailyActionCounts: [String: Int] = [:] // "yyyy-MM-dd-action" -> count
    /// 当前显示的气泡消息
    var currentMessage: String?
    private var messageTimer: Timer?
    private var chatterTimer: Timer?
    
    // MARK: - Constants
    
    private let maxDailyActions = 5 // 每种动作每天限制次数
    private let xpPerAction = 5
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Initialization
    
    init() {
        // 1. 先初始化所有存储属性 (必须满足 Swift 的安全性检查)
        self.level = defaults.integer(forKey: "Pet_Level")
        self.experience = defaults.integer(forKey: "Pet_Experience")
        self.hunger = defaults.double(forKey: "Pet_Hunger")
        self.cleanliness = defaults.double(forKey: "Pet_Cleanliness")
        self.happiness = defaults.double(forKey: "Pet_Happiness")
        self.dailyActionCounts = defaults.object(forKey: "Pet_DailyCounts") as? [String: Int] ?? [:]
        
        // 2. 补充默认值 (此时 self 已完全初始化，可以安全触发 didSet)
        if self.level == 0 { self.level = 1 }
        if defaults.object(forKey: "Pet_Hunger") == nil { self.hunger = 80 }
        if defaults.object(forKey: "Pet_Cleanliness") == nil { self.cleanliness = 80 }
        if defaults.object(forKey: "Pet_Happiness") == nil { self.happiness = 80 }
        
        // 3. 启动定时器消耗状态及闲聊
        startDecayTimer()
        startChatterTimer()
        
        // 4. 显示欢迎词 (稍作延迟等待界面加载)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showMessage(L10n.Pet.chatWelcome, duration: 4.0)
        }
    }
    
    // MARK: - Logic
    
    /// 显示全局消息
    func showMessage(_ text: String, duration: TimeInterval = 3.0) {
        messageTimer?.invalidate()
        withAnimation {
            self.currentMessage = text
        }
        
        messageTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            withAnimation {
                self?.currentMessage = nil
            }
        }
    }
    
    /// 升级所需经验值: 10 * 2^(level-1)
    var maxExperience: Int {
        let base = 10
        let multiplier = NSDecimalNumber(decimal: pow(2, level - 1)).intValue
        return base * multiplier
    }
    
    /// 执行动作
    func performAction(_ action: PetAction) -> (Bool, String) {
        if !canPerformAction(action) {
            return (false, L10n.Pet.limitReached.localized(with: action.localizedName))
        }
        
        // 更新状态
        switch action {
        case .feed:
            hunger = min(100, hunger + 20)
        case .wash:
            cleanliness = min(100, cleanliness + 20)
        case .play:
            happiness = min(100, happiness + 20)
        }
        
        // 增加经验
        addExperience(amount: xpPerAction)
        
        // 记录次数
        recordAction(action)
        
        return (true, L10n.Pet.actionSuccess.localized(with: action.localizedName, xpPerAction))
    }
    
    /// 增加经验
    private func addExperience(amount: Int) {
        experience += amount
        checkLevelUp()
    }
    
    /// 检查升级
    private func checkLevelUp() {
        while experience >= maxExperience {
            experience -= maxExperience
            level += 1
            // 升级奖励：状态回满
            hunger = 100
            cleanliness = 100
            happiness = 100
        }
    }
    
    /// 检查今日是否可以执行动作
    private func canPerformAction(_ action: PetAction) -> Bool {
        let key = dailyKey(for: action)
        let count = dailyActionCounts[key] ?? 0
        return count < maxDailyActions
    }
    
    /// 记录动作次数
    private func recordAction(_ action: PetAction) {
        let key = dailyKey(for: action)
        dailyActionCounts[key] = (dailyActionCounts[key] ?? 0) + 1
        
        // 清理旧数据的简易逻辑：如果字典太大，清理非今天的
        if dailyActionCounts.count > 20 {
            let todayPrefix = formatDate(Date())
            dailyActionCounts = dailyActionCounts.filter { $0.key.hasPrefix(todayPrefix) }
        }
        
        defaults.set(dailyActionCounts, forKey: "Pet_DailyCounts")
    }
    
    private func dailyKey(for action: PetAction) -> String {
        return "\(formatDate(Date()))-\(action.rawValue)"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func savestate() {
        defaults.set(level, forKey: "Pet_Level")
        defaults.set(experience, forKey: "Pet_Experience")
        defaults.set(hunger, forKey: "Pet_Hunger")
        defaults.set(cleanliness, forKey: "Pet_Cleanliness")
        defaults.set(happiness, forKey: "Pet_Happiness")
    }
    
    /// 随时间降低状态
    private func startDecayTimer() {
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.hunger = max(0, self.hunger - 5)
            self.cleanliness = max(0, self.cleanliness - 3)
            self.happiness = max(0, self.happiness - 4)
        }
    }
    
    /// 开启闲聊定时器 (随机触发说话)
    private func startChatterTimer() {
        // 每隔一段随机时间 (例如 2 - 5 分钟) 检查一次是否说话
        let interval = Double.random(in: 120...300)
        chatterTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            // 只有当前没有显示消息时才说话
            if self.currentMessage == nil {
                let messages = [
                    L10n.Pet.chatWater,
                    L10n.Pet.chatRest,
                    L10n.Pet.chatThirsty,
                    L10n.Pet.chatBored
                ]
                if let randomMsg = messages.randomElement() {
                    self.showMessage(randomMsg, duration: 4.0)
                }
            }
            // 重新开启下一轮定时器
            self.startChatterTimer()
        }
    }
}
