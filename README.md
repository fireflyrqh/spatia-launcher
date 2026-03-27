# Spatia Launcher

<div align="center">

[简体中文](#简体中文) | [English](#english)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-brightgreen)]()
[![Architecture](https://img.shields.io/badge/arch-Apple%20Silicon%20%7C%20Intel-brightgreen)]()
[![Free](https://img.shields.io/badge/price-FREE-orange)]()

**macOS 最佳免费 Launchpad 替代方案 · 支持 VisionOS 空间风格 + 经典网格 · 内置 3D 电子宠物**

[⬇️ 下载 DMG](#下载安装) • [✨ 功能一览](#功能特性) • [🛠️ 开发文档](#开发者文档) • [🤝 参与贡献](#参与贡献)

</div>

---

## 简体中文

### 🚨 为什么你需要 Spatia Launcher？

**macOS 26 Tahoe 移除了传统 Launchpad。**

Apple 在 macOS 26 (Tahoe) 中对应用启动体验进行了重大重设计，传统的 Launchpad 全屏应用页已被移除或大幅削减，许多习惯了一键呼出所有应用的 Mac 用户突然失去了最熟悉的操作方式。

**Spatia Launcher 是目前最好的免费替代方案**，不仅完整还原了 Launchpad 的经典体验，更融入了 Apple Vision Pro 的空间计算设计美学，让你的 macOS 启动器进化到下一个时代——**完全免费、完全开源**。

> 💡 **为什么开源？** 由于 App Store 审核政策限制，本应用无法上架。我们决定将完整源代码采用 GPL v3 协议对外开放，让所有人都能免费使用和参与改进。

---

### ✨ 功能特性

#### 🎨 双模式布局 · 随心切换

| 模式 | 风格 | 适合人群 |
|------|------|---------|
| **空间模式（蜂巢布局）** | Vision Pro 风格，三行蜂巢排列，居中凸起，沉浸感强 | 喜爱前沿设计、追求视觉美感 |
| **经典模式（网格布局）** | 传统 Launchpad 矩形网格，5-10列自适应 | 习惯原生 Launchpad 的用户 |

两种模式在**设置面板中一键切换**，所有布局参数根据屏幕尺寸自动优化。

---

#### 🌅 13 种精美背景环境

**6 种动态渐变环境：**
- 🛋️ 温馨客厅 · 🎓 暗域书房 · 🏔️ 高山极光 · 🌌 极光夜空 · 🌅 日落海滩 · 🌿 禅意花园

**6 张高清实景图片：**
- 🔥 典雅壁炉 · 🎨 北欧艺术 · 🖤 现代灰调 · ☀️ 云日初升 · 🏞️ 湖山胜景 · 🎙️ 暗色工作室

**+ 2 种自定义方式：**
- 📸 **上传任意图片**：JPG/PNG 均支持，自动适配分辨率
- 🖥️ **同步系统桌面壁纸**：实时跟随 macOS 壁纸切换

---

#### 🤖 3D 电子宠物（全网唯一！）

这不是摆设——这是一个完整的**赛博机器人伙伴**，基于 SceneKit 3D 引擎构建：

**外观设计：**
- 白色圆润机身，科技蓝自发光眼睛，金属天线，悬浮球形双手
- 肚皮内嵌核心显示屏
- 真实金属材质渲染（金属度/粗糙度物理参数）

**属性成长系统：**

| 属性 | 说明 | 衰减机制 |
|------|------|---------|
| 🎚️ 等级 (Lv) | 无上限成长 | 经验积累升级 |
| 💛 饥饿度 | 0-100 | 每5秒自动 -1 |
| 🫧 清洁度 | 0-100 | 每5秒自动 -1 |
| 😄 快乐度 | 0-100 | 每5秒自动 -0.5 |
| ⭐ 经验值 | 升级所需翻倍 | 互动操作 +5 XP |

**互动方式（每日各限 5 次）：**
- 🍴 **喂食**：饥饿度 +20
- 💧 **洗澡**：清洁度 +20
- 🎮 **玩耍**：快乐度 +20

**3D 动画：**待机浮动 · 眨眼 · 天线摆动 · 喜悦跳跃 · 旋转庆祝

**宠物会和你说话！** 随机发送状态播报、闲聊、欢迎语，就像真正的桌面伙伴。

---

#### 📁 文件夹管理

- **拖拽创建**：将一个应用图标拖到另一个上，自动创建文件夹（悬停 0.5s 确认）
- **重命名**：点击文件夹名称即可编辑
- **毛玻璃展开面板**：3 列网格展示文件夹内应用
- **智能解散**：文件夹内仅剩 1 个应用时自动解散，恢复独立图标
- **跨页拖拽**：支持将应用跨页拖入文件夹

---

#### 🔍 智能搜索

- 实时模糊匹配应用名称
- **支持汉字拼音首字母**搜索（输入 `wx` 找到「微信」）
- 搜索范围：应用名 + Bundle ID + 文件夹名（递归搜索）
- `Cmd + F` 快速聚焦搜索栏
- 搜索时自动跳转至第一页

---

#### ⌨️ 快捷键 & 全局热键

| 操作 | 快捷键 |
|------|--------|
| 唤起 / 隐藏启动器 | `Option + Space` |
| 搜索应用 | `Cmd + F` |
| 下一页 | `→ 右箭头` 或 两指左滑 |
| 上一页 | `← 左箭头` 或 两指右滑 |
| 切换主题（环境循环） | `Cmd + Shift + T` |
| 关闭启动器 | `ESC` |

全局热键在任何应用中均有效，**不打断工作流**。

---

#### 🖱️ 拖拽排序

所有应用图标支持拖拽重新排序，排列顺序持久化保存。两种布局模式均支持拖拽。

---

#### 🌍 多语言界面

内置 6 种语言本地化，自动跟随系统语言：
- 简体中文 · English · 日本語 · Español · Français · Deutsch

同时支持**应用名称本地化**——中文系统显示「微信」，英文系统显示「WeChat」。

---

#### 💾 所有设置自动保存

布局模式、背景环境、自定义壁纸路径、宠物状态……所有个性化配置均持久化，重启应用后完整恢复。

---

#### 🔐 完全本地，零数据收集

- ✅ 无网络请求
- ✅ 无账号注册
- ✅ 无数据上传
- ✅ 无广告、无追踪
- ✅ 源代码完全公开

---

### 📋 系统要求

| 需求 | 说明 |
|------|------|
| **macOS** | 14.0 (Sonoma) 及以上，完整支持 15 (Sequoia) / 26 (Tahoe) |
| **处理器** | Apple Silicon (M1 至 M5) 或 Intel |
| **内存** | 512MB 以上 |
| **磁盘** | 约 50MB |

---

### 🚀 下载安装

#### 方式一：DMG 安装包（推荐普通用户）

1. 打开 [Releases](https://github.com/ranqihang/visionstyle/releases) 页面，下载最新 `.dmg`
2. 双击打开 DMG，将 **Spatia Launcher** 拖入 **Applications** 文件夹
3. 在 Launchpad 或 Spotlight 中搜索 "Spatia" 启动
4. 首次运行如提示"无法验证开发者"，请前往：**系统设置 → 隐私与安全性 → 仍要打开**

#### 方式二：从源码编译（开发者）

**前置要求**：Xcode 15+

```bash
git clone https://github.com/ranqihang/visionstyle.git
cd visionstyle
open visionstyle.xcodeproj
```

在 Xcode 中选择 **Product → Build**，或使用命令行：

```bash
xcodebuild -scheme visionstyle -configuration Release -derivedDataPath build build
```

编译产物在 `build/Build/Products/Release/` 目录下。

---

### 📖 使用指南

**首次使用：**

1. 按 `Option + Space` 唤起启动器
2. 点击左侧 Dock 底部的齿轮图标打开设置
3. 在设置中切换布局模式（空间/经典）
4. 选择你喜欢的背景环境
5. 右下角的宠物会向你打招呼 👋

**文件夹管理：**

将应用图标拖到另一个应用上，悬停片刻松开 → 自动创建文件夹。支持重命名、拖入更多应用。

**宠物互动：**

右键点击宠物或悬停后点击，选择喂食 / 洗澡 / 玩耍。宠物会实时做出反应并更新状态。

---

### 🛠️ 开发者文档

#### 项目结构

```
visionstyle/
├── visionstyleApp.swift              # 应用入口 & 窗口管理
├── Views/
│   ├── MainLauncherView.swift        # 主界面（布局/搜索/分页）
│   ├── Background/
│   │   └── SpatialBackgroundView.swift  # 背景环境渲染
│   ├── Components/
│   │   ├── AppIconView.swift         # 通用图标组件
│   │   ├── VisionOSAppIconView.swift # 空间模式图标（毛玻璃特效）
│   │   ├── FolderIconView.swift      # 文件夹图标
│   │   ├── FolderExpandedView.swift  # 文件夹展开浮层
│   │   ├── SearchBarView.swift       # 搜索栏（Liquid Glass 风格）
│   │   ├── SidebarDockView.swift     # 左侧竖向 Dock
│   │   └── ScrollWheelHandler.swift  # 双指滑动翻页处理
│   ├── Layout/
│   │   ├── HoneycombLayout.swift     # 蜂巢布局 + PaginatedHoneycombView
│   │   └── ClassicGridLayout.swift   # 经典网格 + PaginatedClassicView
│   ├── Settings/
│   │   └── SettingsView.swift        # 设置面板（布局/背景/快捷键/关于）
│   └── Launch/
│       └── LaunchAnimationView.swift # 启动动画
├── Managers/
│   ├── AppStateManager.swift         # 核心状态（应用列表/分页/搜索/拖排）
│   ├── ThemeManager.swift            # 主题/背景/布局模式持久化
│   ├── HotKeyManager.swift           # 全局 Option+Space 监听
│   ├── DragDropManager.swift         # 拖拽排序逻辑
│   └── AppReviewManager.swift        # 评分引导
├── Pet/
│   ├── PetModel.swift                # 宠物属性/状态模型
│   ├── PetSceneView.swift            # SceneKit 3D 场景
│   ├── PetView.swift                 # 宠物 SwiftUI 视图 + 气泡消息
│   ├── PetManager.swift              # 属性衰减/互动/经验/升级逻辑
│   └── PetWindowManager.swift        # 宠物独立浮窗管理
├── Models/
│   ├── AppItem.swift                 # 扫描到的应用数据结构
│   └── GridElement.swift             # 网格元素（app / folder）
├── Services/
│   └── AppScannerService.swift       # 扫描 /Applications 等路径
├── Resources/
│   └── *.lproj/Localizable.strings  # 6 语言本地化
└── Utilities/
    └── String+Localization.swift     # 本地化工具扩展
```

#### 核心模块说明

| 模块 | 作用 |
|------|------|
| `AppScannerService` | 扫描 `/Applications`、`~/Applications`、`/System/Applications` |
| `AppStateManager` | 分页、搜索过滤（含拼音）、拖拽排序、文件夹增删 |
| `ThemeManager` | 环境背景、布局模式、系统壁纸监听、UserDefaults 持久化 |
| `HotKeyManager` | 注册系统级全局热键（Carbon API），Option+Space |
| `PetManager` | 宠物属性实时衰减（Timer）、互动日限（UserDefaults 日期键） |
| `PetSceneView` | SceneKit 3D 机器人渲染，动画控制器 |
| `PetWindowManager` | 宠物悬浮窗口  (`NSWindow.Level.mainMenu`)，跨 Space 显示 |
| `HoneycombLayout` | 三行蜂巢算法（3N+1 容量），响应式计算 |
| `ClassicGridLayout` | 矩形网格动态行列计算（5-10列 × 3-7行） |

#### 编译 & 调试

```bash
# Debug 编译
xcodebuild -scheme visionstyle -configuration Debug build

# Release 编译
xcodebuild -scheme visionstyle -configuration Release -derivedDataPath build build

# 运行测试
xcodebuild -scheme visionstyle test
```

---

### 🤝 参与贡献

欢迎所有形式的贡献：

- 🐛 提交 Bug：[GitHub Issues](https://github.com/ranqihang/visionstyle/issues)
- ✨ 功能建议：[GitHub Discussions](https://github.com/ranqihang/visionstyle/discussions)
- 🔧 提交代码：Fork → 新建分支 → PR，详见 [CONTRIBUTING.md](./CONTRIBUTING.md)
- 🌐 翻译其他语言（目前支持 6 种）
- ⭐ 给项目点 Star，让更多人看到！

---

### 📝 许可证

本项目采用 **GNU General Public License v3.0**，详见 [LICENSE](./LICENSE)。

- ✅ 可自由使用、修改、分发
- ✅ 可基于本项目创建衍生作品
- ⚠️ 衍生作品须同样采用 GPL v3 开源

---

### 📞 联系

- 官网：[macLauncher.lmstation.ai](https://macLauncher.lmstation.ai)
- Issues：[GitHub Issues](https://github.com/ranqihang/visionstyle/issues)
- Email：info@lmstation.ai

---

## English

### 🚨 Why You Need Spatia Launcher

**macOS 26 Tahoe removed the traditional Launchpad.**

Apple significantly redesigned the app-launching experience in macOS 26 (Tahoe), removing the classic full-screen Launchpad that millions of Mac users relied on. If you're looking for a free, feature-rich replacement that feels right at home on modern macOS, Spatia Launcher is your answer.

**Spatia Launcher is the best free Launchpad alternative available** — it not only restores the classic experience but elevates it with Apple Vision Pro-inspired spatial computing aesthetics. **100% free. 100% open source.**

> 💡 **Why open source?** Due to App Store review policy restrictions, this app couldn't be published there. We've decided to release the full source code under GPL v3 so everyone can use and improve it freely.

---

### ✨ Features

#### 🎨 Dual Layout Modes

| Mode | Style | Best For |
|------|-------|----------|
| **Spatial Mode (Honeycomb)** | Vision Pro-style three-row honeycomb, center-raised, deeply immersive | Users who love cutting-edge design |
| **Classic Mode (Grid)** | Traditional Launchpad rectangular grid, 5-10 columns adaptive | Users who miss the original Launchpad |

Switch between modes **instantly from the Settings panel**, with all layout parameters auto-optimized for your screen size.

---

#### 🌅 13 Beautiful Background Environments

**6 Dynamic Gradient Environments:**
- 🛋️ Living Room · 🎓 Dark Study · 🏔️ Alpine Mountain · 🌌 Aurora Night · 🌅 Sunset Beach · 🌿 Zen Garden

**6 High-Resolution Photo Environments:**
- 🔥 Elegant Fireplace · 🎨 Nordic Art · 🖤 Modern Gray · ☀️ Cloud Sunrise · 🏞️ Lake Mountain · 🎙️ Dark Studio

**+ 2 Custom Options:**
- 📸 **Upload any image**: JPG/PNG, auto-scaled to your display
- 🖥️ **Sync with macOS wallpaper**: Follows your system wallpaper in real time

---

#### 🤖 3D Desktop Pet (Unique Feature!)

A fully interactive **Cyber Robot companion**, built with SceneKit 3D engine:

**Design:**
- White rounded body, glowing tech-blue eyes, metallic antenna, floating sphere hands
- Belly display screen with core indicator
- Physically-based rendering with metalness / roughness parameters

**Growth System:**

| Attribute | Description | Decay |
|-----------|-------------|-------|
| 🎚️ Level | Unlimited growth | XP accumulation |
| 💛 Hunger | 0–100 | -1 every 5 seconds |
| 🫧 Cleanliness | 0–100 | -1 every 5 seconds |
| 😄 Happiness | 0–100 | -0.5 every 5 seconds |
| ⭐ XP | Doubles each level | +5 per interaction |

**Interactions (5 times per day each):**
- 🍴 **Feed** — Hunger +20
- 💧 **Wash** — Cleanliness +20
- 🎮 **Play** — Happiness +20

**3D Animations:** Idle float · Blinking · Antenna wiggle · Joy jump · Victory spin

**Your pet talks to you!** It greets you, broadcasts status, and sends random messages like a real desktop buddy.

---

#### 📁 Folder Management

- **Drag-to-create**: Drag one app icon onto another, hold briefly → auto-creates a folder
- **Rename**: Tap the folder title to edit inline
- **Frosted glass expanded panel**: 3-column grid showing folder contents
- **Auto-dissolve**: Folder with only 1 app left dissolves automatically
- **Cross-page drag**: Move apps into folders across different pages

---

#### 🔍 Smart Search

- Real-time fuzzy matching on app names
- **Pinyin initial search** for Chinese app names (`wx` → finds 微信 / WeChat)
- Search scope: app names + Bundle IDs + folder names (recursive)
- `Cmd + F` to instantly focus search bar
- Auto-jumps to page 1 when search is active

---

#### ⌨️ Hotkeys & Global Shortcuts

| Action | Shortcut |
|--------|----------|
| Show / Hide launcher | `Option + Space` |
| Search | `Cmd + F` |
| Next page | `→` or two-finger swipe left |
| Previous page | `←` or two-finger swipe right |
| Cycle background environment | `Cmd + Shift + T` |
| Close launcher | `ESC` |

Global hotkey works **from any app** — zero workflow interruption.

---

#### 🖱️ Drag & Drop Reordering

All app icons support drag-and-drop reordering. Order is persisted across relaunches. Both layout modes support drag reordering.

---

#### 🌍 6-Language Interface

Automatically follows system language:
- English · 简体中文 · 日本語 · Español · Français · Deutsch

Also shows **localized app names** — displays "WeChat" in English, "微信" in Chinese.

---

#### 💾 Everything Auto-Saved

Layout mode, background environment, custom wallpaper path, pet status, app order — all settings persist and restore on next launch.

---

#### 🔐 Fully Local, Zero Data Collection

- ✅ No network requests
- ✅ No account required
- ✅ No data uploads
- ✅ No ads, no tracking
- ✅ Fully open source

---

### 📋 System Requirements

| Requirement | Details |
|-------------|---------|
| **macOS** | 14.0 (Sonoma) or later; fully supports 15 (Sequoia) / 26 (Tahoe) |
| **Processor** | Apple Silicon (M1–M5) or Intel |
| **RAM** | 512MB minimum |
| **Disk** | ~50MB |

---

### 🚀 Installation

#### Option 1: DMG Installer (Recommended)

1. Download the latest `.dmg` from [Releases](https://github.com/ranqihang/visionstyle/releases)
2. Open the DMG and drag **Spatia Launcher** to **Applications**
3. Launch it from Spotlight or Finder
4. If macOS shows "unverified developer" warning: **System Settings → Privacy & Security → Open Anyway**

#### Option 2: Build from Source (Developers)

**Prerequisites:** Xcode 15+

```bash
git clone https://github.com/ranqihang/visionstyle.git
cd visionstyle
open visionstyle.xcodeproj
```

Or via command line:

```bash
xcodebuild -scheme visionstyle -configuration Release -derivedDataPath build build
```

Output: `build/Build/Products/Release/`

---

### 📖 Quick Start

1. Press `Option + Space` to summon the launcher
2. Click the gear icon on the left Dock to open Settings
3. Switch layout mode (Spatial / Classic)
4. Pick your favorite background
5. The pet in the bottom-right corner will greet you 👋

---

### 🛠️ Developer Documentation

#### Key Modules

| Module | Purpose |
|--------|---------|
| `AppScannerService` | Scans `/Applications`, `~/Applications`, `/System/Applications` |
| `AppStateManager` | Paging, fuzzy + pinyin search, drag reorder, folder management |
| `ThemeManager` | Environments, layout mode, wallpaper sync, UserDefaults persistence |
| `HotKeyManager` | System-level global hotkey via Carbon API |
| `PetManager` | Real-time attribute decay (Timer), daily interaction limits |
| `PetSceneView` | SceneKit 3D robot rendering & animation controller |
| `PetWindowManager` | Floating NSWindow at `MainMenu` level, visible across all Spaces |
| `HoneycombLayout` | Three-row honeycomb algorithm (3N+1 capacity), responsive |
| `ClassicGridLayout` | Rectangular grid with dynamic row/column calculation (5–10 × 3–7) |

#### Build Commands

```bash
# Debug
xcodebuild -scheme visionstyle -configuration Debug build

# Release
xcodebuild -scheme visionstyle -configuration Release -derivedDataPath build build

# Test
xcodebuild -scheme visionstyle test
```

---

### 🤝 Contributing

We welcome contributions of all kinds:

- 🐛 Bug reports: [GitHub Issues](https://github.com/ranqihang/visionstyle/issues)
- ✨ Feature requests: [GitHub Discussions](https://github.com/ranqihang/visionstyle/discussions)
- 🔧 Code: Fork → new branch → PR, see [CONTRIBUTING.md](./CONTRIBUTING.md)
- 🌐 Translations for additional languages
- ⭐ Star the repo to help others find it!

---

### 📝 License

**GNU General Public License v3.0** — see [LICENSE](./LICENSE).

- ✅ Free to use, modify, and distribute
- ✅ Derivative works permitted
- ⚠️ Derivatives must remain GPL v3 open source

---

### 📞 Contact

- Website: [macLauncher.lmstation.ai](https://macLauncher.lmstation.ai)
- Issues: [GitHub Issues](https://github.com/ranqihang/visionstyle/issues)
- Email: info@lmstation.ai

---

<div align="center">

Made with ❤️ for the macOS community · GPL v3 Open Source

**⭐ Star this repo if Spatia Launcher saved your workflow! ⭐**

</div>
