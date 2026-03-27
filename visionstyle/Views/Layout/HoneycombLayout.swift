//
//  HoneycombLayout.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI

/// VisionOS 风格三行蜂巢网格布局
/// 布局规则：
/// - Row 1 (上): N 个图标
/// - Row 2 (中): N+1 个图标
/// - Row 3 (下): N 个图标
struct HoneycombLayout: Layout {
    /// 图标尺寸
    var iconSize: CGFloat = 100
    
    /// 水平间距
    var horizontalSpacing: CGFloat = 50
    
    /// 垂直间距
    var verticalSpacing: CGFloat = 40
    
    /// 行数（固定为3）
    private let rowCount = 3
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 1200
        let height = proposal.height ?? 600
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        // 每个图标占用的总宽度（包含间距）
        let itemWidth = iconSize + horizontalSpacing
        // 每个图标占用的总高度（包含间距和标签）
        let itemHeight = iconSize + verticalSpacing + 30
        
        // 基于容器宽度计算第一行可容纳的图标数量 N
        let availableWidth = bounds.width - 60
        let columnsRow1 = max(3, Int(availableWidth / itemWidth))
        let columnsRow2 = columnsRow1 + 1 // 第二行多一个
        let columnsRow3 = columnsRow1
        
        // 计算每行的实际宽度
        let row1Width = CGFloat(columnsRow1) * itemWidth - horizontalSpacing
        let row2Width = CGFloat(columnsRow2) * itemWidth - horizontalSpacing
        
        // 计算总高度
        let totalHeight = CGFloat(rowCount) * itemHeight
        let startY = bounds.midY - totalHeight / 2 + itemHeight / 2
        
        var index = 0
        
        // 放置第一行 (N 个图标)
        if index < subviews.count {
            let row1StartX = bounds.midX - row1Width / 2 + iconSize / 2
            
            for col in 0..<columnsRow1 {
                guard index < subviews.count else { break }
                
                let x = row1StartX + CGFloat(col) * itemWidth
                let y = startY
                
                subviews[index].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .center,
                    proposal: ProposedViewSize(width: iconSize + 50, height: itemHeight)
                )
                index += 1
            }
        }
        
        // 放置第二行 (N+1 个图标)
        if index < subviews.count {
            let row2StartX = bounds.midX - row2Width / 2 + iconSize / 2
            let row2Y = startY + itemHeight
            
            for col in 0..<columnsRow2 {
                guard index < subviews.count else { break }
                
                let x = row2StartX + CGFloat(col) * itemWidth
                let y = row2Y
                
                subviews[index].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .center,
                    proposal: ProposedViewSize(width: iconSize + 50, height: itemHeight)
                )
                index += 1
            }
        }
        
        // 放置第三行 (N 个图标)
        if index < subviews.count {
            let row3StartX = bounds.midX - row1Width / 2 + iconSize / 2
            let row3Y = startY + itemHeight * 2
            
            for col in 0..<columnsRow3 {
                guard index < subviews.count else { break }
                
                let x = row3StartX + CGFloat(col) * itemWidth
                let y = row3Y
                
                subviews[index].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .center,
                    proposal: ProposedViewSize(width: iconSize + 50, height: itemHeight)
                )
                index += 1
            }
        }
    }
    
    /// 计算单页可容纳的图标数量
    static func iconsPerPage(for width: CGFloat, iconSize: CGFloat = 100, spacing: CGFloat = 50) -> Int {
        let itemWidth = iconSize + spacing
        let availableWidth = width - 60
        let columnsRow1 = max(3, Int(availableWidth / itemWidth))
        return columnsRow1 * 2 + (columnsRow1 + 1) // N + (N+1) + N = 3N + 1
    }
}

/// 蜂巢网格视图 - 支持拖放排序
struct HoneycombGridView: View {
    let items: [GridItemData]
    let iconShape: IconShape
    var onItemTap: (GridItemData) -> Void
    var onReorder: ((GridItemData, GridItemData) -> Void)? = nil
    var onGroup: ((GridItemData, GridItemData) -> Void)? = nil
    
    @State private var draggingItem: GridItemData? = nil
    @State private var dragOverItem: GridItemData? = nil
    @State private var groupTargetItem: GridItemData? = nil
    @State private var hoverTask: Task<Void, Never>? = nil
    
