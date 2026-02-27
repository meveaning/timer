#!/bin/bash

echo "🎯 直接测试TimerApp可执行文件"
echo "============================="
echo ""

EXEC="TimerApp.app/Contents/MacOS/TimerApp"

if [ ! -f "$EXEC" ]; then
    echo "❌ 错误: 可执行文件不存在: $EXEC"
    exit 1
fi

echo "📦 可执行文件: $EXEC"
echo "大小: $(du -h "$EXEC" | cut -f1)"
echo "权限: $(ls -l "$EXEC")"
echo ""

echo "🔧 设置环境变量以捕获调试输出..."
export NSUnbufferedIO=YES
export DYLD_PRINT_APIS=1
export OBJC_DEBUG_MISSING_POOLS=YES

echo ""
echo "🚀 尝试直接运行应用（3秒超时）..."
echo "注意: GUI应用直接运行通常会失败，但我们可以捕获初始输出"
echo ""

# 创建输出文件
OUTFILE="/tmp/timerapp-direct-$$.log"
echo "📝 输出文件: $OUTFILE"

# 尝试运行应用，3秒后终止
(
    echo "=== 开始运行 TimerApp ==="
    echo "时间: $(date)"
    echo "环境: NSUnbufferedIO=YES"
    echo ""

    # 运行应用，捕获所有输出
    "$EXEC" 2>&1

    echo ""
    echo "=== 应用退出，退出码: $? ==="
) > "$OUTFILE" 2>&1 &

APP_PID=$!

# 等待3秒
echo "⏳ 等待3秒..."
sleep 3

# 检查进程是否仍在运行
if kill -0 $APP_PID 2>/dev/null; then
    echo "🔄 应用仍在运行，终止进程..."
    kill -9 $APP_PID 2>/dev/null
    echo "✅ 进程已终止"
else
    echo "✅ 应用已自行退出"
fi

echo ""
echo "📄 捕获的输出（前50行）:"
echo "--------------------------------------------------"
head -50 "$OUTFILE"
echo "--------------------------------------------------"

echo ""
echo "🔍 分析输出："
echo "1. 寻找打印的调试信息（'🚀', '✅', '❌'等）"
echo "2. 检查是否有崩溃栈轨迹"
echo "3. 查看是否有权限错误"

echo ""
echo "🧪 现在尝试正常启动（使用open命令）..."
pkill -f "TimerApp" 2>/dev/null
sleep 1

echo "🔄 使用open命令启动..."
open TimerApp.app &
sleep 2

echo ""
echo "📊 进程状态："
ps aux | grep -i "TimerApp" | grep -v grep | grep -v direct-test || echo "未找到TimerApp进程"

echo ""
echo "🎯 手动检查："
echo "请检查："
echo "1. Dock中是否有TimerApp图标？"
echo "2. 菜单栏是否有 ⏰ 图标？"
echo "3. 是否有窗口弹出？"
echo "4. 点击Dock图标（如果有）是否显示窗口？"

echo ""
echo "💡 如果Dock中有图标但没有窗口："
echo "尝试点击Dock图标"
echo "或使用Cmd+Tab切换到TimerApp"

echo ""
echo "🔧 退出应用的方法："
echo "1. 如果有Dock图标: 右键点击 → 退出"
echo "2. 如果只有菜单栏图标: 右键点击 ⏰ 图标 → 退出"
echo "3. 强制退出: pkill -f TimerApp"

echo ""
echo "✅ 测试完成"
echo "请分享："
echo "1. 直接运行的输出中是否有调试信息？"
echo "2. Dock中是否有图标？"
echo "3. 菜单栏是否有图标？"
echo "4. 是否有窗口显示？"