#!/bin/bash

echo "🔍 TimerApp 详细诊断（带日志监控）"
echo "================================="
echo ""

echo "📝 新版本特点："
echo "- 使用NSLog记录详细启动过程"
echo "- 添加了完整的错误处理"
echo "- 备用窗口机制（如果状态栏失败）"
echo "- 启动时强制显示界面"
echo ""

# 停止现有进程
echo "🛑 停止现有TimerApp进程..."
pkill -f "TimerApp" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ 已停止现有进程"
    sleep 1
else
    echo "⚠️  无正在运行的进程"
fi

# 清除扩展属性
echo "🧹 清除扩展属性..."
xattr -cr TimerApp.app 2>/dev/null || true
echo "✅ 扩展属性已清除"

# 设置权限
echo "🔒 设置文件权限..."
chmod 755 TimerApp.app/Contents/MacOS/TimerApp
chmod 755 TimerApp.app
echo "✅ 权限已设置"

echo ""
echo "📊 系统状态检查："
echo "macOS版本: $(sw_vers -productVersion)"
echo "当前用户: $(whoami)"
echo "终端环境: $SHELL"
echo ""

echo "🔧 检查应用包完整性："
echo "可执行文件: $(file "TimerApp.app/Contents/MacOS/TimerApp")"
echo "文件大小: $(du -h "TimerApp.app/Contents/MacOS/TimerApp" | cut -f1)"
echo ""

echo "📋 预期启动流程："
echo "1. 🚀 TimerApp 启动开始 (NSLog)"
echo "2. 🔄 初始化定时器模型 (NSLog)"
echo "3. 🔄 创建状态栏项目 (NSLog)"
echo "4. ✅/❌ 状态栏创建结果 (NSLog)"
echo "5. 🪟 显示界面 (NSLog)"
echo "6. ✅ TimerApp 启动完成 (NSLog)"
echo ""

echo "🎯 现在启动应用..."
echo "启动命令: open TimerApp.app"
echo ""

echo "💡 重要：请保持终端窗口打开，并在另一个窗口中打开 Console.app"
echo "打开 Console.app 的方法："
echo "1. 打开 Finder → 应用程序 → 实用工具 → 控制台"
echo "2. 或使用 Spotlight 搜索 'Console'"
echo "3. 在 Console.app 中搜索 'TimerApp' 查看日志"
echo ""

# 创建监控日志的脚本
LOG_MONITOR_SCRIPT="/tmp/monitor-timerapp-$$.sh"
cat > "$LOG_MONITOR_SCRIPT" << 'EOF'
#!/bin/bash
echo "🔍 监控TimerApp日志（10秒）..."
echo "在Console.app中搜索 'TimerApp' 或查看以下输出："
echo "--------------------------------------------------"

# 尝试通过log命令捕获日志
timeout 10 log stream --predicate 'subsystem contains "TimerApp" OR process == "TimerApp" OR message contains "TimerApp"' --style compact 2>/dev/null || \
timeout 10 log show --predicate 'process == "TimerApp"' --last 30s --style compact 2>/dev/null || \
echo "无法直接访问系统日志，请在Console.app中手动查看"

echo "--------------------------------------------------"
echo "监控结束"
EOF

chmod +x "$LOG_MONITOR_SCRIPT"

# 在后台启动日志监控
echo "📡 启动日志监控（10秒）..."
"$LOG_MONITOR_SCRIPT" &
MONITOR_PID=$!

# 启动应用
echo "🚀 启动TimerApp..."
open TimerApp.app &
LAUNCH_PID=$!

echo "⏳ 等待应用启动..."
sleep 5

echo ""
echo "📊 应用状态检查："
echo "1. 进程状态："
ps aux | grep -i "TimerApp" | grep -v grep | grep -v test-with-logs || echo "   未找到TimerApp进程"

echo ""
echo "2. 界面检查："
echo "   A. Dock中是否有TimerApp图标？"
echo "   B. 菜单栏是否有 ⏰ 图标？（右上角）"
echo "   C. 是否有窗口弹出？"
echo "   D. 点击Dock图标（如果有）是否显示窗口？"

echo ""
echo "3. 系统日志检查："
echo "   请在Console.app中搜索 'TimerApp'，查看是否有以下日志："
echo "   - 🚀 TimerApp 启动开始"
echo "   - ✅ 定时器模型初始化完成"
echo "   - ✅/❌ 状态栏项目创建成功/失败"
echo "   - 🪟 显示初始界面"
echo "   - ✅ TimerApp 启动完成"

echo ""
echo "🔧 手动测试步骤："
echo "如果看到窗口："
echo "  1. 测试按钮功能（开始、暂停、重置）"
echo "  2. 关闭窗口，检查菜单栏图标是否还在"
echo "  3. 点击菜单栏图标重新打开窗口"
echo ""
echo "如果只看到菜单栏图标："
echo "  1. 点击 ⏰ 图标打开控制界面"
echo "  2. 测试功能是否正常"
echo ""
echo "如果什么都没看到："
echo "  1. 检查Console.app中的错误日志"
echo "  2. 尝试右键点击 TimerApp.app → '打开'"
echo "  3. 检查系统偏好设置 → 安全性与隐私 → 隐私 → 辅助功能"

echo ""
echo "📝 请记录以下信息："
echo "A. Console.app中看到了哪些日志？"
echo "B. Dock中是否有图标？"
echo "C. 菜单栏是否有 ⏰ 图标？"
echo "D. 是否有窗口显示？"
echo "E. 窗口中的按钮是否正常工作？"

echo ""
echo "🔚 要退出应用："
echo "1. 如果有Dock图标: 右键点击 → 退出"
echo "2. 如果只有菜单栏图标: 右键点击 ⏰ 图标 → 退出"
echo "3. 强制退出: pkill -f TimerApp"

echo ""
echo "✅ 诊断完成"
echo "请分享上述 A-E 的观察结果"