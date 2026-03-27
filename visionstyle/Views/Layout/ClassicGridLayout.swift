//
//  ClassicGridLayout.swift
//  visionstyle
//
//  经典模式网格布局 - 动态适应不同屏幕尺寸
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI

/// 经典网格布局 - 动态适应屏幕尺寸
struct ClassicGridLayout: Layout {
    /// 目标图标尺寸（会根据屏幕动态调整）
    var targetIconSize: CGFloat = 100
    
    /// 最小列数
    let minColumns: Int = 5
    
    /// 最大列数
    let maxColumns: Int = 10
    
    /// 最小行数
    let minRows: Int = 3
    
    /// 最大行数
    let maxRows: Int = 7
    
    /// 图标之间的最小间距
    let minSpacing: CGFloat = 20
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 1200
        let height = proposal.height ?? 700
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        // 根据屏幕尺寸动态计算最佳布局
        let layout = calculateOptimalLayout(for: bounds.size, itemCount: subviews.count)
        
        var index = 0
        
        // 按行遍历网格
        for row in 0..<layout.rows {
            for col in 0..<layout.columns {
                // 如果没有更多子视图，则停止
                guard index < subviews.count else { return }
                
                // 计算当前单元格的中心点
                let centerX = bounds.minX + layout.leftPadding + CGFloat(col) * layout.cellWidth + layout.cellWidth / 2
                let centerY = bounds.minY + layout.topPadding + CGFloat(row) * layout.cellHeight + layout.cellHeight / 2
                
                let point = CGPoint(x: centerX, y: centerY)
                
                // 放置子视图
                subviews[index].place(
                    at: point,
                    anchor: .center,
                    proposal: ProposedViewSize(width: layout.cellWidth, height: layout.cellHeight)
                )
                
                index += 1
            }
        }
    }
    
    /// 计算最佳布局参数
    private func calculateOptimalLayout(for size: CGSize, itemCount: Int) -> GridLayoutParams {
        // 计算每个图标需要的最小空间（包括标签）
        let itemMinWidth = targetIconSize + minSpacing
        let itemMinHeight = targetIconSize + 40 + minSpacing // 40 for label
        
        // 根据屏幕尺寸计算可能的列数和行数
        var columns = Int(size.width / itemMinWidth)
        columns = max(minColumns, min(maxColumns, columns))
        
        var rows = Int(size.height / itemMinHeight)
        rows = max(minRows, min(maxRows, rows))
        
        // 计算实际单元格大小
        let cellWidth = size.width / CGFloat(columns)
        let cellHeight = size.height / CGFloat(rows)
        
        // 计算实际图标大小（根据单元格大小调整）
        let maxIconWidth = cellWidth - minSpacing
        let maxIconHeight = cellHeight - 40 - minSpacing // 40 for label
        var iconSize = min(maxIconWidth, maxIconHeight, targetIconSize * 1.2) // 最大不超过目标的 120%
        iconSize = max(iconSize, 60) // 最小 60pt
        
        // 计算实际需要的行数（根据项目数量）
        let actualRows = min(rows, Int(ceil(Double(itemCount) / Double(columns))))
        
        // 计算网格总尺寸以便居中
        let gridWidth = CGFloat(columns) * cellWidth
        let gridHeight = CGFloat(actualRows) * cellHeight
        
        // 计算边距以居中网格
        let leftPadding = (size.width - gridWidth) / 2
        let topPadding = (size.height - gridHeight) / 2
        
        return GridLayoutParams(
            columns: columns,
            rows: actualRows,
            maxRows: rows,
            cellWidth: cellWidth,
            cellHeight: cellHeight,
            iconSize: iconSize,
            leftPadding: leftPadding,
            topPadding: topPadding
        )
    }
    
    /// 静态方法：根据屏幕尺寸计算每页应用数量
    static func calculateAppsPerPage(for screenSize: CGSize) -> Int {
        let layout = ClassicGridLayout()
        let params = layout.calculateOptimalLayout(for: screenSize, itemCount: 100) // 假设很多项
        return params.columns * params.maxRows
    }
}

