//
//  GridElement.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2026/02/24.
//

import Foundation
import SwiftUI

/// 持久化存储的网格元素模型
enum GridElement: Codable, Identifiable, Hashable {
    /// 单个应用
    case app(bundleId: String)
    /// 应用文件夹
    case folder(id: String, name: String, bundleIds: [String])
    
    var id: String {
        switch self {
        case .app(let bundleId):
            return bundleId
        case .folder(let id, _, _):
            return id
        }
    }
}

/// 用于 UI 渲染的网格元素模型 (附带图片资源)
enum GridItemData: Identifiable, Hashable {
    /// 独立应用
    case app(ScannedApp)
    /// 文件夹集
    case folder(id: String, name: String, apps: [ScannedApp])
    
    var id: String {
        switch self {
        case .app(let a):
            return a.bundleIdentifier
        case .folder(let id, _, _):
            return id
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: GridItemData, rhs: GridItemData) -> Bool {
        lhs.id == rhs.id
    }
}
