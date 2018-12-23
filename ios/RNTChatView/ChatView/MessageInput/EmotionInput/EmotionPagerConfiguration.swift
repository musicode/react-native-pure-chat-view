import UIKit

open class EmotionPagerConfiguration {
    
    // 背景色
    public var backgroundColor = UIColor.clear
    
    // 删除图片
    public var deleteButtonImage = UIImage(named: "emotion_input_delete")
    
    // 表情网格容器的垂直内边距
    public var emotionGridPaddingVertical: CGFloat = 20
    
    // 表情网格容器的水平内边距
    public var emotionGridPaddingHorizontal: CGFloat = 20
    
    // 行间距
    public var emotionGridRowSpacing: CGFloat = 15
    
    // 列间距
    public var emotionGridColumnSpacing: CGFloat = 10
    
    // 表情单元格按下时的背景色
    public var emotionCellBackgroundColorPressed = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
    
    
    // 单元格文本字体
    public var emotionNameTextFont = UIFont.systemFont(ofSize: 12)
    
    // 单元格文本颜色
    public var emotionNameTextColor = UIColor(red: 120 / 255, green: 120 / 255, blue: 120 / 255, alpha: 1)
    
    // 单元格文本与表情的距离
    public var emotionNameMarginTop: CGFloat = 5
    
    
    
    // 指示器与网格的距离
    public var indicatorMarginTop: CGFloat = 8
    
    // 指示器普通圆点的颜色
    public var indicatorColorNormal = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
    
    // 指示器普通圆点的半径
    public var indicatorRadiusNormal: Double = 3
    
    // 指示器当前圆点的颜色
    public var indicatorColorActive = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
    
    // 指示器当前圆点的半径
    public var indicatorRadiusActive: Double = 3.2
    
    // 工具栏的高度
    public var toolbarHeight: CGFloat = 44
    
    // 工具栏与指示器的距离
    public var toolbarMarginTop: CGFloat = 8
    
    // 工具栏顶部边框大小
    public var toolbarTopBorderWidth = 1 / UIScreen.main.scale
    
    // 工具栏顶部边框颜色
    public var toolbarTopBorderColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
    
    // 工具栏背景色
    public var toolbarBackgroundColor = UIColor.white

    // 图标单元格宽度
    public var toolbarCellWidth: CGFloat = 44
    
    // 表情单元格分割线颜色
    public var toolbarCellDividerColor = UIColor(red: 0.9, green: 0.9, blue:0.9, alpha: 1)
    
    // 表情单元格分割线宽度
    public var toolbarCellDividerWidth = 1 / UIScreen.main.scale
    
    // 表情单元格分割线高度
    public var toolbarCellDividerOffset: CGFloat = 6
    
    // 表情单元格按下时的背景色
    public var toolbarCellBackgroundColorPressed = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    // 发送按钮的文本
    public var sendButtonTitle = "发送"
    
    // 发送按钮的文本字体
    public var sendButtonTextFont = UIFont.systemFont(ofSize: 14)
    
    // 发送按钮左边框的大小
    public var sendButtonLeftBorderWidth =  1 / UIScreen.main.scale

    
    
    
    // 发送按钮置灰时
    
    // 发送按钮的文本颜色
    public var sendButtonTextColorDisabled = UIColor(red: 150 / 255, green: 150 / 255, blue: 150 / 255, alpha: 1)
    
    // 发送按钮的背景颜色
    public var sendButtonBackgroundColorDisabled = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
    
    // 发送按钮左边框的颜色
    public var sendButtonLeftBorderColorDisabled = UIColor(red: 205 / 255, green: 205 / 255, blue: 205 / 255, alpha: 1)
    
    
    
    
    // 发送按钮可用时
    
    // 发送按钮的文本颜色
    public var sendButtonTextColorEnabled = UIColor.white
    
    // 发送按钮的背景颜色
    public var sendButtonBackgroundColorEnabledNormal = UIColor(red: 1, green: 0.61, blue: 0, alpha: 1)
    public var sendButtonBackgroundColorEnabledPressed = UIColor(red: 0.99, green: 0.56, blue: 0.01, alpha: 1)
    
    // 发送按钮左边框的颜色
    public var sendButtonLeftBorderColorEnabled = UIColor(red: 0.92, green: 0.48, blue: 0, alpha: 1)
    
    // 发送按钮的左右内间距
    public var sendButtonPaddingHorizontal: CGFloat = 14
    
    
    
    
    open func loadImage(imageView: UIImageView, url: String) {
        
    }
    
    public init() { }
    
}
