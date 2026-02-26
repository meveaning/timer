#!/bin/bash

echo "🔧 创建真正的双击启动应用..."

# 清理之前的构建
rm -rf TimerApp.app

# 编译应用
echo "📦 编译应用..."
swiftc Sources/*.swift \
    -o TimerAppExec \
    -framework Cocoa \
    -framework SwiftUI \
    -framework Combine \
    -framework AVFoundation

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    
    # 创建完整的应用包结构
    mkdir -p TimerApp.app/Contents/MacOS
    mkdir -p TimerApp.app/Contents/Resources
    
    # 复制可执行文件
    cp TimerAppExec TimerApp.app/Contents/MacOS/TimerApp
    
    # 创建正确的Info.plist
    cat > TimerApp.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>TimerApp</string>
    <key>CFBundleIdentifier</key>
    <string>com.timerapp.TimerApp</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>TimerApp</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2024 TimerApp. All rights reserved.</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF
    
    # 创建PkgInfo
    echo "APPL????" > TimerApp.app/Contents/PkgInfo
    
    # 设置正确的权限
    chmod 755 TimerApp.app/Contents/MacOS/TimerApp
    chmod 755 TimerApp.app
    
    # 清理临时文件
    rm -f TimerAppExec
    
    # 修复应用包属性
    xattr -cr TimerApp.app 2>/dev/null || true
    
    echo "✅ TimerApp.app 创建完成！"
    echo ""
    echo "🎯 正确的启动方式："
    echo "1. 双击 TimerApp.app 文件（推荐）"
    echo "2. 或在终端中运行: open TimerApp.app"
    echo ""
    echo "❌ 错误的启动方式："
    echo "   直接运行可执行文件: TimerApp.app/Contents/MacOS/TimerApp"
    echo "   （这会缺少GUI环境导致失败）"
    echo ""
    echo "💡 如果双击无法启动："
    echo "   - 右键点击 -> 打开"
    echo "   - 检查系统安全设置"
    
else
    echo "❌ 编译失败"
fi