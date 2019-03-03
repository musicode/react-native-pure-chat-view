
import Foundation

@objc public class PostMessage: Message {
    
    @objc public var thumbnail: String
    
    @objc public var title: String
    
    @objc public var desc: String
    
    @objc public var label: String
    
    @objc public var link: String
    
    @objc public init(id: String, user: User, status: MessageStatus, time: String, canCopy: Bool, canShare: Bool, canRecall: Bool, canDelete: Bool, thumbnail: String, title: String, desc: String, label: String, link: String) {
        self.thumbnail = thumbnail
        self.title = title
        self.desc = desc
        self.label = label
        self.link = link
        super.init(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete)
    }
    
}
