//
//  SearchBarView.swift
//  visionstyle
//
//  macOS 26 Tahoe Liquid Glass 风格搜索栏
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI

/// 顶部胶囊型搜索栏视图 - Liquid Glass 设计
struct SearchBarView: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    @State private var isHovered: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            // 搜索图标
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(foregroundColor.opacity(0.7))
            
            // 搜索输入框
            TextField(L10n.Search.placeholder, text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(foregroundColor)
                .focused($isFocused)
                .onSubmit {
                    // 搜索提交逻辑
                }
            
            // 清除按钮
            if !searchText.isEmpty {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        searchText = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(foregroundColor.opacity(0.5))
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
            
            // 快捷键提示
            if searchText.isEmpty && !isFocused {
                HStack(spacing: 4) {
                    KeyboardShortcutBadge(key: "⌘")
                    KeyboardShortcutBadge(key: "F")
                }
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background {
            // Liquid Glass 效果
            LiquidGlassCapsule(isActive: isFocused || isHovered)
        }
        .scaleEffect(isFocused ? 1.02 : (isHovered ? 1.01 : 1.0))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isFocused)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .frame(width: 400)
    }
    
    /// 前景色（根据环境自适应）
    private var foregroundColor: Color {
        .white // 始终使用白色文字，因为是叠加在背景图上
    }
}

/// Liquid Glass 胶囊背景 - 与左侧 Dock 样式一致
struct LiquidGlassCapsule: View {
    var isActive: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Capsule()
            .fill(.white.opacity(isActive ? 0.18 : 0.12))
            .shadow(color: .black.opacity(0.15), radius: isActive ? 15 : 10, x: 0, y: isActive ? 6 : 4)
            .overlay {
                Capsule()
                    .strokeBorder(.white.opacity(isActive ? 0.3 : 0.2), lineWidth: 0.6)
            }
    }
}

/// 键盘快捷键徽章
struct KeyboardShortcutBadge: View {
    let key: String
    
    var body: some View {
        Text(key)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundColor(.white.opacity(0.5))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(0.1))
            }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(hex: "8B7355"), Color(hex: "4A3C31")],
            startPoint: .top,
            endPoint: .bottom
        )
        
        VStack(spacing: 30) {
            SearchBarView(searchText: .constant(""))
            SearchBarView(searchText: .constant("Safari"))
        }
    }
    .frame(width: 600, height: 300)
}
