//
//  String+Localization.swift
//  visionstyle
//
//  本地化字符串扩展
//  Created by SpatialLaunch Team on 2025/12/28.
//

import Foundation

extension String {
    /// 本地化字符串
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// 带参数的本地化字符串
    func localized(with arguments: CVarArg...) -> String {
        String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

/// 本地化键常量
enum L10n {
    // MARK: - Theme
    enum Theme {
        static var spatial: String { "theme.spatial".localized }
        static var classic: String { "theme.classic".localized }
        static var spatialDescription: String { "theme.spatial.description".localized }
        static var classicDescription: String { "theme.classic.description".localized }
    }
    
    // MARK: - Environment
    enum Env {
        static var livingRoom: String { "env.livingRoom".localized }
        static var darkStudy: String { "env.darkStudy".localized }
        static var alpineMountain: String { "env.alpineMountain".localized }
        static var auroraNight: String { "env.auroraNight".localized }
        static var sunsetBeach: String { "env.sunsetBeach".localized }
        static var zenGarden: String { "env.zenGarden".localized }
        static var elegantFireplace: String { "env.elegantFireplace".localized }
        static var nordicArt: String { "env.nordicArt".localized }
        static var modernGray: String { "env.modernGray".localized }
        static var cloudSunrise: String { "env.cloudSunrise".localized }
        static var lakeMountain: String { "env.lakeMountain".localized }
        static var darkStudio: String { "env.darkStudio".localized }
        static var custom: String { "env.custom".localized }
    }
    
    // MARK: - Settings
    enum Settings {
        static var title: String { "settings.title".localized }
        static var theme: String { "settings.theme".localized }
        static var environment: String { "settings.environment".localized }
        static var background: String { "settings.background".localized }
        static var useSystemWallpaper: String { "settings.useSystemWallpaper".localized }
        static var customBackground: String { "settings.customBackground".localized }
        static var selectImage: String { "settings.selectImage".localized }
        static var changeImage: String { "settings.changeImage".localized }
        static var noImageSelected: String { "settings.noImageSelected".localized }
        static var remove: String { "settings.remove".localized }
        static var backgroundImage: String { "settings.backgroundImage".localized }
        static var shortcuts: String { "settings.shortcuts".localized }
        static var about: String { "settings.about".localized }
        static var version: String { "settings.version".localized }
        static var close: String { "settings.close".localized }
    }
    
    // MARK: - Shortcuts
    enum Shortcut {
        static var toggle: String { "shortcut.toggle".localized }
        static var hide: String { "shortcut.hide".localized }
        static var refresh: String { "shortcut.refresh".localized }
        static var switchTheme: String { "shortcut.switchTheme".localized }
        static var prevPage: String { "shortcut.prevPage".localized }
        static var nextPage: String { "shortcut.nextPage".localized }
        static var dragFolder: String { "shortcut.dragFolder".localized }
        static var dragFolderTip: String { "shortcut.dragFolderTip".localized }
    }
    
    // MARK: - Search
    enum Search {
        static var placeholder: String { "search.placeholder".localized }
    }
    
    // MARK: - Loading
    enum Loading {
        static var scanning: String { "loading.scanning".localized }
    }
    
    // MARK: - General
    enum General {
        static var cancel: String { "general.cancel".localized }
        static var done: String { "general.done".localized }
        static var ok: String { "general.ok".localized }
        static var rename: String { "general.rename".localized }
    }
    
    // MARK: - About
    enum About {
        static var description: String { "about.description".localized }
        static var syncWallpaper: String { "about.syncWallpaper".localized }
    }
    
    // MARK: - Pet
    enum Pet {
        static var feed: String { "pet.action.feed".localized }
        static var wash: String { "pet.action.wash".localized }
        static var play: String { "pet.action.play".localized }
        static var level: String { "pet.level".localized }
        static var xp: String { "pet.xp".localized }
        static var statusFormat: String { "pet.status.format".localized }
        static var limitReached: String { "pet.limit.reached".localized }
        static var actionSuccess: String { "pet.action.success".localized }
        static var feedXP: String { "pet.action.feed.xp".localized }
        static var washXP: String { "pet.action.wash.xp".localized }
        static var playXP: String { "pet.action.play.xp".localized }
        static var chatWelcome: String { "pet.chat.welcome".localized }
        static var chatWater: String { "pet.chat.water".localized }
        static var chatRest: String { "pet.chat.rest".localized }
        static var chatThirsty: String { "pet.chat.thirsty".localized }
        static var chatBored: String { "pet.chat.bored".localized }
        static var chatTickle: String { "pet.chat.tickle".localized }
        static var chatMissMe: String { "pet.chat.missMe".localized }
    }
}