    var body: some View {
        HoneycombLayout(iconSize: 100, horizontalSpacing: 50, verticalSpacing: 40) {
            ForEach(items) { item in
                makeIconView(for: item)
            }
        }
        .onChange(of: dragOverItem) { _, newItem in
            hoverTask?.cancel()
            groupTargetItem = nil
            
            if let newItem = newItem {
                hoverTask = Task {
                    do {
                        // 悬停 0.6 秒后变为编组意图 (尝试创建或加入文件夹)
                        try await Task.sleep(nanoseconds: 600_000_000)
                        if !Task.isCancelled {
                            withAnimation(.spring()) {
                                self.groupTargetItem = newItem
                            }
                        }
                    } catch {}
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeIconView(for item: GridItemData) -> some View {
        let isDragging = draggingItem?.id == item.id
        let isDragOver = dragOverItem?.id == item.id
        let isGrouping = groupTargetItem?.id == item.id
        
        Group {
            switch item {
            case .app(let app):
                VisionOSAppIconView(
                    app: app,
                    onTap: { onItemTap(item) }
                )
            case .folder(let id, let name, let apps):
                FolderIconView(
                    name: name,
                    apps: apps,
                    onTap: { onItemTap(item) }
                )
            }
        }
        .opacity(isDragging ? 0.5 : 1.0)
        // 目标放大的动画特效
        .scaleEffect(isGrouping ? 1.15 : (isDragOver ? 1.05 : 1.0))
        .background {
            if isGrouping {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 90, height: 90)
                    .blur(radius: 10)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragOver)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isGrouping)
        .onDrag {
            draggingItem = item
            return NSItemProvider(object: item.id as NSString)
        }
        .onDrop(of: [.text], delegate: AppDropDelegate(
            item: item,
            draggingItem: $draggingItem,
            dragOverItem: $dragOverItem,
            groupTargetItem: $groupTargetItem,
            onReorder: onReorder,
            onGroup: onGroup
        ))
    }
}

/// 拖放委托
struct AppDropDelegate: DropDelegate {
    let item: GridItemData
    @Binding var draggingItem: GridItemData?
    @Binding var dragOverItem: GridItemData?
    @Binding var groupTargetItem: GridItemData?
    var onReorder: ((GridItemData, GridItemData) -> Void)?
    var onGroup: ((GridItemData, GridItemData) -> Void)?
    
    func dropEntered(info: DropInfo) {
        if draggingItem?.id != item.id {
            dragOverItem = item
        }
    }
    
    func dropExited(info: DropInfo) {
        if dragOverItem?.id == item.id {
            dragOverItem = nil
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if let dragging = draggingItem, dragging.id != item.id {
            if groupTargetItem?.id == item.id {
                onGroup?(dragging, item)
            } else {
                onReorder?(dragging, item)
            }
        }
        draggingItem = nil
        dragOverItem = nil
        groupTargetItem = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

/// 分页蜂巢网格视图 - 支持拖放排序
struct PaginatedHoneycombView: View {
    @Bindable var stateManager: AppStateManager
    let themeManager: ThemeManager
    
    var body: some View {
        GeometryReader { geometry in
            let iconsPerPage = HoneycombLayout.iconsPerPage(for: geometry.size.width)
            
            ZStack {
                // 当前页内容
                pageContent(iconsPerPage: iconsPerPage, in: geometry.size)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width < -threshold {
                            // 向左滑动 - 下一页
                            stateManager.nextPage()
                        } else if value.translation.width > threshold {
                            // 向右滑动 - 上一页
                            stateManager.previousPage()
                        }
                    }
            )
        }
    }
    
    /// 页面内容
    @ViewBuilder
    private func pageContent(iconsPerPage: Int, in size: CGSize) -> some View {
        let totalPages = max(1, Int(ceil(Double(stateManager.filteredItems.count) / Double(iconsPerPage))))
        
        // 确保页面索引有效
        let validPageIndex = min(stateManager.currentPageIndex, totalPages - 1)
        let startIndex = validPageIndex * iconsPerPage
        let endIndex = min(startIndex + iconsPerPage, stateManager.filteredItems.count)
        
        if startIndex < stateManager.filteredItems.count {
            let pageItems = Array(stateManager.filteredItems[startIndex..<endIndex])
            
            HoneycombGridView(
                items: pageItems,
                iconShape: themeManager.iconShape,
                onItemTap: { item in
                    switch item {
                    case .app(let app):
                        stateManager.launchApp(app)
                    case .folder(_, _, _):
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stateManager.selectedFolder = item
                        }
                    }
                },
                onReorder: { item1, item2 in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        stateManager.swapItems(item1, with: item2)
                    }
                },
                onGroup: { draggingItem, targetItem in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        stateManager.groupItems(source: draggingItem, target: targetItem)
                    }
                }
            )
            .frame(width: size.width, height: size.height)
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
            .id(validPageIndex)
        }
    }
}

/// 页面指示器 - 半透明毛玻璃设计
struct PageIndicatorView: View {
    let currentPage: Int
    let totalPages: Int
    var onPageTap: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<totalPages, id: \.self) { index in
                Button {
                    // 直接调用，不在这里加动画，让调用方决定
                    onPageTap(index)
                } label: {
                    Circle()
                        .fill(index == currentPage ? Color.white.opacity(0.95) : Color.white.opacity(0.35))
                        .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                }
                .buttonStyle(.plain)
                .frame(width: 24, height: 24) // 增大点击区域
                .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(.white.opacity(0.12))
                .background {
                    Capsule()
                        .fill(.ultraThinMaterial.opacity(0.5))
                }
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .overlay {
            Capsule()
                .strokeBorder(.white.opacity(0.2), lineWidth: 0.8)
        }
    }
}

#Preview {
    ZStack {
        Color(hex: "8B7355")
        
        HoneycombLayout(iconSize: 100, horizontalSpacing: 50, verticalSpacing: 40) {
            ForEach(0..<13) { index in
                VStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay {
                            Text("\(index + 1)")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    
                    Text("App \(index + 1)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(50)
    }
    .frame(width: 1200, height: 700)
}
