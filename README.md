# Mac定时器应用

一个简洁美观的Mac定时器应用，支持自定义定时时长和多种提醒方式。

## 功能特性

- ✅ 自定义定时时长设置
- ✅ 预设时长快速选择（15分钟、30分钟、45分钟、1小时）
- ✅ 启动/暂停/重置控制
- ✅ 弹窗提醒功能
- ✅ 声音提醒功能
- ✅ 简洁美观的界面设计
- ✅ 后台运行支持

## 使用方法

### 编译和运行

1. 确保已安装Xcode和Swift工具链
2. 在终端中进入项目目录：
   ```bash
   cd /Users/wqz/Documents/work/tools/timer
   ```

3. 编译应用：
   ```bash
   swift build
   ```

4. 运行应用：
   ```bash
   swift run TimerApp
   ```

或者使用提供的启动脚本：
```bash
./run.sh
```

### 使用说明

1. **设置定时时长**：
   - 点击预设按钮选择常用时长
   - 或点击"自定义"输入分钟数

2. **控制定时器**：
   - 点击"开始"按钮启动定时器
   - 点击"暂停"暂停计时
   - 点击"重置"重置定时器

3. **提醒设置**：
   - 定时结束时自动显示系统弹窗通知
   - 同时播放系统提示音

## 项目结构

```
TimerApp/
├── Package.swift          # Swift包配置文件
├── Sources/
│   ├── main.swift         # 应用入口点
│   ├── AppDelegate.swift  # 应用委托
│   ├── ContentView.swift  # 主界面UI
│   └── TimerModel.swift   # 定时器核心逻辑
├── run.sh                 # 启动脚本
└── README.md             # 说明文档
```

## 技术栈

- **开发语言**：Swift
- **UI框架**：SwiftUI
- **通知系统**：UserNotifications
- **音频播放**：AudioToolbox

## 系统要求

- macOS 12.0+
- Swift 5.7+

## 开发说明

应用采用MVVM架构设计：
- **TimerModel**：处理定时器逻辑和状态管理
- **ContentView**：负责UI展示和用户交互
- **AppDelegate**：应用生命周期管理

## 后续扩展计划

- [ ] 菜单栏快捷控制
- [ ] 多定时器支持
- [ ] 自定义音效选择
- [ ] 定时器模板保存
- [ ] 使用统计功能