//
//  AppStateManager.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import Foundation
import SwiftUI
import SwiftData

/// 应用状态管理器 - 管理全局状态
@Observable
final class AppStateManager {
    /// 已扫描的应用列表
    var scannedApps: [ScannedApp] = []
    
    /// 网格元素持久化顺序
    var gridElements: [GridElement] = []
    
    /// 存储键
    private let customOrderKey = "customAppOrder" // 旧数据
    private let gridElementsKey = "gridElements_v2"
    
    /// 当前搜索关键词
    var searchText: String = "" {
        didSet {
            // 搜索文本变化时，重置到第一页
            if searchText != oldValue {
                currentPageIndex = 0
            }
        }
    }
    
    /// 当前页面索引
    var currentPageIndex: Int = 0
    
    /// 是否正在加载
    var isLoading: Bool = false
    
    /// 选中的文件夹（用于展示文件夹内容）
    var selectedFolder: GridItemData? = nil
    
    /// 是否显示设置面板
    var showSettings: Bool = false
    
    /// 每页显示的应用数量（7x5 网格布局）
    var appsPerPage: Int = 35 // 7 * 5
    
    /// 当前拖动的网格项
    var draggingItem: GridItemData? = nil
    
    init() {
        loadCustomOrder()
    }
    
    /// 排序后的网格项列表
    private var orderedItems: [GridItemData] {
        if gridElements.isEmpty {
            return scannedApps.map { .app($0) }
        }
        
        var items: [GridItemData] = []
        var remainingApps = scannedApps
        
        for element in gridElements {
            switch element {
            case .app(let bundleId):
                if let index = remainingApps.firstIndex(where: { $0.bundleIdentifier == bundleId }) {
                    items.append(.app(remainingApps.remove(at: index)))
                }
            case .folder(let id, let name, let bundleIds):
                var folderApps: [ScannedApp] = []
                for bId in bundleIds {
                    if let idx = remainingApps.firstIndex(where: { $0.bundleIdentifier == bId }) {
                        folderApps.append(remainingApps.remove(at: idx))
                    } else if let app = scannedApps.first(where: { $0.bundleIdentifier == bId }) {
                        // 防止重复被移除的情况，找回原始 app
                        folderApps.append(app)
                    }
                }
                if !folderApps.isEmpty {
                    items.append(.folder(id: id, name: name, apps: folderApps))
                }
            }
        }
        
        // 添加未在记录中出现的新应用
        items.append(contentsOf: remainingApps.map { .app($0) })
        
        return items
    }
    
    /// 过滤后的应用列表
    var filteredItems: [GridItemData] {
        let items = orderedItems
        
        guard !searchText.isEmpty else {
            return items
        }
        
        let query = searchText.lowercased()
        return items.filter { item in
            switch item {
            case .app(let app):
                return app.name.lowercased().contains(query) ||
                       matchesPinyinInitials(app.name, query: query) ||
                       app.bundleIdentifier.lowercased().contains(query)
            case .folder(_, let name, let apps):
                if name.lowercased().contains(query) { return true }
                return apps.contains { app in
                    app.name.lowercased().contains(query) ||
                    matchesPinyinInitials(app.name, query: query) ||
                    app.bundleIdentifier.lowercased().contains(query)
                }
            }
        }
    }
    
    /// 总页数
    var totalPages: Int {
        let total = filteredItems.count
        return max(1, Int(ceil(Double(total) / Double(appsPerPage))))
    }
    
    /// 当前页的应用
    var currentPageItems: [GridItemData] {
        let startIndex = currentPageIndex * appsPerPage
        let endIndex = min(startIndex + appsPerPage, filteredItems.count)
        
        guard startIndex < filteredItems.count else {
            return []
        }
        
        return Array(filteredItems[startIndex..<endIndex])
    }
    
