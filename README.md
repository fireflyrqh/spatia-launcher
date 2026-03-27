# Spatia Launcher

<div align="center">

[简体中文](#简体中文--chinese) | [English](#english)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-brightgreen)]()
[![Architecture](https://img.shields.io/badge/arch-ARM64%20%7C%20x86__64-brightgreen)]()

A modern macOS app launcher combining Vision Pro's spatial computing design with classic Launchpad functionality.

[下载](#下载安装) • [Features](#特性) • [开发](#-开发) • [贡献](#贡献)

</div>

---

## 简体中文 (Chinese)

### 📖 简介

Spatia Launcher 是一款专为 macOS 设计的下一代应用启动器，将 Apple Vision Pro 的空间计算设计理念完整带入你的 Mac 桌面。如果你怀念 Launchpad 的易用性，同时渴望体验前沿的设计风格，Spatia Launcher 就是你的完美选择。

**特别说明**：由于无法在 App Store 上架，我们决定将这个项目完全开源，采用 GPL v3 许可证，欢迎各位开发者参与贡献！

### ✨ 特性

- **🎨 双模式启动体验**
  - 空间模式：Vision Pro 风格的蜂巢布局，沉浸式空间计算体验
  - 经典模式：传统网格布局，保留熟悉的操作习惯

- **🌅 12 种精美背景环境**
  - 6 种动态渐变效果
  - 6 张高清实景图片
  - 支持系统桌面壁纸
  - 支持自定义上传图片

- **⌨️ 全局热键快速启动**
  - 按 `Option + Space` 快速唤起（任何应用中有效）
  - 按 `ESC` 快速隐藏
  - 无缝切换，不中断工作流

- **🔍 智能搜索**
  - 快速查找已安装应用
  - 实时搜索过滤
  - 即搜即得

- **🌍 多语言支持**
  - 中文（简体）
  - 英文
  - 日本語
  - Español
  - Français
  - Deutsch

- **💾 个性化设置永久保存**
  - 自动保存背景选择、主题偏好等
  - 关闭应用后自动恢复设置

### 📋 系统要求

| 项目 | 要求 |
|-----|------|
| **macOS 版本** | 14.0 (Sonoma) 或更高版本 |
| **处理器** | Apple Silicon (M1-M5) 或 Intel |
| **内存** | 最小 512MB |
| **磁盘空间** | ~50MB |

### 🚀 下载安装

#### 方式 1：从 DMG 安装包

1. 在 [Releases](https://github.com/ranqihang/visionstyle/releases) 页面下载最新的 `.dmg` 文件
2. 打开 DMG 文件
3. 拖拽 **Spatia Launcher** 到 **Applications** 文件夹
4. 打开 Applications 文件夹，双击启动应用

#### 方式 2：从源码编译

**前置条件**：安装 Xcode 15+

```bash
# Clone 仓库
git clone https://github.com/ranqihang/visionstyle.git
cd visionstyle

# 打开 Xcode 项目
open visionstyle.xcodeproj

# 或使用命令行编译（Release 版本）
xcodebuild -scheme visionstyle \
           -configuration Release \
           -derivedDataPath build \
           build
```

编译完成后，在 `build/Release/` 目录中找到 `Spatia Launcher.app`

### 📖 使用指南

#### 基础操作

| 操作 | 快捷键 |
|-----|-------|
| 打开启动器 | `Option + Space` 或 从 Dock 打开 |
| 搜索应用 | 输入应用名称 |
| 启动应用 | 单击应用图标 |
| 关闭启动器 | `ESC` 或 点击窗口外 |

#### 设置选项

- **切换模式**：点击设置按钮，选择"空间模式"或"经典模式"
- **更改背景**：点击设置按钮，选择不同的背景环境
- **自定义壁纸**：上传你自己的图片作为背景
- **修改热键**：在设置中自定义全局快捷键（即将推出）

### 🛠️ 开发

#### 项目结构

```
visionstyle/
├── visionstyleApp.swift              # 应用入口
├── Views/                             # UI 视图层
│   ├── MainLauncherView.swift        # 主启动器视图
│   ├── Background/                   # 背景视图
│   ├── Components/                   # UI 组件
│   ├── Layout/                       # 布局引擎
│   ├── Settings/                     # 设置界面
│   └── Launch/                       # 启动动画
├── Managers/                          # 业务逻辑管理
│   ├── AppStateManager.swift         # 应用状态
│   ├── ThemeManager.swift            # 主题管理
│   ├── HotKeyManager.swift           # 热键处理
│   ├── DragDropManager.swift         # 拖拽操作
│   └── AppReviewManager.swift        # 应用评价处理
├── Models/                            # 数据模型
├── Services/                          # 系统服务
├── Resources/                         # 本地化资源
└── Utilities/                         # 工具类
```

#### 主要模块说明

| 模块 | 功能 |
|-----|------|
| **AppScannerService** | 扫描系统应用，获取已安装应用列表 |
| **AppStateManager** | 管理应用的运行状态和缓存 |
| **ThemeManager** | 管理主题切换和背景环境 |
| **HotKeyManager** | 处理全局快捷键事件 |
| **DragDropManager** | 处理应用拖拽排序操作 |
| **PetManager** | 宠物功能管理（彩蛋功能） |

#### 编译命令

```bash
# Debug 版本编译
xcodebuild -scheme visionstyle -configuration Debug build

# Release 版本编译
xcodebuild -scheme visionstyle -configuration Release build

# 运行单元测试（如有）
xcodebuild -scheme visionstyle test

# 代码签名和公证（发布用）
codesign -s - Spatia\ Launcher.app
```

### 🔐 隐私和安全

- ✅ **完全本地运行**：所有操作均在本地进行
- ✅ **无数据收集**：不收集任何用户数据
- ✅ **无网络连接**：应用不需要网络即可完整运行
- ✅ **开源透明**：代码完全开源，接受社区审查

### 📝 许可证

本项目采用 **GNU General Public License v3.0** 许可证。你可以自由：
- 使用、修改、分发本项目
- 创建基于本项目的衍生作品

但需要遵守 GPL v3 条款，详见 [LICENSE](./LICENSE) 文件。

### 🤝 贡献

欢迎多种形式的贡献！包括：

- 🐛 Bug 报告和修复
- ✨ 新功能建议和实现
- 📚 文档改进
- 🌐 翻译贡献
- 📧 代码审查

详见 [CONTRIBUTING.md](./CONTRIBUTING.md) 获取完整指南。

### 📞 联系方式

- 官网：[macLauncher.lmstation.ai](https://macLauncher.lmstation.ai)
- 问题反馈：[GitHub Issues](https://github.com/ranqihang/visionstyle/issues)
- 技术讨论：[GitHub Discussions](https://github.com/ranqihang/visionstyle/discussions)

---

## English

### 📖 Introduction

Spatia Launcher is a next-generation macOS app launcher that brings Apple Vision Pro's spatial computing design philosophy to your Mac desktop. If you miss Launchpad's simplicity while craving a modern design experience, Spatia Launcher is your perfect choice.

**Note**: Since the app couldn't be listed on the App Store, we decided to completely open-source this project under the GPL v3 license. We welcome contributions from all developers!

### ✨ Features

- **🎨 Dual-Mode Launcher Experience**
  - Spatial Mode: Vision Pro-style honeycomb layout with immersive spatial computing
  - Classic Mode: Traditional grid layout with familiar operations

- **🌅 12 Beautiful Background Environments**
  - 6 dynamic gradient effects
  - 6 high-resolution scenic photos
  - System desktop wallpaper support
  - Custom image upload support

- **⌨️ Global Hotkey Quick Launch**
  - Press `Option + Space` to activate from any application
  - Press `ESC` to hide
  - Seamless workflow integration

- **🔍 Smart Search**
  - Quickly find installed applications
  - Real-time search filtering
  - Instant results

- **🌍 Multi-Language Support**
  - English
  - 简体中文 (Chinese)
  - 日本語 (Japanese)
  - Español (Spanish)
  - Français (French)
  - Deutsch (German)

- **💾 Personalized Settings Auto-Save**
  - Automatically save background and theme preferences
  - Settings restored on app launch

### 📋 System Requirements

| Item | Requirement |
|------|-------------|
| **macOS Version** | 14.0 (Sonoma) or later |
| **Processor** | Apple Silicon (M1-M5) or Intel |
| **Memory** | Minimum 512MB |
| **Disk Space** | ~50MB |

### 🚀 Installation

#### Method 1: Install from DMG

1. Download the latest `.dmg` file from [Releases](https://github.com/ranqihang/visionstyle/releases)
2. Open the DMG file
3. Drag **Spatia Launcher** to the **Applications** folder
4. Open Applications folder and double-click to launch

#### Method 2: Build from Source

**Prerequisites**: Xcode 15 or later

```bash
# Clone the repository
git clone https://github.com/ranqihang/visionstyle.git
cd visionstyle

# Open Xcode project
open visionstyle.xcodeproj

# Or compile from command line (Release build)
xcodebuild -scheme visionstyle \
           -configuration Release \
           -derivedDataPath build \
           build
```

After compilation, find `Spatia Launcher.app` in the `build/Release/` directory

### 📖 User Guide

#### Basic Operations

| Action | Hotkey |
|--------|--------|
| Open Launcher | `Option + Space` or from Dock |
| Search Apps | Type app name |
| Launch App | Click app icon |
| Close Launcher | `ESC` or click outside window |

#### Settings

- **Switch Modes**: Click settings button, choose "Spatial Mode" or "Classic Mode"
- **Change Background**: Click settings button, select different backgrounds
- **Custom Wallpaper**: Upload your own image as background
- **Customize Hotkey**: Modify global hotkey in settings (Coming soon)

### 🛠️ Development

#### Project Structure

```
visionstyle/
├── visionstyleApp.swift              # Application entry point
├── Views/                             # UI view layer
│   ├── MainLauncherView.swift        # Main launcher view
│   ├── Background/                   # Background views
│   ├── Components/                   # UI components
│   ├── Layout/                       # Layout engines
│   ├── Settings/                     # Settings interface
│   └── Launch/                       # Launch animations
├── Managers/                          # Business logic management
│   ├── AppStateManager.swift         # Application state
│   ├── ThemeManager.swift            # Theme management
│   ├── HotKeyManager.swift           # Hotkey handling
│   ├── DragDropManager.swift         # Drag & drop operations
│   └── AppReviewManager.swift        # App review handling
├── Models/                            # Data models
├── Services/                          # System services
├── Resources/                         # Localization resources
└── Utilities/                         # Utility classes
```

#### Key Modules

| Module | Purpose |
|--------|---------|
| **AppScannerService** | Scan system applications and installed apps list |
| **AppStateManager** | Manage application state and caching |
| **ThemeManager** | Handle theme switching and backgrounds |
| **HotKeyManager** | Process global hotkey events |
| **DragDropManager** | Handle app drag & drop sorting |
| **PetManager** | Pet feature management (Easter egg) |

#### Build Commands

```bash
# Debug build
xcodebuild -scheme visionstyle -configuration Debug build

# Release build
xcodebuild -scheme visionstyle -configuration Release build

# Run unit tests
xcodebuild -scheme visionstyle test

# Code signing and notarization (for distribution)
codesign -s - Spatia\ Launcher.app
```

### 🔐 Privacy & Security

- ✅ **Runs Completely Locally**: All operations are local
- ✅ **Zero Data Collection**: No user data is collected
- ✅ **No Network Required**: App works without internet connection
- ✅ **Open Source & Transparent**: Code is fully open source for community review

### 📝 License

This project is licensed under the **GNU General Public License v3.0**. You are free to:
- Use, modify, and distribute this project
- Create derivative works based on this project

Subject to the GPL v3 terms. See [LICENSE](./LICENSE) for details.

### 🤝 Contributing

We welcome all kinds of contributions:

- 🐛 Bug reports and fixes
- ✨ Feature suggestions and implementations
- 📚 Documentation improvements
- 🌐 Translation contributions
- 📧 Code reviews

See [CONTRIBUTING.md](./CONTRIBUTING.md) for the complete guide.

### 📞 Contact

- Website: [macLauncher.lmstation.ai](https://macLauncher.lmstation.ai)
- Report Issues: [GitHub Issues](https://github.com/ranqihang/visionstyle/issues)
- Technical Discussion: [GitHub Discussions](https://github.com/ranqihang/visionstyle/discussions)

---

<div align="center">

Made with ❤️ by the Spatia Launcher Community

⭐ If you find this project helpful, please give it a star!

</div>
