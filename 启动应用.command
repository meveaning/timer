#!/bin/bash

echo "🚀 正在启动 TimerApp..."
echo ""

# 清除可能的安全限制
xattr -cr TimerApp.app 2>/dev/null || true

# 设置正确权限
chmod 755 TimerApp.app
chmod 755 TimerApp.app/Contents/MacOS/TimerApp

echo "✅ 准备就绪，正在启动应用..."
echo ""
echo "💡 注意：TimerApp 是菜单栏应用，启动后："
echo "  1. 会在屏幕右上角显示 ⏰ 图标"
echo "  2. 不会出现在 Dock 中"
echo "  3. 点击 ⏰ 图标打开控制界面"
echo ""

# 启动应用
open TimerApp.app

echo ""
echo "✅ 应用已启动！"
echo "请查看屏幕右上角菜单栏是否有 ⏰ 图标"
echo ""
echo "如果没有看到图标，请："
echo "1. 稍等几秒钟"
echo "2. 检查菜单栏是否被其他应用隐藏"
echo "3. 点击菜单栏最右侧的"显示全部"按钮（如果有）"
echo ""
echo "要退出应用：右键点击 ⏰ 图标 → 选择'退出'"
echo ""
read -p "按回车键关闭此窗口..."