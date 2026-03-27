//
//  AppScannerService.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import Foundation
import AppKit

/// 应用扫描服务 - 扫描系统中的已安装应用
final class AppScannerService {
    
    /// 单例实例
    static let shared = AppScannerService()
    
    private init() {}
    
    /// 扫描目录列表
    private let scanDirectories: [String] = [
        "/Applications",
        NSHomeDirectory() + "/Applications",
        "/System/Applications",
        "/System/Applications/Utilities"
    ]
    
    /// 获取所有已安装的应用
    func scanApplications() -> [ScannedApp] {
        var applications: [ScannedApp] = []
        let fileManager = FileManager.default
        
        for directory in scanDirectories {
            guard let contents = try? fileManager.contentsOfDirectory(atPath: directory) else {
                continue
            }
            
            for item in contents {
                guard item.hasSuffix(".app") else { continue }
                
                let appPath = (directory as NSString).appendingPathComponent(item)
                
                if let app = extractAppInfo(from: appPath) {
                    // 避免重复添加
                    if !applications.contains(where: { $0.bundleIdentifier == app.bundleIdentifier }) {
                        applications.append(app)
                    }
                }
            }
        }
        
        // 按名称排序
        return applications.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    /// 从应用路径提取信息
    private func extractAppInfo(from path: String) -> ScannedApp? {
        let url = URL(fileURLWithPath: path)
        
        // 使用 NSBundle 来获取本地化信息
        guard let bundle = Bundle(url: url) else {
            return nil
        }
        
        // 获取 Bundle Identifier
        guard let bundleIdentifier = bundle.bundleIdentifier else {
            return nil
        }
        
        // 获取本地化应用名称
        // 优先级：本地化的 CFBundleDisplayName > 本地化的 CFBundleName > Info.plist 中的名称 > 文件名
        let name = getLocalizedAppName(bundle: bundle, path: path)
        
        // 获取应用图标
        let icon = NSWorkspace.shared.icon(forFile: path)
        
        return ScannedApp(
            name: name,
            bundleIdentifier: bundleIdentifier,
            path: path,
            icon: icon
        )
    }
    
    /// 获取本地化的应用名称
    private func getLocalizedAppName(bundle: Bundle, path: String) -> String {
        // 方法1：尝试从 bundle 的 localizedInfoDictionary 获取（这会返回当前语言的本地化信息）
        if let localizedInfo = bundle.localizedInfoDictionary {
            if let displayName = localizedInfo["CFBundleDisplayName"] as? String, !displayName.isEmpty {
                return displayName
            }
            if let bundleName = localizedInfo["CFBundleName"] as? String, !bundleName.isEmpty {
                return bundleName
            }
        }
        
        // 方法2：从 infoDictionary 获取
        if let info = bundle.infoDictionary {
            if let displayName = info["CFBundleDisplayName"] as? String, !displayName.isEmpty {
                return displayName
            }
            if let bundleName = info["CFBundleName"] as? String, !bundleName.isEmpty {
                return bundleName
            }
            if let executableName = info["CFBundleExecutable"] as? String, !executableName.isEmpty {
                return executableName
            }
        }
        
        // 方法3：使用文件名
        return (path as NSString).lastPathComponent.replacingOccurrences(of: ".app", with: "")
    }
    
    /// 获取应用图标
    func getAppIcon(for path: String) -> NSImage {
        return NSWorkspace.shared.icon(forFile: path)
    }
    
    /// 启动应用
    func launchApplication(at path: String) {
        let url = URL(fileURLWithPath: path)
        NSWorkspace.shared.openApplication(at: url, configuration: .init()) { _, error in
            if let error = error {
                print("⚠️ 启动应用失败: \(error.localizedDescription)")
            }
        }
    }
}

/// 扫描到的应用临时模型
struct ScannedApp: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let bundleIdentifier: String
    let path: String
    let icon: NSImage
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(bundleIdentifier)
    }
    
    static func == (lhs: ScannedApp, rhs: ScannedApp) -> Bool {
        lhs.bundleIdentifier == rhs.bundleIdentifier
    }
}
