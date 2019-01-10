
import UIKit

class LinkTextView: UITextView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        guard let pos = closestPosition(to: point), let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: UITextDirection(rawValue: UITextLayoutDirection.left.rawValue)) else {
            return false
        }
        
        let startIndex = offset(from: beginningOfDocument, to: range.start)
        
        let link = attributedText.attribute(.link, at: startIndex, effectiveRange: nil)
        
        return link != nil
        
    }
    
}

