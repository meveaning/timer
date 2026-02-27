import Cocoa
import SwiftUI
import Combine

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    var timerModel: TimerModel!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("🚀 TimerApp 启动开始")

        // 初始化定时器模型
        timerModel = TimerModel()
        print("✅ 定时器模型初始化完成")

        // 创建状态栏项目
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusBarItem.button {
            button.title = "⏰"
            button.action = #selector(togglePopover(_:))
            button.target = self
            print("✅ 状态栏按钮创建完成")
        } else {
            print("❌ 无法创建状态栏按钮")
        }

        // 创建弹出窗口
        let contentView = ContentView(timerModel: timerModel)
        popover = NSPopover()
        popover.contentSize = NSSize(width: 350, height: 450)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        print("✅ 弹出窗口创建完成")

        // 设置定时器更新状态栏标题
        setupStatusBarUpdates()
        print("✅ 状态栏更新设置完成")

        // 直接显示popover，不自动隐藏
        // 让用户能看到应用已启动
        showPopoverImmediately()

        print("✅ TimerApp 启动完成")
    }

    private func showPopoverImmediately() {
        print("🪟 尝试显示弹出窗口...")

        // 设置为常规应用以便显示窗口
        NSApp.setActivationPolicy(.regular)

        if let button = statusBarItem.button {
            DispatchQueue.main.async {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                NSApp.activate(ignoringOtherApps: true)
                print("✅ 弹出窗口已显示")
                print("💡 应用已启动！点击菜单栏 ⏰ 图标可重新打开控制界面")
            }
        } else {
            print("❌ 无法显示弹出窗口：状态栏按钮不存在")
            // 如果没有按钮，至少确保应用在菜单栏
            NSApp.setActivationPolicy(.accessory)
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusBarItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    private func setupStatusBarUpdates() {
        // 监听定时器状态变化，更新菜单栏显示
        timerModel.$timeRemaining
            .receive(on: RunLoop.main)
            .sink { [weak self] timeRemaining in
                self?.updateStatusBarTitle()
            }
            .store(in: &cancellables)

        timerModel.$isRunning
            .receive(on: RunLoop.main)
            .sink { [weak self] isRunning in
                self?.updateStatusBarTitle()
            }
            .store(in: &cancellables)
    }

    private func updateStatusBarTitle() {
        guard let button = statusBarItem.button else { return }

        if timerModel.isRunning {
            let minutes = Int(timerModel.timeRemaining) / 60
            let seconds = Int(timerModel.timeRemaining) % 60
            button.title = String(format: "%02d:%02d", minutes, seconds)
        } else {
            button.title = "⏰"
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // 清理资源
        timerModel.resetTimer()
    }

    private var cancellables = Set<AnyCancellable>()
}