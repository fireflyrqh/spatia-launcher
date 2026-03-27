//
//  FolderExpandedView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2026/02/24.
//

import SwiftUI

/// 展开后的文件夹视图 - 毛玻璃浮层
struct FolderExpandedView: View {
    let folderId: String
    let initialName: String
    let apps: [ScannedApp]
    let onClose: () -> Void
    let onAppTap: (ScannedApp) -> Void
    let onRemoveApp: (String) -> Void
    let onRename: (String) -> Void
    
    @State private var folderName: String
    @State private var isEditingName = false
    @FocusState private var nameIsFocused: Bool
    
    // 网格布局，固定 3 列体验较好
    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)
    
    init(folderId: String, initialName: String, apps: [ScannedApp], onClose: @escaping () -> Void, onAppTap: @escaping (ScannedApp) -> Void, onRemoveApp: @escaping (String) -> Void, onRename: @escaping (String) -> Void) {
        self.folderId = folderId
        self.initialName = initialName
        self.apps = apps
        self.onClose = onClose
        self.onAppTap = onAppTap
        self.onRemoveApp = onRemoveApp
        self.onRename = onRename
        self._folderName = State(initialValue: initialName)
    }
    
    var body: some View {
        ZStack {
            // 背景遮罩，点击外部关闭
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .onTapGesture {
                    if isEditingName {
                        isEditingName = false
                        onRename(folderName)
                    } else {
                        onClose()
                    }
                }
            
            // 文件夹主体内容
            VStack(spacing: 20) {
                // 顶部标题（可编辑名字）
                HStack {
                    if isEditingName {
                        TextField("文件夹名称", text: $folderName)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.center)
                            .focused($nameIsFocused)
                            .onSubmit {
                                isEditingName = false
                                onRename(folderName)
                            }
                    } else {
                        Text(folderName)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .onTapGesture {
                                isEditingName = true
                                nameIsFocused = true
                            }
                            .contextMenu {
                                Button {
                                    isEditingName = true
                                    nameIsFocused = true
                                } label: {
                                    Label(L10n.General.rename, systemImage: "pencil")
                                }
                            }
                    }
                }
                .foregroundColor(.white)
                .padding(.top, 24)
                
                // 内部的 Apps 网格
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(apps) { app in
                            VStack {
                                VisionOSAppIconView(app: app) {
                                    onAppTap(app)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        onRemoveApp(app.bundleIdentifier)
                                    } label: {
                                        Label("移出文件夹", systemImage: "rectangle.portrait.and.arrow.right")
                                    }
                                }
                            }
                        }
                    }
                    .padding(30)
                }
                .frame(maxHeight: 460)
            }
            .background {
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.4), radius: 40, x: 0, y: 20)
                
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .strokeBorder(.white.opacity(0.2), lineWidth: 1)
            }
            .frame(width: 500)
            .padding(40)
        }
    }
}
