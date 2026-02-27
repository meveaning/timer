#!/bin/bash

echo "🔧 修复TimerApp启动问题..."
echo ""

# 清除扩展属性
echo "1. 清除扩展属性..."
xattr -cr TimerApp.app 2>/dev/null || true
echo "✅ 扩展属性已清除"

echo ""
echo "2. 设置正确权限..."
chmod 755 TimerApp.app
chmod 755 TimerApp.app/Contents/MacOS/TimerApp

echo ""
echo "🎯 启动应用的正确方法："
echo ""
echo "方法一：右键点击打开（推荐）"
echo "  1. 在Finder中找到 TimerApp.app"
echo "  2. 按住Control键点击或右键点击"
echo "  3. 选择'打开'"
echo "  4. 在安全提示中点击'打开'"
echo ""
echo "方法二：终端启动"
echo "  cd '$(pwd)'"
echo "  open TimerApp.app"
echo ""
echo "方法三：双击启动（如果系统允许）"
echo "  直接双击 TimerApp.app"
echo ""
echo "❌ 错误的方法："
echo "  ❌ /Users/wqz/Documents/work/tools/timer/TimerApp.app/Contents/MacOS/TimerApp"
echo "  ❌ 直接运行可执行文件"
echo ""
echo "💡 重要提示："
echo "  - TimerApp是菜单栏应用，启动后会在菜单栏显示⏰图标"
echo "  - 不会出现在Dock中"
echo "  - 点击菜单栏⏰图标打开控制界面"
echo "  - 要退出应用，右键点击菜单栏图标选择'退出'"
echo ""
echo "🔍 验证应用状态："
echo "  - 检查菜单栏右上角是否有⏰图标"
echo "  - 如果没有，尝试重启应用或检查系统权限"
echo ""
echo "📋 系统要求："
echo "  - macOS 12.0 (Monterey) 或更高版本"
echo "  - 适当的系统权限（辅助功能权限可能不需要）"
echo ""
echo "现在尝试启动应用..."
echo ""

# 提示用户尝试启动
echo "按回车键尝试用正确方式启动应用，或按Ctrl+C取消..."
read -r

open TimerApp.app

echo ""
echo "✅ 启动命令已执行"
echo "请检查菜单栏是否有⏰图标出现"