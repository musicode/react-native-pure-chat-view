
import Foundation

@objc public class Message: NSObject {
    
    @objc public var id: String
    
    @objc public var user: User
    
    @objc public var status: MessageStatus
    
    @objc public var time: String
    
    // 是否可以复制
    @objc public var canCopy: Bool
    
    // 是否可以转发
    @objc public var canShare: Bool
    
    // 是否可以撤回
    @objc public var canRecall: Bool
    
    // 是否可以删除
    @objc public var canDelete: Bool
    
    public init(id: String, user: User, status: MessageStatus, time: String, canCopy: Bool, canShare: Bool, canRecall: Bool, canDelete: Bool) {
        self.id = id
        self.user = user
        self.status = status
        self.time = time
        self.canCopy = canCopy
        self.canShare = canShare
        self.canRecall = canRecall
        self.canDelete = canDelete
    }
    
}
