import Foundation
import AVFoundation
import UserNotifications
import AudioToolbox

class TimerModel: ObservableObject {
    @Published var timeRemaining: TimeInterval = 1800 // 默认30分钟
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var totalTime: TimeInterval = 1800
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    
    // 预设时间选项（秒）
    let presetTimes: [TimeInterval] = [
        900,    // 15分钟
        1800,   // 30分钟
        2700,   // 45分钟
        3600    // 1小时
    ]
    
    func startTimer() {
        if !isRunning {
            isRunning = true
            isPaused = false
            startCountdown()
        } else if isPaused {
            isPaused = false
            startCountdown()
        }
    }
    
    func pauseTimer() {
        isPaused = true
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
        timeRemaining = totalTime
    }
    
    func setTime(_ seconds: TimeInterval) {
        resetTimer()
        totalTime = seconds
        timeRemaining = seconds
    }
    
    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timerFinished()
            }
        }
    }
    
    private func timerFinished() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
        
        // 发送通知
        sendNotification()
        
        // 播放声音
        playAlertSound()
    }
    
    private func sendNotification() {
        // 请求通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "定时器提醒"
                    content.body = "定时时间已到！"
                    content.sound = UNNotificationSound.default
                    
                    let request = UNNotificationRequest(identifier: "timerNotification", content: content, trigger: nil)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("通知发送失败: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    private func playAlertSound() {
        // 使用系统默认提示音
        AudioServicesPlaySystemSound(1005) // 系统提示音
    }
    
    // 格式化时间显示
    func formattedTime() -> String {
        let hours = Int(timeRemaining) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    // 进度百分比
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return 1.0 - (timeRemaining / totalTime)
    }
}