    /// 扫描应用
    func loadApplications() {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let apps = AppScannerService.shared.scanApplications()
            
            DispatchQueue.main.async {
                self?.scannedApps = apps
                self?.isLoading = false
                print("✅ 已扫描到 \(apps.count) 个应用")
            }
        }
    }
    
    /// 启动应用
    func launchApp(_ app: ScannedApp) {
        AppScannerService.shared.launchApplication(at: app.path)
        NSApp.hide(nil)
    }
    
    /// 前往下一页
    func nextPage() {
        if currentPageIndex < totalPages - 1 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentPageIndex += 1
            }
        }
    }
    
    /// 前往上一页
    func previousPage() {
        if currentPageIndex > 0 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentPageIndex -= 1
            }
        }
    }
    
    // MARK: - 拖动及文件夹管理
    
    /// 同步最新的 orderedItems 里面的 ID 到底层 gridElements 数组并持久化
    func syncAndSaveElements() {
        let items = orderedItems
        var newElements: [GridElement] = []
        for item in items {
            switch item {
            case .app(let a):
                newElements.append(.app(bundleId: a.bundleIdentifier))
            case .folder(let id, let name, let apps):
                newElements.append(.folder(id: id, name: name, bundleIds: apps.map { $0.bundleIdentifier }))
            }
        }
        gridElements = newElements
        saveCustomOrder()
    }
    
    /// 交换两个项目的位置
    func swapItems(_ item1: GridItemData, with item2: GridItemData) {
        // 先同步一次数据，确保 gridElements 对齐当前显示的网格
        if gridElements.isEmpty { syncAndSaveElements() }
        
        guard let index1 = gridElements.firstIndex(where: { $0.id == item1.id }),
              let index2 = gridElements.firstIndex(where: { $0.id == item2.id }) else {
            return
        }
        
        gridElements.swapAt(index1, index2)
        saveCustomOrder()
    }
    
    /// 将应用组合成新文件夹 (source 合并到 target)
    func groupItems(source: GridItemData, target: GridItemData) {
        if gridElements.isEmpty { syncAndSaveElements() }
        
        guard let sourceIndex = gridElements.firstIndex(where: { $0.id == source.id }),
              let targetIndex = gridElements.firstIndex(where: { $0.id == target.id }) else {
            return
        }
        
        // 提取 Bundle IDs
        var sourceIds: [String] = []
        switch source {
        case .app(let a): sourceIds.append(a.bundleIdentifier)
        case .folder(_, _, let apps): sourceIds.append(contentsOf: apps.map { $0.bundleIdentifier })
        }
        
        var targetIds: [String] = []
        var targetName = "新建文件夹"
        switch target {
        case .app(let a): 
            targetIds.append(a.bundleIdentifier)
        case .folder(_, let name, let apps):
            targetName = name
            targetIds.append(contentsOf: apps.map { $0.bundleIdentifier })
        }
        
        // 合并并去重
        var allIds = targetIds
        for sid in sourceIds {
            if !allIds.contains(sid) {
                allIds.append(sid)
            }
        }
        
        let newFolder = GridElement.folder(
            id: UUID().uuidString,
            name: targetName,
            bundleIds: allIds
        )
        
        // 删掉原来的两个，并在 target 的位置插入新文件夹
        let minIdx = min(sourceIndex, targetIndex)
        let maxIdx = max(sourceIndex, targetIndex)
        gridElements.remove(at: maxIdx)
        gridElements.remove(at: minIdx)
        gridElements.insert(newFolder, at: minIdx)
        
        saveCustomOrder()
    }
    
    /// 重命名文件夹
    func renameFolder(id: String, newName: String) {
        guard let index = gridElements.firstIndex(where: { $0.id == id }) else { return }
        if case .folder(_, _, let bundleIds) = gridElements[index] {
            gridElements[index] = .folder(id: id, name: newName, bundleIds: bundleIds)
            saveCustomOrder()
        }
    }
    
    /// 将 App 从文件夹移出到网格的最后
    func removeAppFromFolder(bundleId: String, folderId: String) {
        guard let index = gridElements.firstIndex(where: { $0.id == folderId }) else { return }
        if case .folder(let id, let name, var bundleIds) = gridElements[index] {
            bundleIds.removeAll(where: { $0 == bundleId })
            if bundleIds.count <= 1 {
                // 解散文件夹
                gridElements.remove(at: index)
                if let lastId = bundleIds.first {
                    gridElements.insert(.app(bundleId: lastId), at: index)
                }
            } else {
                gridElements[index] = .folder(id: id, name: name, bundleIds: bundleIds)
            }
            gridElements.append(.app(bundleId: bundleId))
            saveCustomOrder()
        }
    }
    
    /// 重置应用顺序为默认（按名称排序）
    func resetAppOrder() {
        gridElements = []
        UserDefaults.standard.removeObject(forKey: customOrderKey)
        UserDefaults.standard.removeObject(forKey: gridElementsKey)
        print("✅ 已重置应用顺序")
    }
    
    /// 保存自定义网格结构
    func saveCustomOrder() {
        if let data = try? JSONEncoder().encode(gridElements) {
            UserDefaults.standard.set(data, forKey: gridElementsKey)
        }
    }
    
    /// 加载自定义结构，包括对旧版本数据的迁移
    private func loadCustomOrder() {
        if let data = UserDefaults.standard.data(forKey: gridElementsKey),
           let elements = try? JSONDecoder().decode([GridElement].self, from: data) {
            self.gridElements = elements
        } else if let oldOrder = UserDefaults.standard.array(forKey: customOrderKey) as? [String] {
            // 数据迁移
            self.gridElements = oldOrder.map { .app(bundleId: $0) }
            saveCustomOrder()
        }
    }
    
    /// 拼音首字母匹配（简化版）
    private func matchesPinyinInitials(_ text: String, query: String) -> Bool {
        var initials = ""
        for char in text {
            let charStr = String(char)
            if let latin = charStr.applyingTransform(.toLatin, reverse: false)?
                .applyingTransform(.stripDiacritics, reverse: false),
               let firstChar = latin.first {
                initials.append(firstChar)
            }
        }
        return initials.lowercased().contains(query.lowercased())
    }
}
