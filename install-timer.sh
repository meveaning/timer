#!/bin/bash

echo "⏰ TimerApp 安装脚本"
echo "===================="

# 检查是否在沙盒环境中
if [[ "$TRAE_SANDBOX" == "1" ]]; then
    echo "⚠️  检测到在沙盒环境中运行"
    echo "📦 正在创建可直接下载的应用包..."
    
    # 创建简单的应用包
    mkdir -p TimerApp-Portable
    cp -r TimerApp.app TimerApp-Portable/
    
    # 创建说明文档
    cat > TimerApp-Portable/README.txt << 'EOF'
TimerApp 便携版使用说明
=======================

这是一个可以直接运行的Mac定时器应用，无需安装Xcode或其他开发工具。

使用方法：
1. 双击 TimerApp.app 文件即可运行
2. 或者右键点击 -> 打开

功能特性：
- 自定义定时时长（15分钟、30分钟、45分钟、1小时）
- 启动/暂停/重置控制
- 弹窗和声音提醒
- 简洁美观的界面

如果无法直接运行，请尝试：
1. 右键点击 TimerApp.app -> 显示包内容
2. 进入 Contents/MacOS/ 目录
3. 双击 TimerApp 文件运行

EOF
    
    # 创建压缩包
    tar -czf TimerApp-Portable.tar.gz TimerApp-Portable/
    
    echo "✅ 便携版应用包已创建：TimerApp-Portable.tar.gz"
    echo "📁 文件大小：$(du -h TimerApp-Portable.tar.gz | cut -f1)"
    echo ""
    echo "🎯 下载后使用方法："
    echo "1. 解压 TimerApp-Portable.tar.gz"
    echo "2. 双击 TimerApp-Portable/TimerApp.app"
    echo "3. 如果系统提示，选择'打开'以运行应用"
    
else
    # 正常安装流程
    echo "📦 正在安装TimerApp..."
    
    # 检查应用包是否存在
    if [ ! -d "TimerApp.app" ]; then
        echo "❌ TimerApp.app 不存在，请先运行 create-app-bundle.sh"
        exit 1
    fi
    
    # 复制到Applications文件夹
    echo "正在复制应用到 Applications 文件夹..."
    cp -r TimerApp.app /Applications/
    
    if [ $? -eq 0 ]; then
        echo "✅ TimerApp 已成功安装到 Applications 文件夹"
        echo ""
        echo "🎯 启动方法："
        echo "1. 打开 Finder"
        echo "2. 进入 Applications 文件夹"
        echo "3. 双击 TimerApp 图标"
        echo ""
        echo "或者通过 Spotlight 搜索 'TimerApp' 启动"
    else
        echo "❌ 安装失败，可能需要管理员权限"
        echo "请尝试：sudo cp -r TimerApp.app /Applications/"
    fi
fi