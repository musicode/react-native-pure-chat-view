
import UIKit

public class EmotionSet {
    
    // 底部栏图标
    public var localImage: UIImage
    
    // 该套表情的所有表情
    public var emotionPageList: [EmotionPage]
    
    // 是否需要导航指示器
    public var hasIndicator: Bool
    
    public init(localImage: UIImage, emotionPageList: [EmotionPage], hasIndicator: Bool) {
        self.localImage = localImage
        self.emotionPageList = emotionPageList
        self.hasIndicator = hasIndicator
    }

    public static func build(localImage: UIImage, emotionList: [Emotion], columns: Int, rows: Int, width: Int, height: Int, hasDeleteButton: Bool, hasIndicator: Bool) -> EmotionSet {
        
        var emotionPageList = [EmotionPage]()
        
        var pageSize = columns * rows
        if hasDeleteButton {
            pageSize -= 1
        }
        
        let count = emotionList.count
        let totalPage = Int(ceil(Double(count) / Double(pageSize)))
        
        var start = 0
        
        for _ in 1...totalPage {
            var end = start + pageSize
            if end > count {
                end = count
            }
            
            // 该页的表情列表
            var subList = [Emotion]()
            
            for i in start..<end {
                subList.append(emotionList[ i ])
            }
            
            // 如果表情数量没满，需补齐数量
            let blankCount = columns * rows - subList.count
            if blankCount > 0 {
                for _ in 1...blankCount {
                    subList.append(Emotion())
                }
            }

            emotionPageList.append(
                EmotionPage(
                    emotionList: subList,
                    columns: columns,
                    rows: rows,
                    width: width,
                    height: height,
                    hasDeleteButton: hasDeleteButton
                )
            )
            
            start = end
            
        }
        
        return EmotionSet(
            localImage: localImage,
            emotionPageList: emotionPageList,
            hasIndicator: hasIndicator
        )
        
    }
    
}

