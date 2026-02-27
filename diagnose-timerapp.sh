#!/bin/bash

echo "🔍 TimerApp 诊断工具"
echo "====================="
echo ""

# 检查应用包是否存在
if [ ! -d "TimerApp.app" ]; then
    echo "❌ 错误: TimerApp.app 不存在"
    exit 1
fi

echo "📁 1. 应用包结构检查"
echo "-------------------"
echo "目录结构:"
find "TimerApp.app" -type f | sort
echo ""

echo "📄 2. 文件权限检查"
echo "-----------------"
echo "应用包权限:"
ls -ld "TimerApp.app"
echo ""
echo "可执行文件权限:"
ls -l "TimerApp.app/Contents/MacOS/TimerApp"
echo ""
echo "资源文件:"
ls -l "TimerApp.app/Contents/Resources/"
echo ""

echo "🖼️ 3. 图标文件检查"
echo "-----------------"
if [ -f "TimerApp.app/Contents/Resources/AppIcon.icns" ]; then
    echo "✅ 图标文件存在"
    echo "图标类型: $(file "TimerApp.app/Contents/Resources/AppIcon.icns")"
    echo "图标大小: $(du -h "TimerApp.app/Contents/Resources/AppIcon.icns" | cut -f1)"
else
    echo "❌ 图标文件不存在"
fi
echo ""

echo "⚙️ 4. Info.plist 检查"
echo "-------------------"
if [ -f "TimerApp.app/Contents/Info.plist" ]; then
    echo "✅ Info.plist 存在"
    echo "关键配置:"
    plutil -p "TimerApp.app/Contents/Info.plist" | grep -E "(CFBundle|LSMinimumSystemVersion|LSUIElement|NSPrincipalClass)" || true
else
    echo "❌ Info.plist 不存在"
fi
echo ""

echo "🔧 5. 可执行文件检查"
echo "-------------------"
echo "文件类型:"
file "TimerApp.app/Contents/MacOS/TimerApp"
echo ""
echo "架构信息:"
lipo -info "TimerApp.app/Contents/MacOS/TimerApp" 2>/dev/null || echo "无法获取架构信息"
echo ""
echo "代码签名:"
codesign -dvvv "TimerApp.app/Contents/MacOS/TimerApp" 2>&1 | head -10
echo ""

echo "🔗 6. 依赖库检查"
echo "---------------"
echo "主要依赖:"
otool -L "TimerApp.app/Contents/MacOS/TimerApp" | head -15
echo ""

echo "🚀 7. 尝试启动应用"
echo "----------------"
echo "注意: 应用将在后台启动，请查看菜单栏是否有 ⏰ 图标"
echo ""
echo "启动命令: open TimerApp.app"
echo ""

# 清除扩展属性
echo "🧹 清除扩展属性..."
xattr -cr "TimerApp.app" 2>/dev/null || true

# 设置正确权限
echo "🔒 设置权限..."
chmod 755 "TimerApp.app/Contents/MacOS/TimerApp"
chmod 755 "TimerApp.app"

# 尝试启动
echo "🚀 正在启动应用..."
open "TimerApp.app" &
PID=$!

echo "⏳ 等待应用启动..."
sleep 3

echo ""
echo "📊 8. 应用进程检查"
echo "----------------"
echo "查找TimerApp进程:"
ps aux | grep -i timerapp | grep -v grep || echo "未找到TimerApp进程"

echo ""
echo "🎯 9. 验证应用状态"
echo "-----------------"
echo "请回答以下问题:"
echo "1. 菜单栏右上角是否有 ⏰ 图标? (是/否)"
echo "2. 点击 ⏰ 图标是否能打开控制界面? (是/否/无图标)"
echo "3. 控制台是否有错误信息? (如果有，请分享)"
echo ""

echo "🔧 10. 故障排除建议"
echo "------------------"
echo "如果应用没有启动，请尝试:"
echo "1. 右键点击 TimerApp.app → 选择'打开'"
echo "2. 运行: sudo xattr -cr TimerApp.app"
echo "3. 检查系统日志: Console.app → 搜索'TimerApp'"
echo "4. 尝试重新构建: swift build -c release"
echo ""

echo "✅ 诊断完成"
echo "请分享以上信息，特别是第8和第9部分的结果"