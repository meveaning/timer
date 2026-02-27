#!/bin/bash

echo "🧪 测试TimerApp可执行文件"
echo "========================"
echo ""

# 检查可执行文件
EXEC="TimerApp.app/Contents/MacOS/TimerApp"
if [ ! -f "$EXEC" ]; then
    echo "❌ 错误: 可执行文件不存在: $EXEC"
    exit 1
fi

echo "📦 可执行文件: $EXEC"
echo "大小: $(du -h "$EXEC" | cut -f1)"
echo ""

echo "🔍 直接运行测试（可能会失败）"
echo "--------------------------"
echo "注意: 直接运行可执行文件通常会导致错误，因为缺少GUI环境"
echo "但这有助于发现运行时问题"
echo ""

# 设置环境变量以便捕获错误
export DYLD_PRINT_LIBRARIES=1
export NSZombieEnabled=YES
export MallocStackLogging=1

echo "运行命令: $EXEC"
echo "输出如下:"
echo "--------------------------------------------------"

# 运行可执行文件，捕获输出
"$EXEC" 2>&1 | head -50

echo "--------------------------------------------------"
echo ""

echo "📋 检查退出状态: $?"
echo ""

echo "🔧 使用open命令测试"
echo "-----------------"
echo "这应该能正常工作:"
echo "open TimerApp.app"
echo ""

# 使用open命令，但捕获可能的错误
open TimerApp.app 2>&1 &
OPEN_PID=$!
sleep 2

echo "🔍 检查进程状态"
echo "-------------"
ps aux | grep -i timerapp | grep -v grep | grep -v test-executable || echo "未找到TimerApp进程"
echo ""

echo "📝 检查系统日志"
echo "-------------"
echo "最近与TimerApp相关的日志:"
log show --predicate 'process contains "TimerApp"' --last 1m 2>/dev/null | head -10 || echo "无法访问系统日志"
echo ""

echo "💡 建议:"
echo "1. 如果直接运行显示错误，请分享错误信息"
echo "2. 检查Console.app中的系统日志"
echo "3. 尝试重新编译应用"