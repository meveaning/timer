#!/bin/bash

echo "🧪 测试TimerApp新启动行为"
echo "========================"
echo ""

echo "🎯 新功能："
echo "- 启动时显示2秒弹出界面"
echo "- 自动关闭后隐藏到菜单栏"
echo "- 便于确认应用已成功启动"
echo ""

# 停止任何正在运行的TimerApp
echo "🛑 停止现有TimerApp进程..."
pkill -f "TimerApp" 2>/dev/null && echo "✅ 已停止" || echo "⚠️  无正在运行的进程"

# 清除扩展属性
echo "🧹 清除扩展属性..."
xattr -cr TimerApp.app 2>/dev/null || true

# 设置权限
echo "🔒 设置权限..."
chmod 755 TimerApp.app/Contents/MacOS/TimerApp
chmod 755 TimerApp.app

echo ""
echo "🚀 启动TimerApp..."
echo "注意：您应该会看到："
echo "1. 弹出控制界面（显示2秒）"
echo "2. 界面自动关闭"
echo "3. 菜单栏显示 ⏰ 图标"
echo ""

# 启动应用
open TimerApp.app &
LAUNCH_PID=$!

echo "⏳ 等待应用启动..."
sleep 1

echo ""
echo "🔍 检查应用状态..."
echo "进程状态："
ps aux | grep -i "TimerApp" | grep -v grep | grep -v test-new-launch || echo "未找到进程"

echo ""
echo "⏳ 等待弹出界面自动关闭（2秒）..."
sleep 3

echo ""
echo "✅ 测试完成！"
echo ""
echo "📋 请确认："
echo "1. 启动时是否看到了弹出界面？"
echo "2. 2秒后界面是否自动关闭？"
echo "3. 菜单栏是否有 ⏰ 图标？"
echo "4. 点击 ⏰ 图标是否能重新打开控制界面？"
echo ""
echo "💡 如果看不到弹出界面："
echo "- 检查系统权限设置"
echo "- 尝试右键点击 TimerApp.app → 打开"
echo "- 检查Console.app中的日志"
echo ""
echo "🔧 要完全退出应用："
echo "右键点击菜单栏 ⏰ 图标 → 选择'退出'"