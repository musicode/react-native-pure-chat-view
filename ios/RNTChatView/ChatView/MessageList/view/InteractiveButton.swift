
import UIKit

class InteractiveButton: UIButton {
    
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
    
}

