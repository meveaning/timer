import Cocoa
import SwiftUI
import Combine

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var popover: NSPopover?
    var timerModel: TimerModel?
    var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog("🚀 ========== TimerApp 启动开始 ==========")

        do {
            // 初始化定时器模型
            NSLog("🔄 初始化定时器模型...")
            timerModel = TimerModel()
            NSLog("✅ 定时器模型初始化完成")

            // 尝试创建状态栏项目
            NSLog("🔄 创建状态栏项目...")
            statusBarItem = createStatusBarItem()

            if let statusBarItem = statusBarItem {
                NSLog("✅ 状态栏项目创建成功")

                // 创建弹出窗口
                NSLog("🔄 创建弹出窗口...")
                popover = createPopover()

                if let popover = popover, let button = statusBarItem.button {
                    NSLog("✅ 弹出窗口创建成功")

                    // 设置定时器更新状态栏标题
                    NSLog("🔄 设置状态栏更新...")
                    setupStatusBarUpdates()
                    NSLog("✅ 状态栏更新设置完成")

                    // 显示初始界面
                    NSLog("🔄 显示初始界面...")
                    showInitialInterface(button: button, popover: popover)
                    NSLog("✅ 初始界面显示完成")
                } else {
                    NSLog("⚠️ 弹出窗口创建失败，尝试备用窗口")
                    showBackupWindow()
                }
            } else {
                NSLog("⚠️ 状态栏项目创建失败，尝试备用窗口")
                showBackupWindow()
            }

            NSLog("✅ ========== TimerApp 启动完成 ==========")
            NSLog("💡 应用已启动！")

        } catch {
            NSLog("❌ ========== TimerApp 启动失败 ==========")
            NSLog("❌ 错误: \(error)")
            showErrorAlert(error: error)
        }
    }

    private func createStatusBarItem() -> NSStatusItem? {
        do {
            let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

            if let button = statusBarItem.button {
                button.title = "⏰"
                button.action = #selector(togglePopover(_:))
                button.target = self
                return statusBarItem
            } else {
                NSLog("⚠️ 状态栏按钮创建失败")
                return nil
            }
        } catch {
            NSLog("❌ 创建状态栏项目时出错: \(error)")
            return nil
        }
    }

    private func createPopover() -> NSPopover? {
        guard let timerModel = timerModel else {
            NSLog("❌ 无法创建弹出窗口：定时器模型未初始化")
            return nil
        }

        do {
            let contentView = ContentView(timerModel: timerModel)
            let popover = NSPopover()
            popover.contentSize = NSSize(width: 350, height: 450)
            popover.behavior = .transient
            popover.contentViewController = NSHostingController(rootView: contentView)
            return popover
        } catch {
            NSLog("❌ 创建弹出窗口时出错: \(error)")
            return nil
        }
    }

    private func showInitialInterface(button: NSStatusItem.Button, popover: NSPopover) {
        NSLog("🪟 显示初始界面...")

        // 确保应用在前台
        NSApp.setActivationPolicy(.regular)

        DispatchQueue.main.async {
            NSLog("🔄 在主线程显示弹出窗口...")
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
            NSLog("✅ 弹出窗口已显示")
            NSLog("💡 窗口位置: \(button.bounds), 显示模式: 常规")

            // 3秒后可以切换到菜单栏模式（可选）
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                NSLog("🔄 3秒后切换到菜单栏模式...")
                // 注释掉这行以保持窗口打开
                // popover.performClose(nil)
                // NSApp.setActivationPolicy(.accessory)
            }
        }
    }

    private func showBackupWindow() {
        NSLog("🔄 显示备用窗口...")

        guard let timerModel = timerModel else {
            NSLog("❌ 无法创建备用窗口：定时器模型未初始化")
            return
        }

        do {
            let contentView = ContentView(timerModel: timerModel)
            let hostingController = NSHostingController(rootView: contentView)

            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 350, height: 450),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )

            if let window = window {
                window.center()
                window.title = "定时器"
                window.contentViewController = hostingController
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                NSLog("✅ 备用窗口已创建并显示")
            } else {
                NSLog("❌ 无法创建窗口对象")
            }
        } catch {
            NSLog("❌ 创建备用窗口时出错: \(error)")
        }
    }

    private func showErrorAlert(error: Error) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "TimerApp 启动失败"
            alert.informativeText = "错误信息: \(error.localizedDescription)\n\n请检查系统权限或重新启动应用。"
            alert.alertStyle = .critical
            alert.addButton(withTitle: "确定")
            alert.runModal()
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        guard let statusBarItem = statusBarItem, let button = statusBarItem.button, let popover = popover else {
            NSLog("⚠️ 无法切换弹出窗口：组件未初始化")
            return
        }

        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private func setupStatusBarUpdates() {
        guard let timerModel = timerModel else { return }

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
        guard let button = statusBarItem?.button, let timerModel = timerModel else { return }

        if timerModel.isRunning {
            let minutes = Int(timerModel.timeRemaining) / 60
            let seconds = Int(timerModel.timeRemaining) % 60
            button.title = String(format: "%02d:%02d", minutes, seconds)
        } else {
            button.title = "⏰"
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NSLog("🔄 TimerApp 正在退出...")
        timerModel?.resetTimer()
        NSLog("✅ TimerApp 退出完成")
    }

    private var cancellables = Set<AnyCancellable>()
}