//
//  AppItem.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import Foundation
import SwiftUI
import SwiftData

/// 应用项目模型 - 表示一个可启动的应用程序
@Model
final class AppItem: Identifiable {
    /// 唯一标识符
    @Attribute(.unique) var id: String
    
    /// 应用名称
    var name: String
    
    /// 应用的 Bundle Identifier
    var bundleIdentifier: String
    
    /// 应用路径
    var path: String
    
    /// 在网格中的排序索引
    var sortIndex: Int
    
    /// 所属文件夹ID（如果在文件夹中）
    var folderID: String?
    
    /// 所在页面索引
    var pageIndex: Int
    
    init(
        id: String = UUID().uuidString,
        name: String,
        bundleIdentifier: String,
        path: String,
        sortIndex: Int = 0,
        folderID: String? = nil,
        pageIndex: Int = 0
    ) {
        self.id = id
        self.name = name
        self.bundleIdentifier = bundleIdentifier
        self.path = path
        self.sortIndex = sortIndex
        self.folderID = folderID
        self.pageIndex = pageIndex
    }
}

/// 文件夹模型 - 用于组织应用
@Model
final class FolderItem: Identifiable {
    @Attribute(.unique) var id: String
    
    /// 文件夹名称
    var name: String
    
    /// 排序索引
    var sortIndex: Int
    
    /// 所在页面索引
    var pageIndex: Int
    
    init(
        id: String = UUID().uuidString,
        name: String,
        sortIndex: Int = 0,
        pageIndex: Int = 0
    ) {
        self.id = id
        self.name = name
        self.sortIndex = sortIndex
        self.pageIndex = pageIndex
    }
}

/// 页面配置模型
@Model
final class PageConfig {
    @Attribute(.unique) var id: String
    
    /// 页面索引
    var pageIndex: Int
    
    /// 页面内图标数量
    var itemCount: Int
    
    init(
        id: String = UUID().uuidString,
        pageIndex: Int,
        itemCount: Int = 0
    ) {
        self.id = id
        self.pageIndex = pageIndex
        self.itemCount = itemCount
    }
}
