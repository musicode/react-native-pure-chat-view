
import UIKit

class InteractiveTextView: UITextView {
    
    private var cell: MessageCell!
    private var actions: [Selector]!
    
    var onTouchDown: (() -> Void)?
    var onTouchUp: (() -> Void)?
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return actions.contains(action)
    }
    
    func bind(cell: MessageCell) {
        self.cell = cell
        self.actions = cell.menuItems.map {
            return $0.action
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchDown?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchUp?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchUp?()
    }
    
    @objc func onCopy(_ controller: UIMenuController) {
        cell.delegate.messageListDidClickCopy(message: cell.message)
    }
    
}

