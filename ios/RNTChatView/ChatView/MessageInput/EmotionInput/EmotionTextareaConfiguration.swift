import UIKit

// 配置
open class EmotionTextareaConfiguration {
    
    // 输入框背景色
    public var backgroundColor = UIColor.white
    
    // 输入框边框大小
    public var borderWidth = 1 / UIScreen.main.scale
    
    // 输入框边框颜色
    public var borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
    
    // 输入框边框圆角大小
    public var borderRadius: CGFloat = 4
    
    // 选区颜色
    public var tintColor = UIColor(red: 1, green: 0.48, blue: 0.03, alpha: 1)
    
    // 输入框文本字体
    public var textFont = UIFont.systemFont(ofSize: 15)
    
    // 输入框文本颜色
    public var textColor = UIColor(red: 60 / 255, green: 60 / 255, blue: 60 / 255, alpha: 1)
    
    // 表情图片与文本的高度比例
    public var emotionTextHeightRatio: CGFloat = 1
    
    // 输入框的垂直内间距
    public var paddingVertical: CGFloat = 10
    
    // 输入框的水平内间距
    public var paddingHorizontal: CGFloat = 8
    
    // 输入框自动增高的最大行数
    public var maxLines: CGFloat = 5
    
    public init() { }
    
}
