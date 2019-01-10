
import UIKit

class InteractiveButton: UIButton {
    
    var cell: MessageCell!
    var actions: [Selector]!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return actions.contains(action)
    }
    
    @objc func onCopy(_ controller: UIMenuController) {
        cell.delegate.messageListDidClickCopy(message: cell.message)
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

