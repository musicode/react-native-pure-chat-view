
import Foundation

@objc public class TextMessage: Message {
    
    @objc public var text: String
    
    @objc public init(id: String, user: User, status: MessageStatus, time: String, text: String) {
        self.text = text
        super.init(id: id, user: user, status: status, time: time)
    }
    
}
