//
//  FolderIconView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2026/02/24.
//

import SwiftUI

/// 文件夹图标预览视图 - iOS 风格
struct FolderIconView: View {
    let name: String
    let apps: [ScannedApp]
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // 毛玻璃圆角矩形背景
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                
                // 外边缘微缝高光
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(.white.opacity(0.2), lineWidth: 0.8)
                    .frame(width: 80, height: 80)
                
                // 内部小图标 (2x2)
                let prefixApps = Array(apps.prefix(4))
                LazyVGrid(columns: [GridItem(.fixed(30)), GridItem(.fixed(30))], spacing: 6) {
                    ForEach(prefixApps) { app in
                        Image(nsImage: app.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            // 轻微投影让小图标在磨砂背景上更清晰
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    }
                }
                .frame(width: 66, height: 66)
            }
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .onTapGesture {
                onTap()
            }
            
            // 文件夹名称
            Text(name)
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(width: 90)
        }
    }
}
