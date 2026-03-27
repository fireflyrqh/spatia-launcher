# 贡献指南

感谢你对 Spatia Launcher 的兴趣！我们欢迎任何形式的贡献。

## 开始之前

1. **Fork 这个仓库** - 点击 GitHub 页面右上角的 Fork 按钮
2. **Clone 你的 fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/visionstyle.git
   cd visionstyle
   ```
3. **添加上游仓库**
   ```bash
   git remote add upstream https://github.com/YOUR-PRIMARY-REPO/visionstyle.git
   ```

## 开发流程

### 1. 创建特性分支
```bash
git checkout -b feature/你的特性名称
# 或者修复 bug
git checkout -b fix/bug描述
```

### 2. 本地编译和测试
```bash
# 使用 Xcode 打开项目
open visionstyle.xcodeproj

# 或者使用命令行编译
xcodebuild -scheme visionstyle -configuration Debug build
```

### 3. 提交代码
- 编写清晰的提交信息（使用中文或英文）
- 每个提交应该是一个原子操作
```bash
git add .
git commit -m "feat: 添加新功能描述"
```

### 4. 创建 Pull Request
- 推送你的分支到 fork
- 在 GitHub 上创建 PR，描述你的更改内容
- 等待代码审查

## 代码规范

- 遵循 Swift 官方编码规范
- 添加必要的注释和文档
- 确保代码能在 macOS 14+ 上正常编译
- 支持 Apple Silicon (M1+) 和 Intel 架构

## 问题报告

如果发现 bug：
1. 检查是否已有类似的 issue
2. 在 [Issues](https://github.com/YOUR-REPO/issues) 中创建新 issue
3. 提供：
   - macOS 版本
   - 应用版本
   - 详细的复现步骤
   - 预期行为 vs 实际行为

## 许可证

你贡献的代码将遵循 GPL v3 许可证。参与即表示你同意这一条款。

---

有任何问题？欢迎在 GitHub Issues 中讨论！
