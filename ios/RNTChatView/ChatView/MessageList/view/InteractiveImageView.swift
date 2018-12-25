
import UIKit

class InteractiveImageView: UIImageView {
    
    private var cell: MessageCell!
    private var actions: [Selector]!
    
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
    
    @objc func onShare(_ controller: UIMenuController) {
        cell.delegate.messageListDidClickShare(message: cell.message)
    }
    
}

