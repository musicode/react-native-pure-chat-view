
import UIKit

class InsetLabel: UILabel {
    
    var contentInsets: UIEdgeInsets!
    
    public override var intrinsicContentSize: CGSize {
        if text == "" {
            return CGSize(width: 0, height: 0)
        }
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInsets.left + contentInsets.right, height: size.height + contentInsets.top + contentInsets.bottom)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
    
}
