
import UIKit

class InteractiveImageView: UIImageView {
    
    var cell: MessageCell!
    var actions: [Selector]!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return actions.contains(action)
    }
    
    @objc func onShare(_ controller: UIMenuController) {
        cell.delegate.messageListDidClickShare(message: cell.message)
    }
    
    @objc func onRecall(_ controller: UIMenuController) {
        cell.delegate.messageListDidClickRecall(message: cell.message)
    }
    
    @objc func onDelete(_ controller: UIMenuController) {
        cell.delegate.messageListDidClickDelete(message: cell.message)
    }
    
}

