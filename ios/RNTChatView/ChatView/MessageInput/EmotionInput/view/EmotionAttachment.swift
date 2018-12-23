
import UIKit

class EmotionAttachment: NSTextAttachment {
    
    var emotion: Emotion!
    
    convenience init(emotion: Emotion) {
        self.init()
        self.emotion = emotion
    }
    
}
