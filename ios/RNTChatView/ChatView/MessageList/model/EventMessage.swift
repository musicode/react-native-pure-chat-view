
import Foundation

@objc public class EventMessage: Message {
    
    @objc public var event: String
    
    @objc public init(id: String, user: User, status: MessageStatus, time: String, event: String) {
        self.event = event
        super.init(id: id, user: user, status: status, time: time, canShare: false, canRecall: false, canDelete: false)
    }
    
}
