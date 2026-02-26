#!/bin/bash

echo "🚀 构建完整的TimerApp应用包..."

# 清理之前的构建
rm -rf TimerApp.app
rm -rf build

# 编译应用
echo "📦 编译应用..."
swiftc Sources/*.swift \
    -o TimerApp \
    -framework Cocoa \
    -framework SwiftUI \
    -framework Combine \
    -framework AVFoundation

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    
    # 创建应用包结构
    mkdir -p TimerApp.app/Contents/MacOS
    mkdir -p TimerApp.app/Contents/Resources
    
    # 复制可执行文件
    cp TimerApp TimerApp.app/Contents/MacOS/
    
    # 复制Info.plist
    cp Info.plist TimerApp.app/Contents/
    
    # 创建PkgInfo
    echo "APPL????" > TimerApp.app/Contents/PkgInfo
    
    # 创建简单的应用图标（使用系统默认图标）
    echo "🎨 创建应用图标..."
    
    # 设置文件权限
    chmod +x TimerApp.app/Contents/MacOS/TimerApp
    chmod +x TimerApp.app
    
    # 设置应用包属性
    /usr/bin/setfile -a B TimerApp.app 2>/dev/null || true
    
    echo "✅ TimerApp.app 创建完成！"
    echo "📁 文件信息："
    echo "   大小：$(du -h TimerApp.app | tail -1 | cut -f1)"
    echo "   权限：$(ls -la TimerApp.app | cut -d' ' -f1)"
    echo ""
    echo "🎯 使用方法："
    echo "1. 双击 TimerApp.app 即可启动"
    echo "2. 应用将在菜单栏显示时钟图标"
    echo "3. 点击菜单栏图标打开控制界面"
    echo ""
    echo "💡 提示：如果双击无法启动，请尝试："
    echo "   - 右键点击 -> 打开"
    echo "   - 或在终端中运行: open TimerApp.app"
    
else
    echo "❌ 编译失败，请检查Swift环境"
fi