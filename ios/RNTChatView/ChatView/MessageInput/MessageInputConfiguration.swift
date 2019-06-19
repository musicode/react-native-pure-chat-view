
import UIKit
import AVFoundation

public class MessageInputConfiguration {
    
    // 输入栏的边框大小
    public var inputBarBorderWidth = 1 / UIScreen.main.scale
    
    // 输入栏的边框颜色
    public var inputBarBorderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    // 输入栏的背景颜色
    public var inputBarBackgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    
    // 输入栏的水平内边距
    public var inputBarPaddingHorizontal: CGFloat = 10

    // 输入栏的垂直内边距
    public var inputBarPaddingVertical: CGFloat = 8
    
    // 输入栏每一项的间距
    public var inputBarItemSpacing: CGFloat = 8
    
    // 圆形按钮的半径
    public var circleButtonRadius: CGFloat = 15
    
    // 圆形按钮的边框大小
    public var circleButtonBorderWidth = 1 / UIScreen.main.scale
    
    // 圆形按钮的边框颜色
    public var circleButtonBorderColor = UIColor(red: 0.50, green: 0.51, blue: 0.54, alpha: 1)
    
    // 圆形按钮的默认背景色
    public var circleButtonBackgroundColorNormal = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    
    // 圆形按钮按下时的背景色
    public var circleButtonBackgroundColorPressed = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    // 圆形按钮底部与输入框底部的距离
    public var circleButtonMarginBottom: CGFloat = 4
    
    // 输入框中表情图片和文本的高度比例
    public var emotionTextHeightRatio: CGFloat = 1.1
    
    // 发送按钮的文本
    public var sendButtonTitle = "发送"

    // 发送按钮的宽度
    public var sendButtonWidth: CGFloat = 44
    
    // 发送按钮的高度
    public var sendButtonHeight: CGFloat = 34
    
    // 发送按钮与输入框底部的距离
    public var sendButtonMarginBottom: CGFloat = 2
    
    // 发送按钮的文本字体
    public var sendButtonTextFont = UIFont.systemFont(ofSize: 14)
    
    // 发送按钮的文本颜色
    public var sendButtonTextColor = UIColor.white
    
    // 发送按钮的边框的大小
    public var sendButtonBorderWidth =  1 / UIScreen.main.scale
    
    // 发送按钮边框的颜色
    public var sendButtonBorderColor = UIColor(red: 0.92, green: 0.48, blue: 0, alpha: 1)
    
    // 发送按钮的圆角
    public var sendButtonBorderRadius: CGFloat = 4
    
    // 发送按钮的背景颜色
    public var sendButtonBackgroundColorNormal = UIColor(red: 1.00, green: 0.61, blue: 0.00, alpha: 1)
    public var sendButtonBackgroundColorPressed = UIColor(red: 0.99, green: 0.56, blue: 0.01, alpha: 1)
    
    // 语音按钮图片
    public var voiceButtonImage = UIImage(named: "message_input_voice")
    
    // 表情按钮图片
    public var emotionButtonImage = UIImage(named: "message_input_emotion")
    
    // 更多按钮图片
    public var moreButtonImage = UIImage(named: "message_input_more")
    
    // 内容面板高度
    public var contentPanelHeight: CGFloat = 270
    
    // 内容面板背景色
    public var contentPanelBackgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    
    // 特性面板内边距
    public var featurePanelPaddingVertical: CGFloat = 30
    
    // 特性按钮之间的间距
    public var featureButtonRowSpacing: CGFloat = 40
    public var featureButtonColumnSpacing: CGFloat = 28
    
    // 图标按钮尺寸
    public var featureButtonWidth: CGFloat = 56
    public var featureButtonHeight: CGFloat = 56
    
    // 按钮背景色
    public var featureButtonBackgroundColorNormal: UIColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
    public var featureButtonBackgroundColorPressed: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    // 图标按钮边框
    public var featureButtonBorderRadius: CGFloat = 12
    public var featureButtonBorderWidth: CGFloat = 1 / UIScreen.main.scale
    public var featureButtonBorderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    // 特性按钮标题
    public var featureButtonTitleMarginTop: CGFloat = 8
    public var featureButtonTitleTextFont = UIFont.systemFont(ofSize: 12)
    public var featureButtonTitleTextColor = UIColor(red: 120 / 255, green: 120 / 255, blue: 120 / 255, alpha: 1)
    
    // 图片按钮
    public var photoFeatureIcon = UIImage(named: "message_input_photo_feature_icon")!
    public var photoFeatureTitle = "图片"
    
    // 拍摄按钮
    public var cameraFeatureIcon = UIImage(named: "message_input_camera_feature_icon")!
    public var cameraFeatureTitle = "拍摄"
    
    // 文件按钮
    public var fileFeatureIcon = UIImage(named: "message_input_file_feature_icon")!
    public var fileFeatureTitle = "文件"
    
    // 用户按钮
    public var userFeatureIcon = UIImage(named: "message_input_user_feature_icon")!
    public var userFeatureTitle = "名片"
    
    // 视频通话
    public var movieFeatureIcon = UIImage(named: "message_input_movie_feature_icon")!
    public var movieFeatureTitle = "视频通话"
    
    // 语音通话
    public var phoneFeatureIcon = UIImage(named: "message_input_phone_feature_icon")!
    public var phoneFeatureTitle = "语音通话"
    
    // 位置按钮
    public var locationFeatureIcon = UIImage(named: "message_input_location_feature_icon")!
    public var locationFeatureTitle = "位置"
    
    // 收藏按钮
    public var favorFeatureIcon = UIImage(named: "message_input_favor_feature_icon")!
    public var favorFeatureTitle = "收藏"
    
    public var featureList = [
        FeatureType.photo, FeatureType.camera, FeatureType.file, FeatureType.user,
        FeatureType.movie, FeatureType.phone, FeatureType.location, FeatureType.favor
    ]
    
    // 录音配置
    
    // 声音质量
    public var audioQuality = AVAudioQuality.high
    
    // 码率
    public var audioBitRate = 320000
    
    // 采样率
    public var audioSampleRate = 44100.0
    
    // 视频质量
    public var videoQuality = VideoQuality.p720
    
    // 键盘显示、隐藏的动画时长
    public var keyboardAnimationDuration: TimeInterval = 0.2
    
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
