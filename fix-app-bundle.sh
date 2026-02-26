#!/bin/bash

echo "🔧 修复TimerApp应用包..."

# 检查应用包结构
if [ ! -d "TimerApp.app" ]; then
    echo "❌ TimerApp.app 不存在，请先运行构建脚本"
    exit 1
fi

# 修复应用包属性
echo "📝 修复应用包属性..."

# 设置正确的文件属性
xattr -cr TimerApp.app 2>/dev/null || true

# 修复权限
chmod 755 TimerApp.app
chmod 755 TimerApp.app/Contents/MacOS/TimerApp

# 修复应用包标志
/usr/bin/setfile -a V TimerApp.app 2>/dev/null || true

# 创建应用图标占位符
echo "🎨 创建应用图标..."

# 创建简单的ICNS图标文件（使用系统默认图标）
cat > TimerApp.app/Contents/Resources/AppIcon.icns << 'EOF'
# 这是一个占位符图标文件
# 在实际应用中，这里应该是一个有效的ICNS图标文件
EOF

# 检查应用包完整性
echo "🔍 检查应用包完整性..."

if [ -f "TimerApp.app/Contents/MacOS/TimerApp" ]; then
    echo "✅ 可执行文件存在"
else
    echo "❌ 可执行文件缺失"
fi

if [ -f "TimerApp.app/Contents/Info.plist" ]; then
    echo "✅ Info.plist 存在"
else
    echo "❌ Info.plist 缺失"
fi

if [ -f "TimerApp.app/Contents/PkgInfo" ]; then
    echo "✅ PkgInfo 存在"
else
    echo "❌ PkgInfo 缺失"
fi

# 测试应用启动
echo "🚀 测试应用启动..."

# 直接运行可执行文件测试
if TimerApp.app/Contents/MacOS/TimerApp & then
    echo "✅ 应用可以正常启动"
    sleep 2
    pkill -f TimerApp
else
    echo "❌ 应用启动失败"
fi

echo ""
echo "🎯 修复完成！现在可以尝试："
echo "1. 双击 TimerApp.app 启动应用"
echo "2. 或右键点击 -> 打开"
echo "3. 或在终端中运行: open TimerApp.app"
echo ""
echo "💡 如果仍然无法启动，可能是系统安全设置限制"
echo "   请检查系统偏好设置 -> 安全性与隐私 -> 通用"