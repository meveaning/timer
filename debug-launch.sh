#!/bin/bash

echo "🔧 TimerApp 调试启动"
echo "=================="
echo ""

echo "📝 新版本特点："
echo "- 启动时直接显示弹出窗口"
echo "- 添加了调试输出（print语句）"
echo "- 不自动隐藏，直到用户关闭"
echo "- 便于确认应用是否启动成功"
echo ""

# 停止现有进程
echo "🛑 停止现有TimerApp进程..."
pkill -f "TimerApp" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ 已停止现有进程"
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
echo "🚀 启动TimerApp（新版本）..."
echo ""
echo "📋 预期行为："
echo "1. 立即显示弹出控制界面"
echo "2. 弹出窗口保持打开状态"
echo "3. 菜单栏显示 ⏰ 图标"
echo "4. 可以手动关闭弹出窗口"
echo "5. 点击菜单栏 ⏰ 图标可重新打开"
echo ""

echo "🔍 调试信息："
echo "应用将在后台启动，调试输出可能不会显示在终端。"
echo "要查看调试输出，请打开 Console.app 并搜索 'TimerApp'"
echo ""

# 创建临时日志文件
LOGFILE="/tmp/timerapp-debug-$$.log"
echo "📝 日志文件: $LOGFILE"
echo "启动时间: $(date)" > "$LOGFILE"

echo ""
echo "🎯 现在启动应用..."
echo "方法：open TimerApp.app"
echo ""

# 启动应用
open TimerApp.app 2>&1 | tee -a "$LOGFILE" &
LAUNCH_PID=$!

echo "⏳ 等待应用启动（3秒）..."
sleep 3

echo ""
echo "🔍 检查应用状态："
echo "1. 进程状态："
ps aux | grep -i "TimerApp" | grep -v grep | grep -v debug-launch || echo "  未找到TimerApp进程"

echo ""
echo "2. 菜单栏检查："
echo "   请查看屏幕右上角菜单栏是否有 ⏰ 图标"
echo "   如果没有，尝试滚动菜单栏或点击'显示全部'按钮"

echo ""
echo "3. 窗口检查："
echo "   屏幕中央是否有弹出控制界面？"
echo "   界面标题应为'定时器'，显示时间00:30:00"

echo ""
echo "4. 操作测试："
echo "   - 点击 ⏰ 图标：应打开/关闭控制界面"
echo "   - 点击界面中的按钮：应有响应"
echo "   - 关闭弹出窗口：点击窗口外部或按ESC"

echo ""
echo "📊 系统信息："
echo "macOS版本: $(sw_vers -productVersion)"
echo "架构: $(uname -m)"
echo "当前用户: $(whoami)"

echo ""
echo "💡 如果仍然看不到窗口："
echo "1. 尝试右键点击 TimerApp.app → '打开'"
echo "2. 检查系统偏好设置 → 安全性与隐私 → 隐私 → 辅助功能"
echo "3. 检查 Console.app 中的错误日志"
echo "4. 运行完整诊断: ./diagnose-timerapp.sh"

echo ""
echo "🔧 要退出应用："
echo "右键点击菜单栏 ⏰ 图标 → 选择'退出'"

echo ""
read -p "按回车键查看日志文件内容（前20行）..."
echo ""
echo "📄 日志文件内容："
head -20 "$LOGFILE" 2>/dev/null || echo "日志文件不存在"

echo ""
echo "✅ 调试完成"
echo "请分享你看到的情况："
echo "1. 是否看到了弹出窗口？"
echo "2. 菜单栏是否有 ⏰ 图标？"
echo "3. 点击图标是否能打开控制界面？"
echo "4. 控制台是否有错误信息？"