#!/bin/bash

echo "🚀 构建TimerApp (Apple Store标准版)..."

# 清理之前的构建
rm -rf TimerApp.app
rm -rf build

# 直接编译Swift文件
echo "📦 编译应用..."
swiftc Sources/*.swift \
    -o TimerApp \
    -target arm64-apple-macosx12.0 \
    -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
    -framework Cocoa \
    -framework SwiftUI \
    -framework Combine \
    -framework AVFoundation

if [ $? -ne 0 ]; then
    echo "❌ 编译失败，尝试使用系统Swift编译器..."
    # 使用系统Swift编译器
    swiftc Sources/*.swift \
        -o TimerApp \
        -framework Cocoa \
        -framework SwiftUI \
        -framework Combine \
        -framework AVFoundation
fi

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
    
    # 设置权限
    chmod +x TimerApp.app/Contents/MacOS/TimerApp
    
    echo "✅ TimerApp.app 创建完成！"
    echo "📁 文件大小：$(du -h TimerApp.app | cut -f1)"
    echo ""
    echo "🎯 使用方法："
    echo "1. 双击 TimerApp.app 运行"
    echo "2. 应用将在菜单栏显示图标"
    echo "3. 点击菜单栏图标打开控制界面"
    echo "4. 定时器会在菜单栏显示剩余时间"
    
else
    echo "❌ 编译失败，请检查Swift环境"
fi