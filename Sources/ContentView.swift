import SwiftUI

struct ContentView: View {
    @ObservedObject var timerModel: TimerModel
    @State private var customMinutes: String = "30"
    @State private var showCustomInput = false
    
    var body: some View {
        VStack(spacing: 30) {
            // 标题
            Text("定时器")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // 时间显示区域
            VStack(spacing: 15) {
                // 大字体时间显示
                Text(timerModel.formattedTime())
                    .font(.system(size: 48, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(timerModel.isRunning ? .blue : .primary)
                    .padding(.vertical, 10)
                
                // 进度条
                ProgressView(value: timerModel.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 6)
                    .padding(.horizontal, 40)
            }
            .padding(.vertical, 20)
            
            // 预设时间按钮
            VStack(spacing: 12) {
                Text("快速设置")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    ForEach([15, 30, 45, 60], id: \.self) { minutes in
                        PresetTimeButton(
                            minutes: minutes,
                            isSelected: timerModel.totalTime == TimeInterval(minutes * 60),
                            action: { timerModel.setTime(TimeInterval(minutes * 60)) }
                        )
                    }
                }
                
                // 自定义时间输入
                HStack {
                    Button(action: {
                        showCustomInput.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("自定义")
                        }
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                    
                    if showCustomInput {
                        HStack {
                            TextField("分钟", text: $customMinutes)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                                .onSubmit {
                                    if let minutes = Int(customMinutes), minutes > 0 {
                                        timerModel.setTime(TimeInterval(minutes * 60))
                                    }
                                }
                            
                            Text("分钟")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 8)
            }
            
            // 音效设置
            VStack(spacing: 12) {
                Text("提醒音效")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    Button(action: timerModel.selectSoundFile) {
                        HStack {
                            Image(systemName: "music.note")
                            Text("选择音效")
                        }
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                    
                    if timerModel.selectedSoundURL != nil {
                        Button(action: timerModel.resetSoundSelection) {
                            HStack {
                                Image(systemName: "xmark.circle")
                                Text("重置")
                            }
                            .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                if let soundURL = timerModel.selectedSoundURL {
                    Text("已选择: \(soundURL.lastPathComponent)")
                        .font(.caption)
                        .foregroundColor(.green)
                        .lineLimit(1)
                        .truncationMode(.middle)
                } else {
                    Text("使用默认音效")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            // 控制按钮
            HStack(spacing: 20) {
                if timerModel.isRunning && !timerModel.isPaused {
                    // 运行中状态
                    Button(action: timerModel.pauseTimer) {
                        ControlButton(
                            title: "暂停",
                            icon: "pause.fill",
                            color: .orange
                        )
                    }
                    .buttonStyle(.plain)
                } else if timerModel.isPaused {
                    // 暂停状态
                    Button(action: timerModel.startTimer) {
                        ControlButton(
                            title: "继续",
                            icon: "play.fill",
                            color: .green
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    // 未开始状态
                    Button(action: timerModel.startTimer) {
                        ControlButton(
                            title: "开始",
                            icon: "play.fill",
                            color: .green
                        )
                    }
                    .buttonStyle(.plain)
                }
                
                Button(action: timerModel.resetTimer) {
                    ControlButton(
                        title: "重置",
                        icon: "arrow.clockwise",
                        color: .red
                    )
                }
                .buttonStyle(.plain)
                .disabled(!timerModel.isRunning && timerModel.timeRemaining == timerModel.totalTime)
            }
            .padding(.bottom, 30)
        }
        .padding(30)
        .frame(minWidth: 350, minHeight: 450)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct PresetTimeButton: View {
    let minutes: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(minutes)分钟")
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

struct ControlButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(color)
        .cornerRadius(10)
        .shadow(color: color.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(timerModel: TimerModel())
    }
}