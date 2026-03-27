//
//  GlobalHotKeyManager.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import Foundation
import AppKit
import Carbon

/// 全局热键管理器 - 注册系统级快捷键
final class GlobalHotKeyManager: ObservableObject {
    static let shared = GlobalHotKeyManager()
    
    private var eventHandler: EventHandlerRef?
    private var hotKeyRef: EventHotKeyRef?
    
    /// 是否已注册热键
    @Published var isRegistered = false
    
    /// 当前配置的热键
    private var currentKeyCode: UInt32 = 49 // Space
    private var currentModifiers: UInt32 = UInt32(optionKey) // Option
    
    private init() {}
    
    /// 注册全局热键 Option + Space
    func registerHotKey(callback: @escaping () -> Void) {
        // 先取消现有注册
        unregisterHotKey()
        
        // 创建事件处理器存储回调
        let callbackWrapper = CallbackWrapper(callback: callback)
        
        // 事件类型
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: OSType(kEventHotKeyPressed)
        )
        
        // 安装事件处理器
        let status = InstallEventHandler(
            GetApplicationEventTarget(),
            { (_, event, userData) -> OSStatus in
                guard let userData = userData else { return noErr }
                let wrapper = Unmanaged<CallbackWrapper>.fromOpaque(userData).takeUnretainedValue()
                DispatchQueue.main.async {
                    wrapper.callback()
                }
                return noErr
            },
            1,
            &eventType,
            Unmanaged.passRetained(callbackWrapper).toOpaque(),
            &eventHandler
        )
        
        guard status == noErr else {
            print("⚠️ 无法安装热键事件处理器: \(status)")
            return
        }
        
        // 热键 ID
        var hotKeyID = EventHotKeyID(
            signature: OSType(0x53504C43), // "SPLC"
            id: 1
        )
        
        // 注册热键 (Option + Space)
        let registerStatus = RegisterEventHotKey(
            currentKeyCode,
            currentModifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
        
        if registerStatus == noErr {
            isRegistered = true
            print("✅ 全局热键已注册: Option + Space")
        } else {
            print("⚠️ 热键注册失败: \(registerStatus)")
        }
    }
    
    /// 注销热键
    func unregisterHotKey() {
        if let ref = hotKeyRef {
            UnregisterEventHotKey(ref)
            hotKeyRef = nil
        }
        
        if let handler = eventHandler {
            RemoveEventHandler(handler)
            eventHandler = nil
        }
        
        isRegistered = false
    }
    
    deinit {
        unregisterHotKey()
    }
}

/// 回调包装器
private class CallbackWrapper {
    let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
}

// MARK: - 常用键码

extension GlobalHotKeyManager {
    enum KeyCode: UInt32 {
        case space = 49
        case tab = 48
        case `return` = 36
        case escape = 53
        case delete = 51
        case a = 0
        case b = 11
        case c = 8
        case d = 2
        case e = 14
        case f = 3
        case g = 5
        case h = 4
        case i = 34
        case j = 38
        case k = 40
        case l = 37
        case m = 46
        case n = 45
        case o = 31
        case p = 35
        case q = 12
        case r = 15
        case s = 1
        case t = 17
        case u = 32
        case v = 9
        case w = 13
        case x = 7
        case y = 16
        case z = 6
    }
    
    struct Modifiers {
        static let command: UInt32 = UInt32(cmdKey)
        static let option: UInt32 = UInt32(optionKey)
        static let control: UInt32 = UInt32(controlKey)
        static let shift: UInt32 = UInt32(shiftKey)
    }
}
