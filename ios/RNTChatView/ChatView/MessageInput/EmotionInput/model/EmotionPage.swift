
public class EmotionPage {
    
    // 每页的图标列表
    public var emotionList: [Emotion]
    
    // 每页有多少列
    public var columns: Int
    
    // 每页有多少行
    public var rows: Int
    
    // 显示宽度
    public var width: Int
    
    // 显示高度
    public var height: Int
    
    // 是否显示删除按钮
    public var hasDeleteButton: Bool
    
    public init(emotionList: [Emotion], columns: Int, rows: Int, width: Int, height: Int, hasDeleteButton: Bool) {
        self.emotionList = emotionList
        self.columns = columns
        self.rows = rows
        self.width = width
        self.height = height
        self.hasDeleteButton = hasDeleteButton
    }
    
    public convenience init() {
        self.init(emotionList: [Emotion](), columns: 0, rows: 0, width: 0, height: 0, hasDeleteButton: false)
    }
    
}

