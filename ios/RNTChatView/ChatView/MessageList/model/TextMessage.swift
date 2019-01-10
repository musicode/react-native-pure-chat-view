
import Foundation

@objc public class TextMessage: Message {
    
    @objc public var text: String
    
    @objc public init(id: String, user: User, status: MessageStatus, time: String, canShare: Bool, canRecall: Bool, canDelete: Bool, text: String) {
        self.text = text
        super.init(id: id, user: user, status: status, time: time, canShare: canShare, canRecall: canRecall, canDelete: canDelete)
    }
    
}
