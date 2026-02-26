import Foundation
import AVFoundation
import Combine
import Cocoa

class TimerModel: ObservableObject {
    @Published var timeRemaining: TimeInterval = 1800 // 默认30分钟
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var totalTime: TimeInterval = 1800
    @Published var selectedSoundURL: URL? = nil
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    
    // 预设时间选项（秒）
    let presetTimes: [TimeInterval] = [
        900,    // 15分钟
        1800,   // 30分钟
        2700,   // 45分钟
        3600    // 1小时
    ]
    
    // 默认音效文件（内置）
    private let defaultSoundURL: URL? = {
        if let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
            return soundURL
        }
        return nil
    }()
    
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
        
        // 播放自定义音乐
        playAlertSound()
    }
    
    func playAlertSound() {
        // 停止当前播放的声音
        audioPlayer?.stop()
        
        // 确定要播放的音效文件
        let soundURL = selectedSoundURL ?? defaultSoundURL
        
        guard let url = soundURL else {
            // 如果没有自定义音效，使用系统提示音
            NSSound.beep()
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.8
            audioPlayer?.numberOfLoops = 0 // 播放一次
            audioPlayer?.play()
        } catch {
            print("播放音效失败: \(error)")
            // 回退到系统提示音
            NSSound.beep()
        }
    }
    
    func selectSoundFile() {
        let openPanel = NSOpenPanel()
        openPanel.title = "选择提醒音效"
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["mp3", "wav", "aiff", "m4a"]
        
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                DispatchQueue.main.async {
                    self.selectedSoundURL = url
                }
            }
        }
    }
    
    func resetSoundSelection() {
        selectedSoundURL = nil
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