/// 网格布局参数
struct GridLayoutParams {
    let columns: Int
    let rows: Int
    let maxRows: Int
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    let iconSize: CGFloat
    let leftPadding: CGFloat
    let topPadding: CGFloat
}

/// 经典网格视图 - 支持拖放排序
struct ClassicGridView: View {
    let apps: [ScannedApp]
    let iconShape: IconShape
    var onAppTap: (ScannedApp) -> Void
    var onReorder: ((ScannedApp, ScannedApp) -> Void)? = nil
    
    @State private var draggingApp: ScannedApp? = nil
    @State private var dragOverApp: ScannedApp? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let optimalIconSize = calculateIconSize(for: geometry.size)
            
            ClassicGridLayout(targetIconSize: optimalIconSize) {
                ForEach(apps) { app in
                    makeIconView(for: app, iconSize: optimalIconSize)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    @ViewBuilder
    private func makeIconView(for app: ScannedApp, iconSize: CGFloat) -> some View {
        let isDragging = draggingApp?.id == app.id
        let isDragOver = dragOverApp?.id == app.id
        
        ClassicAppIconView(
            app: app,
            iconShape: iconShape,
            iconSize: iconSize,
            onTap: {
                onAppTap(app)
            }
        )
        .opacity(isDragging ? 0.5 : 1.0)
        .scaleEffect(isDragOver ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragOver)
        .onDrag {
            draggingApp = app
            return NSItemProvider(object: app.bundleIdentifier as NSString)
        }
        .onDrop(of: [.text], delegate: ClassicAppDropDelegate(
            app: app,
            draggingApp: $draggingApp,
            dragOverApp: $dragOverApp,
            onReorder: onReorder
        ))
    }
    
    /// 根据屏幕尺寸计算最佳图标大小
    private func calculateIconSize(for size: CGSize) -> CGFloat {
        let baseWidth: CGFloat = 1440
        let baseIconSize: CGFloat = 100
        let scale = size.width / baseWidth
        var iconSize = baseIconSize * scale
        iconSize = max(70, min(130, iconSize))
        return iconSize
    }
}

/// 经典模式拖放委托
struct ClassicAppDropDelegate: DropDelegate {
    let app: ScannedApp
    @Binding var draggingApp: ScannedApp?
    @Binding var dragOverApp: ScannedApp?
    var onReorder: ((ScannedApp, ScannedApp) -> Void)?
    
    func dropEntered(info: DropInfo) {
        dragOverApp = app
    }
    
    func dropExited(info: DropInfo) {
        if dragOverApp?.id == app.id {
            dragOverApp = nil
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if let dragging = draggingApp, dragging.id != app.id {
            onReorder?(dragging, app)
        }
        draggingApp = nil
        dragOverApp = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

/// 经典模式应用图标视图
struct ClassicAppIconView: View {
    let app: ScannedApp
    let iconShape: IconShape
    var iconSize: CGFloat = 100
    var onTap: () -> Void
    
    @State private var isHovered: Bool = false
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            // 图标
            Image(nsImage: app.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: iconSize * 0.22, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: isHovered ? 15 : 8, x: 0, y: isHovered ? 8 : 4)
                .scaleEffect(isPressed ? 0.92 : (isHovered ? 1.05 : 1.0))
            
            // 应用名称
            Text(app.name)
                .font(.system(size: max(11, iconSize * 0.12), weight: .medium))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: iconSize + 20)
                .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)
        }
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                    onTap()
                }
        )
        // 右键上下文菜单
        .contextMenu {
            Button {
                openApp()
            } label: {
                Label("Open", systemImage: "arrow.up.forward.app")
            }
            
            Divider()
            
            Button {
                showInFinder()
            } label: {
                Label("Show in Finder", systemImage: "folder")
            }
            
            Button {
                getInfo()
            } label: {
                Label("Get Info", systemImage: "info.circle")
            }
            
            Button {
                quickLook()
            } label: {
                Label("Quick Look", systemImage: "eye")
            }
            
            Divider()
            
            Button {
                shareApp()
            } label: {
                Label("Share...", systemImage: "square.and.arrow.up")
            }
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovered)
    }
    
    // MARK: - Context Menu Actions
    
    private func openApp() {
        let url = URL(fileURLWithPath: app.path)
        NSWorkspace.shared.openApplication(at: url, configuration: .init()) { _, _ in }
    }
    
    private func showInFinder() {
        let url = URL(fileURLWithPath: app.path)
        NSWorkspace.shared.selectFile(app.path, inFileViewerRootedAtPath: url.deletingLastPathComponent().path)
    }
    
    private func getInfo() {
        let script = """
        tell application "Finder"
            activate
            open information window of (POSIX file "\(app.path)" as alias)
        end tell
        """
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            appleScript.executeAndReturnError(&error)
        }
    }
    
    private func quickLook() {
        NSWorkspace.shared.selectFile(app.path, inFileViewerRootedAtPath: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let source = CGEventSource(stateID: .hidSystemState)
            let spaceDown = CGEvent(keyboardEventSource: source, virtualKey: 0x31, keyDown: true)
            let spaceUp = CGEvent(keyboardEventSource: source, virtualKey: 0x31, keyDown: false)
            spaceDown?.post(tap: .cghidEventTap)
            spaceUp?.post(tap: .cghidEventTap)
        }
    }
    
    private func shareApp() {
        let url = URL(fileURLWithPath: app.path)
        let picker = NSSharingServicePicker(items: [url])
        if let window = NSApp.keyWindow, let contentView = window.contentView {
            let mouseLocation = NSEvent.mouseLocation
            let windowLocation = window.convertPoint(fromScreen: mouseLocation)
            let viewLocation = contentView.convert(windowLocation, from: nil)
            picker.show(relativeTo: NSRect(origin: viewLocation, size: .zero), of: contentView, preferredEdge: .minY)
        }
    }
}

