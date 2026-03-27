产品需求文档 (PRD): SpatialLaunch for macOS 26

1. 项目概览 (Project Overview)

1.1 产品简介

SpatialLaunch 是一款专为 macOS 26 (Tahoe) 设计的下一代应用启动器。
它旨在完美替代原生 Launchpad，核心价值在于：

功能对标：完整复刻 BuhoLaunchpad 的实用功能（如还原经典体验、无缝迁移配置、文件夹管理）。

体验创新：引入 Apple VisionOS 的空间计算美学，采用“沉浸式环境 + 三行蜂巢排列”作为默认交互界面。

1.2 目标用户

不习惯新版 macOS 应用启动方式，渴望找回经典 Launchpad 体验的用户。

追求极致 UI/UX，喜欢 Vision Pro 空间设计语言的 Mac 用户。

拥有大量应用，需要高效整理和搜索的用户。

1.3 运行环境

OS: macOS 14 (Sonoma) / 15 (Sequoia) / 26 (Tahoe)

Architecture: Apple Silicon (M1-M5) & Intel

2. 核心功能清单 (Feature Requirements) - 对标 BuhoLaunchpad

指令给 Agent：本节列出的所有功能必须实现，这是产品的基石。

模块

功能点 (ID)

优先级

详细描述

验收标准

核心引擎

F-01 应用扫描

P0

启动时自动扫描 /Applications, ~/Applications 及 /System/Applications。

能完整列出系统中所有用户可见的 App。

核心引擎

F-02 应用启动

P0

点击图标即可打开 App，启动后 Launchpad 自动消失。

点击响应迅速，无延迟。

布局管理

F-03 拖拽排序

P0

像原生 Launchpad 一样，按住图标拖动可改变位置。

拖动时其他图标有挤占/让位动画。

布局管理

F-04 文件夹系统

P0

将图标 A 拖入图标 B，自动创建文件夹；支持文件夹重命名。

文件夹展开动画流畅，内部支持分页。

布局管理

F-05 布局迁移

P1

(Buho 核心特性) 首次启动时，读取系统旧版 Launchpad 的数据库配置，自动还原用户的图标排列习惯。

用户无需重新手动整理图标。

个性化

F-06 多主题切换

P1

支持“空间模式 (默认)”、“经典亮色”、“经典深色”。

切换主题无需重启应用。

系统

F-07 快捷键呼出

P1

支持设置自定义快捷键（如 Option+Space）显示/隐藏启动器。

响应全局热键。

搜索

F-08 全局搜索

P0

顶部搜索栏，支持拼音、英文名首字母搜索。

输入 PS 能搜到 Photoshop。

3. UI/UX 设计规范 (Design Specifications)

3.1 默认主题：VisionOS 空间模式 (The Spatial Theme)

这是本产品的核心差异点，请严格执行“三行美学”。

A. 视觉层级与背景 (Background & Layers)

沉浸式背景：

不仅仅是壁纸，而是环境 (Environment)。

内置 5-8 张 4K 高清家居/自然环境图（如：温馨客厅、极简书房、阿尔卑斯雪山窗景）。

设置项：允许用户在“设置”中选择不同的“空间环境”。

光照与阴影：

所有 UI 元素（图标、搜索栏、侧边坞）必须投射重阴影 (Heavy Drop Shadow) 到背景上，营造悬浮感。

使用动态光效，图标表面要有玻璃质感的高光。

B. 核心布局：三行蜂巢网格 (3-Row Honeycomb Grid)

布局逻辑：

打破传统矩形网格，采用交错排列 (Staggered Layout)。

强制约束：无论屏幕多大，垂直方向只显示 3 行。

水平分布：根据屏幕宽度动态计算列数 N。

Row 1: N 个图标

Row 2: N + 1 个图标 (向右偏移半个图标位，形成蜂巢感)

Row 3: N 个图标

分页逻辑：

由于只有 3 行，单页容纳应用有限。必须支持流畅的水平滑动手势。

翻页动画：整页平移 + 边缘淡入淡出 (Fade-in/out)。

C. 图标设计 (The Orbs)

形态：正圆形 (Circle)。

技术实现：获取 App 的原始图标 -> 放入圆形容器 -> 加上玻璃遮罩 (Glass Mask)。

尺寸：比传统 macOS 图标略大（约 128x128pt），间距宽松。

交互 (Hover Effect)：

鼠标悬停时：图标放大 1.15倍。

3D 视差 (Parallax)：鼠标在图标上移动时，图标内部的 Logo 层应随鼠标微动，产生深度感。

D. 顶部功能区 (Header)

位置：屏幕顶部正中央，悬浮于第一行图标上方。

