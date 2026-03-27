//
//  ThemeManager.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import Foundation
import SwiftUI
import Observation

// AppTheme Removed


/// 空间环境背景
enum SpatialEnvironment: String, CaseIterable, Identifiable {
    // 渐变色环境
    case livingRoom = "livingRoom"
    case darkStudy = "darkStudy"
    case alpineMountain = "alpineMountain"
    case auroraNight = "auroraNight"
    case sunsetBeach = "sunsetBeach"
    case zenGarden = "zenGarden"
    
    // 真实图片环境
    case elegantFireplace = "elegantFireplace"      // visionstyle1
    case nordicArt = "nordicArt"                    // visionstyle2
    case modernGray = "modernGray"                  // visionstyle3
    case cloudSunrise = "cloudSunrise"              // visionstyle4
    case lakeMountain = "lakeMountain"              // visionstyle5
    case darkStudio = "darkStudio"                  // visionstyle6
    
    // 自定义图片
    case custom = "custom"
    
    var id: String { rawValue }
    
    /// 本地化的环境名称
    var localizedName: String {
        switch self {
        case .livingRoom: return L10n.Env.livingRoom
        case .darkStudy: return L10n.Env.darkStudy
        case .alpineMountain: return L10n.Env.alpineMountain
        case .auroraNight: return L10n.Env.auroraNight
        case .sunsetBeach: return L10n.Env.sunsetBeach
        case .zenGarden: return L10n.Env.zenGarden
        case .elegantFireplace: return L10n.Env.elegantFireplace
        case .nordicArt: return L10n.Env.nordicArt
        case .modernGray: return L10n.Env.modernGray
        case .cloudSunrise: return L10n.Env.cloudSunrise
        case .lakeMountain: return L10n.Env.lakeMountain
        case .darkStudio: return L10n.Env.darkStudio
        case .custom: return L10n.Env.custom
        }
    }
    
    /// 是否使用真实图片
    var hasRealImage: Bool {
        switch self {
        case .elegantFireplace, .nordicArt, .modernGray, .cloudSunrise, .lakeMountain, .darkStudio:
            return true
        default:
            return false
        }
    }
    
    /// 对应的背景图片名称
    var imageName: String {
        switch self {
        // 原有的渐变环境（没有真实图片）
        case .livingRoom: return "env_living_room"
        case .darkStudy: return "env_dark_study"
        case .alpineMountain: return "env_alpine_mountain"
        case .auroraNight: return "env_aurora_night"
        case .sunsetBeach: return "env_sunset_beach"
        case .zenGarden: return "env_zen_garden"
        
        // 新增的真实图片环境
        case .elegantFireplace: return "visionstyle1"
        case .nordicArt: return "visionstyle2"
        case .modernGray: return "visionstyle3"
        case .cloudSunrise: return "visionstyle4"
        case .lakeMountain: return "visionstyle5"
        case .darkStudio: return "visionstyle6"
        
        case .custom: return "" // 自定义不使用内置图片
        }
    }
    
    /// 渐变色方案（主要用于占位或图片加载失败时）
    var gradientColors: [Color] {
        switch self {
        case .custom:
            return [Color.gray, Color.black]
        case .livingRoom, .elegantFireplace:
            return [Color(hex: "8B7355"), Color(hex: "6B5344"), Color(hex: "4A3C31")]
        case .darkStudy, .darkStudio:
            return [Color(hex: "1a1410"), Color(hex: "2a2018"), Color(hex: "0d0a08")]
        case .alpineMountain, .lakeMountain:
            return [Color(hex: "3a2066"), Color(hex: "5a3a8a"), Color(hex: "1a0a33")]
        case .auroraNight:
            return [Color(hex: "0a0a1a"), Color(hex: "1a2a3a"), Color(hex: "051015")]
        case .sunsetBeach, .cloudSunrise:
            return [Color(hex: "ff6b6b"), Color(hex: "feca57"), Color(hex: "48dbfb")]
        case .zenGarden:
            return [Color(hex: "2E8B57"), Color(hex: "3CB371"), Color(hex: "1C352D")]
        case .nordicArt:
            return [Color(hex: "F5E6D3"), Color(hex: "E8D4C4"), Color(hex: "DCC9B8")]
        case .modernGray:
            return [Color(hex: "4A4A4A"), Color(hex: "3A3A3A"), Color(hex: "2A2A2A")]
        }
    }
}

/// 主题管理器
@Observable
final class ThemeManager {
    // MARK: - Private Storage
    // Theme removed
    private var _currentEnvironment: SpatialEnvironment = .sunsetBeach  // 默认日落海滩
    private var _useSystemWallpaper: Bool = false  // 默认关闭系统壁纸，使用环境背景
    // Classic path removed
    private var _spatialCustomImagePath: String? = nil
    
    // MARK: - Public Properties with Persistence
    
    // Theme removed
    
    /// 当前空间环境
    var currentEnvironment: SpatialEnvironment {
        get { _currentEnvironment }
        set {
            _currentEnvironment = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: "currentEnvironment")
        }
    }
    
    /// 是否使用系统桌面壁纸
    var useSystemWallpaper: Bool {
        get { _useSystemWallpaper }
        set {
            _useSystemWallpaper = newValue
            UserDefaults.standard.set(newValue, forKey: "useSystemWallpaper")
        }
    }
    
    // Classic path accessor removed
    
    /// 空间模式自定义背景图片路径
    var spatialCustomImagePath: String? {
        get { _spatialCustomImagePath }
        set {
            _spatialCustomImagePath = newValue
            UserDefaults.standard.set(newValue, forKey: "spatialCustomImagePath")
        }
    }
    
    /// 是否显示侧边坞
    var showSidebar: Bool = true
    
    /// 图标形状
    var iconShape: IconShape = .circle
    
    // MARK: - Initialization
    
    init() {
        loadSettings()
    }
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        
        // Theme loading removed
        
        if let envRaw = defaults.string(forKey: "currentEnvironment"),
           let env = SpatialEnvironment(rawValue: envRaw) {
            _currentEnvironment = env
        }
        
        // 注意：Bool 如果没设置默认是 false
        // 我们需要默认 false（使用环境背景而不是系统壁纸）
        if defaults.object(forKey: "useSystemWallpaper") != nil {
            _useSystemWallpaper = defaults.bool(forKey: "useSystemWallpaper")
        } else {
            _useSystemWallpaper = false // 默认关闭，使用日落海滩背景
        }
        
        // Classic path loading removed
        _spatialCustomImagePath = defaults.string(forKey: "spatialCustomImagePath")
    }

    // MARK: - Actions
    
    // cycleTheme removed
    
    /// 切换环境
    func cycleEnvironment() {
        let environments = SpatialEnvironment.allCases
        if let currentIndex = environments.firstIndex(of: currentEnvironment) {
            let nextIndex = (currentIndex + 1) % environments.count
            currentEnvironment = environments[nextIndex]
        }
    }
    
    // selectClassicBackgroundImage removed
    
    /// 选择空间模式自定义背景图片
    func selectSpatialCustomImage() {
        selectImage { [weak self] path in
            self?.spatialCustomImagePath = path
            self?.currentEnvironment = .custom // 自动切换到自定义环境
            self?.useSystemWallpaper = false   // 关闭系统壁纸
        }
    }
    
    /// 通用图片选择器
    private func selectImage(completion: @escaping (String) -> Void) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.message = "选择背景图片"
        
        if panel.runModal() == .OK, let url = panel.url {
            completion(url.path)
        }
    }
}

/// 图标形状类型
enum IconShape {
    case circle
    case roundedRect
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
