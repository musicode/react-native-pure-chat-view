
import Foundation

@objc public class AudioMessage: Message {
    
    @objc public var url: String
    
    @objc public var duration: Int
    
    @objc public init(id: String, user: User, status: MessageStatus, time: String, canCopy: Bool, canShare: Bool, canRecall: Bool, canDelete: Bool, url: String, duration: Int) {
        self.url = url
        self.duration = duration
        super.init(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete)
    }
    
}