组件：胶囊型搜索栏 (Capsule Search Bar)。

材质：磨砂玻璃 (Regular Material)。

E. 左侧固定坞 (Sidebar Dock)

位置：主图标群左侧，垂直居中。

样式：垂直胶囊背景，磨砂玻璃材质。

固定内容：

App Store (顶部)

Contacts (中间)

Photos (底部)

视觉细节：这三个图标也需遵循“圆形 + 3D 视差”的设计语言。

3.2 备选主题：经典模式 (Classic Mode)

目的：为了满足复古用户，复刻 BuhoLaunchpad 的标准界面。

样式：

背景：当前桌面壁纸的高斯模糊。

布局：标准的矩形网格 (Grid)，5行7列或7行5列。

图标：原生圆角矩形。

无侧边坞，无环境背景。

4. 技术架构推荐 (Technical Architecture)

为了实现高性能动画和原生体验，建议使用以下技术栈：

Language: Swift 6.0

Framework: SwiftUI (主UI) + AppKit (底层系统交互)。

Layout Engine:

实现 CustomLayout 协议来构建 HoneycombGrid。

不要使用简单的 HStack/VStack，需要精确的坐标计算。

Data Persistence: SwiftData。

用于存储用户自定义的图标顺序、文件夹结构、选择的主题背景。

Model: AppItem, PageConfig, FolderItem.

System Integration:

NSWorkspace: 启动应用。

LSCopyApplicationURLsForBundleIdentifier: 获取应用信息。

5. 开发路线图 (Implementation Roadmap for AI Agent)

指令给 Agent：请严格按照以下 Phase 顺序进行开发。每个 Phase 必须经过测试（编译通过且功能正常）后，才能进入下一个 Phase。

Phase 1: 项目脚手架与数据层 (Foundation)

Init: 创建 macOS SwiftUI Project (Target: macOS 14+).

App Model: 定义 AppItem 结构体 (ID, Name, Icon, Path)。

Scanner: 实现 AppService，扫描 /Applications 并返回 [AppItem] 数组。

Window: 设置应用为全屏无边框窗口 (.windowStyle(.hiddenTitleBar)), 且背景透明。

Output: 运行应用，能在控制台打印出所有已安装应用列表。

Phase 2: 视觉框架与环境 (The Vision Environment)

Theme Manager: 创建 ThemeManager 环境对象，管理 currentTheme (.spatial / .classic)。

Background View:

导入 3 张 4K 示例背景图。

实现背景切换逻辑（图片 vs 毛玻璃）。

Sidebar: 实现左侧垂直胶囊 Dock，放置 3 个静态图标（Store, Contacts, Photos）。

Header: 实现顶部磨砂玻璃搜索栏 UI（暂无功能）。

Output: 界面展示背景、左侧 Dock 和顶部搜索栏。

Phase 3: 核心布局 - 三行蜂巢 (The Honeycomb Layout) (关键难点)

Custom Layout: 编写 SwiftUI Layout 协议实现 StaggeredHGrid。

逻辑：只允许 3 行。偶数行 (第2行) xOffset 偏移。

Icon View:

实现 AppIconView。

应用 .clipShape(Circle())。

添加 .hoverEffect 和 3D 视差修饰符。

Pagination: 使用 TabView (Page style) 结合 Layout，将应用列表切分为每页约 20 个图标。

Output: 屏幕中央显示出漂亮的、三行交错排列的圆形应用图标阵列。

Phase 4: 拖拽与文件夹逻辑 (Interaction Engine)

Drag & Drop:

为图标添加 .onDrag 和 .onDrop。

实现数组重排算法 (Reorder Logic)。

Folder Creation:

检测 Drop 事件：当图标停留在另一个图标上 > 0.5s，触发文件夹创建。

Vision 风格文件夹：点击文件夹，不推开图标，而是弹出一个居中的悬浮玻璃窗口显示内容。

Persistence: 引入 SwiftData，保存用户调整后的顺序。每次启动读取数据库而非重新扫描。

Phase 5: 搜索与功能补全 (Functionality)

Search Logic: 连接搜索栏输入，实时过滤 AppItem 数组。

Launch: 点击图标调用 NSWorkspace.shared.open() 启动应用，并执行 NSApp.hide()。

Shortcut: 注册全局快捷键 (如 Option+Space) 切换应用可见性。

Phase 6: 经典模式与打磨 (Polish)

Classic Theme: 实现标准的 Grid 布局作为备选方案。

Buho-Import: (高级功能) 尝试读取 com.apple.dock.launchpad 的数据库（SQLite），解析原有布局并映射到当前 App。

Animation: 优化进入/退出动画（类似 Vision Pro 的缩放淡入效果）。