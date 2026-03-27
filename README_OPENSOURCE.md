# Spatia Launcher

[English](./README.md) | **简体中文**

一个专为 macOS 设计的现代应用启动器，融合 Vision Pro 的空间计算设计与经典启动板的易用性。

<p align="center">
  <strong>特性：双模式 • 丰富背景 • 全局热键 • 智能搜索</strong>
</p>

## ✨ 特性

### 🎨 双模式启动体验
- **空间模式**：采用 Vision Pro 风格的蜂巢布局，沉浸式空间计算体验
- **经典模式**：传统网格布局，保留熟悉的操作习惯

### 🌅 12 种精美背景环境
- 6 种动态渐变效果
- 6 张高清实景图片
- 支持系统桌面壁纸
- 支持自定义上传图片

### ⌨️ 全局热键快速启动
- 按 `Option + Space` 快速唤起（任何应用中有效）
- 按 `ESC` 快速隐藏
- 无缝切换，不中断工作流

### 🔍 智能搜索
- 快速查找已安装应用
- 实时搜索过滤
- 即搜即得

### 🌍 多语言支持
- 中文（简体）
- 英文
- 日本語
- Español
- Français
- Deutsch

## 📋 系统要求

- **macOS**: 14.0 或更高版本
- **架构**: Apple Silicon (M1+) 或 Intel
- **内存**: 最小 512MB

## 🚀 快速开始

### 下载安装

1. 在 [Releases](https://github.com/ranqihang/visionstyle/releases) 页面下载最新的 `.dmg` 文件
2. 打开 DMG，拖拽 Spatia Launcher 到 Applications 文件夹
3. 从 Launchpad 或 Spotlight 搜索 "Spatia Launcher" 启动

### 从源码编译

**前置条件**：安装 Xcode 15+

```bash
# Clone 仓库
git clone https://github.com/ranqihang/visionstyle.git
cd visionstyle

# 打开 Xcode 项目
open visionstyle.xcodeproj

# 或使用命令行编译
xcodebuild -scheme visionstyle -configuration Release build
```

## 📖 使用方法

### 基础操作
- **打开启动器**：按 `Option + Space` 或从 Dock 打开
- **搜索应用**：输入应用名称即可搜索
- **启动应用**：单击应用图标
- **关闭启动器**：按 `ESC` 或点击窗口外

### 设置
- **更改背景**：点击设置按钮选择不同背景
- **切换模式**：在设置中选择空间模式或经典模式
- **自定义热键**：在设置中修改全局热键（coming soon）

## 🛠️ 开发

### 项目结构
```
visionstyle/
├── Views/                  # UI 视图层
├── Managers/               # 业务逻辑管理
├── Models/                 # 数据模型
├── Services/               # 系统服务接口
├── Resources/              # 本地化资源和图片
└── Assets.xcassets/        # Xcode 资源
```

### 主要模块
- **AppScannerService**: 系统应用扫描
- **AppStateManager**: 应用状态管理
- **ThemeManager**: 主题和背景管理
- **HotKeyManager**: 全局快捷键
- **DragDropManager**: 拖拽操作处理

### 贡献指南

欢迎提交 Issue 和 Pull Request！详见 [CONTRIBUTING.md](./CONTRIBUTING.md)

## 📄 许可证

本项目采用 **GNU General Public License v3.0** 许可证。详见 [LICENSE](./LICENSE) 文件。

## 🤝 致谢

- UI 设计灵感来自 Apple Vision Pro
- 功能参考 BuhoLaunchpad 和原生 Launchpad
- 感谢所有贡献者的支持

## 📞 联系方式

- 官网：[macLauncher.lmstation.ai](https://macLauncher.lmstation.ai)
- 技术支持：[support.php](https://macLauncher.lmstation.ai/support.php)
- 隐私政策：[privacy.php](https://macLauncher.lmstation.ai/privacy.php)

---

<p align="center">
  ⭐ 如果觉得有帮助，欢迎 Star ⭐
</p>
