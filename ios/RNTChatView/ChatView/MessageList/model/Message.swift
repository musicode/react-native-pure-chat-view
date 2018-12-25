
import Foundation

@objc public class Message: NSObject {
    
    @objc public var id: String
    
    @objc public var user: User
    
    @objc public var status: MessageStatus
    
    @objc public var time: String
    
    public init(id: String, user: User, status: MessageStatus, time: String) {
        self.id = id
        self.user = user
        self.status = status
        self.time = time
    }
    
}