/// 分页经典网格视图 - 支持拖放排序（与 PaginatedHoneycombView 对称设计）
struct PaginatedClassicView: View {
    @Bindable var stateManager: AppStateManager
    let themeManager: ThemeManager

    var body: some View {
        GeometryReader { geometry in
            let appsPerPage = stateManager.appsPerPage

            ZStack {
                pageContent(appsPerPage: appsPerPage, in: geometry.size)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width < -threshold {
                            stateManager.nextPage()
                        } else if value.translation.width > threshold {
                            stateManager.previousPage()
                        }
                    }
            )
        }
    }

    @ViewBuilder
    private func pageContent(appsPerPage: Int, in size: CGSize) -> some View {
        let totalPages = max(1, Int(ceil(Double(stateManager.filteredItems.count) / Double(appsPerPage))))
        let validPageIndex = min(stateManager.currentPageIndex, totalPages - 1)
        let startIndex = validPageIndex * appsPerPage
        let endIndex = min(startIndex + appsPerPage, stateManager.filteredItems.count)

        if startIndex < stateManager.filteredItems.count {
            let pageItems = Array(stateManager.filteredItems[startIndex..<endIndex])
            // 只取 .app 类型（经典模式不支持文件夹的展开浮层调用，交由外层处理）
            let apps = pageItems.compactMap { item -> ScannedApp? in
                if case .app(let a) = item { return a }
                return nil
            }

            ClassicGridView(
                apps: apps,
                iconShape: themeManager.iconShape,
                onAppTap: { app in
                    stateManager.launchApp(app)
                },
                onReorder: { app1, app2 in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        stateManager.swapItems(.app(app1), with: .app(app2))
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

#Preview {
    ZStack {
        Color.gray
        
        ClassicGridLayout() {
            ForEach(0..<35) { index in
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Text("\(index + 1)")
                            .foregroundColor(.white)
                    }
            }
        }
    }
    .frame(width: 1200, height: 800)
}
