#!/bin/bash

# 编译应用
swift build

# 运行应用
echo "启动定时器应用..."
./.build/debug/TimerApp