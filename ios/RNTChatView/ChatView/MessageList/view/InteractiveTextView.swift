
import UIKit

class InteractiveTextView: UITextView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        guard let pos = closestPosition(to: point), let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: UITextLayoutDirection.left.rawValue) else {
            return false
        }
        
        let startIndex = offset(from: beginningOfDocument, to: range.start)
        
        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
        
    }
    
}

