#!/bin/bash

# 创建Mac应用包脚本

echo "🚀 开始创建TimerApp应用包..."

# 清理之前的构建
rm -rf TimerApp.app
rm -rf build

# 创建应用包目录结构
mkdir -p TimerApp.app/Contents/MacOS
mkdir -p TimerApp.app/Contents/Resources

# 编译应用
echo "📦 编译应用..."
swift build --configuration release

# 复制可执行文件
cp .build/release/TimerApp TimerApp.app/Contents/MacOS/

# 复制Info.plist
cp Info.plist TimerApp.app/Contents/

# 创建简单的应用图标（使用系统默认图标）
echo "🎨 配置应用信息..."

# 创建PkgInfo文件
echo "APPL????" > TimerApp.app/Contents/PkgInfo

# 设置文件权限
chmod +x TimerApp.app/Contents/MacOS/TimerApp

# 创建应用包压缩文件
echo "📦 创建分发包..."
dmg_name="TimerApp-v1.0.dmg"

# 创建临时目录用于DMG
mkdir -p dist_temp
cp -r TimerApp.app dist_temp/

# 使用hdiutil创建DMG文件
hdiutil create -volname "TimerApp" -srcfolder dist_temp -ov -format UDZO "$dmg_name"

# 清理临时文件
rm -rf dist_temp

echo "✅ 应用包创建完成！"
echo "📁 生成的文件："
echo "   - TimerApp.app (可以直接双击运行)"
echo "   - $dmg_name (分发安装包)"
echo ""
echo "🎯 使用方法："
echo "1. 双击 TimerApp.app 直接运行"
echo "2. 或将 TimerApp.app 拖到 Applications 文件夹安装"
echo "3. 或使用 $dmg_name 进行分发安装"