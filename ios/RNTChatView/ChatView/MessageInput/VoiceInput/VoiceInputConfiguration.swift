
import UIKit
import AVFoundation

public class VoiceInputConfiguration {
    
    // 背景色
    public var backgroundColor = UIColor.clear
    
    // 录制按钮半径
    public var recordButtonRadius: CGFloat = 40
    
    // 录制按钮图标
    public var recordButtonImage = UIImage(named: "voice_input_mic")
    
    // 录制按钮边框大小
    public var recordButtonBorderWidth: CGFloat = 0
    
    // 录制按钮边框颜色
    public var recordButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    
    // 录制按钮默认背景色
    public var recordButtonBackgroundColorNormal = UIColor(red: 1.00, green: 0.61, blue: 0.00, alpha: 1)
    
    // 录制按钮按下时的背景色
    public var recordButtonBackgroundColorPressed = UIColor(red: 0.99, green: 0.56, blue: 0.01, alpha: 1)
    
    // 试听按钮半径
    public var previewButtonRadius: CGFloat = 25
    
    // 试听按钮图标
    public var previewButtonImage = UIImage(named: "voice_input_preview")
    
    // 试听按钮边框大小
    public var previewButtonBorderWidth = 1 / UIScreen.main.scale
    
    // 试听按钮边框颜色
    public var previewButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    
    // 试听按钮默认背景色
    public var previewButtonBackgroundColorNormal = UIColor.white
    
    // 试听按钮悬浮时的背景色
    public var previewButtonBackgroundColorHover = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    
    // 试听按钮与录制按钮的距离
    public var previewButtonMarginRight: CGFloat = 35
    
    // 删除按钮半径
    public var deleteButtonRadius: CGFloat = 25
    
    // 删除按钮图标
    public var deleteButtonImage = UIImage(named: "voice_input_delete")
    
    // 删除按钮边框大小
    public var deleteButtonBorderWidth = 1 / UIScreen.main.scale
    
    // 删除按钮边框颜色
    public var deleteButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    
    // 删除按钮默认背景色
    public var deleteButtonBackgroundColorNormal = UIColor.white
    
    // 删除按钮悬浮时的背景色
    public var deleteButtonBackgroundColorHover = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    
    // 删除按钮与录制按钮的距离
    public var deleteButtonMarginLeft: CGFloat = 25
    
    // 录音引导文本颜色
    public var guideLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    
    // 录音引导文本字体
    public var guideLabelTextFont = UIFont.systemFont(ofSize: 15)
    
    // 录音引导文本与录音按钮的距离
    public var guideLabelMarginBottom: CGFloat = 25
    
    // 录音引导文本 - 未按下
    public var guideLabelTitleNormal = "按住说话"
    
    // 录音引导文本 - 按下并移动到试听按钮上方
    public var guideLabelTitlePreview = "松手试听"
    
    // 录音引导文本 - 按下并移动到删除按钮上方
    public var guideLabelTitleDelete = "松手取消发送"
    
    // 正在录音的时长文本颜色
    public var durationLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    
    // 正在录音的时长文本颜色
    public var durationLabelTextFont = UIFont.systemFont(ofSize: 15)
    
    // 正在录音的时长文本与录音按钮的距离
    public var durationLabelMarginBottom: CGFloat = 25
    
    // 试听的进度文本颜色
    public var progressLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    
    // 试听的进度文本字体
    public var progressLabelTextFont = UIFont.systemFont(ofSize: 15)
    
    // 试听的进度文本与播放按钮的距离
    public var progressLabelMarginBottom: CGFloat = 25
    
    // 播放按钮半径
    public var playButtonCenterRadius: CGFloat = 37
    
    // 播放按钮中间的默认颜色
    public var playButtonCenterColorNormal = UIColor.white
    
    // 播放按钮中间的按下时的颜色
    public var playButtonCenterColorPressed = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
    
    // 播放按钮圆环的大小
    public var playButtonRingWidth: CGFloat = 3
    
    // 播放按钮圆环的颜色
    public var playButtonRingColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    
    // 播放按钮进度条的颜色
    public var playButtonTrackColor = UIColor(red: 1.00, green: 0.61, blue: 0.00, alpha: 1.00)
    
    // 播放按钮图标
    public var playButtonImage = UIImage(named: "voice_input_play")
    
    // 停止按钮图标
    public var stopButtonImage = UIImage(named: "voice_input_stop")
    
    // 底部的取消按钮文本
    public var footerCancelButtonTitle = "取消"
    
    // 底部的确定按钮文本
    public var footerSubmitButtonTitle = "发送"
    
    // 底部按钮的 padding top
    public var footerButtonPaddingTop: CGFloat = 14
    
    // 底部按钮的 padding bottom
    public var footerButtonPaddingBottom: CGFloat = 14

    // 底部按钮的文本颜色
    public var footerButtonTextColor = UIColor(red: 90 / 255, green: 90 / 255, blue: 90 / 255, alpha: 1)
    
    // 底部按钮的文本字体
    public var footerButtonTextFont = UIFont.systemFont(ofSize: 14)
    
    // 底部按钮的边框大小
    public var footerButtonBorderWidth = 1 / UIScreen.main.scale
    
    // 底部按钮的边框颜色
    public var footerButtonBorderColor = UIColor(red: 210 / 255, green: 210 / 255, blue: 210 / 255, alpha: 1)
    
    // 底部按钮的默认背景色
    public var footerButtonBackgroundColorNormal = UIColor.white
    
    // 底部按钮按下时的背景色
    public var footerButtonBackgroundColorPressed = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
    
    // 保存录音文件的目录
    public var fileDir = NSTemporaryDirectory()
    
    // 文件扩展名
    public var fileExtname = ".m4a"
    
    // 音频格式
    public var audioFormat = kAudioFormatMPEG4AAC
    
    // 双声道还是单声道
    public var audioNumberOfChannels = 2
    
    // 声音质量
    public var audioQuality = AVAudioQuality.high
    
    // 码率
    public var audioBitRate = 320000
    
    // 采样率
    public var audioSampleRate = 44100.0

    // 支持的最短录音时长
    public var audioMinDuration: Int = 1000
    
    // 支持的最长录音时长
    public var audioMaxDuration: Int = 60000

    public var setAudioCategory: (AVAudioSession.Category) -> Void = {
        if #available(iOS 10.0, *) {
            try! AVAudioSession.sharedInstance().setCategory($0, mode: .default, options: [])
        }
        else {
            // 妈的，swift 不支持调用 setCategory 了，外部自己实现吧
        }
    }
    
    public init() { }
    
}
