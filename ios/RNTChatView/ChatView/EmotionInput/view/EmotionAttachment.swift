
import UIKit

class EmotionAttachment: NSTextAttachment {
    
    var emotion: Emotion!
    
    convenience init(_ emotion: Emotion) {
        self.init()
        self.emotion = emotion
    }
    
}
