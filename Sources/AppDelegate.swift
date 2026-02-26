import Cocoa
import SwiftUI
import Combine

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    var timerModel: TimerModel!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 初始化定时器模型
        timerModel = TimerModel()
        
        // 创建状态栏项目
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem.button {
            button.title = "⏰"
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        // 创建弹出窗口
        let contentView = ContentView(timerModel: timerModel)
        popover = NSPopover()
        popover.contentSize = NSSize(width: 350, height: 450)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // 设置定时器更新状态栏标题
        setupStatusBarUpdates()
        
        // 应用启动时不显示主窗口，只在菜单栏显示
        NSApp.setActivationPolicy(.accessory)
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