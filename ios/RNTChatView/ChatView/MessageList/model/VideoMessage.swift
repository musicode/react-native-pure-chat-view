
import Foundation

@objc public class VideoMessage: Message {
    
    @objc public var url: String
    
    @objc public var duration: Int
    
    @objc public var thumbnail: String
    
    @objc public var width: Int
    
    @objc public var height: Int
    
    @objc public init(id: String, user: User, status: MessageStatus, time: String, canCopy: Bool, canShare: Bool, canRecall: Bool, canDelete: Bool, url: String, duration: Int, thumbnail: String, width: Int, height: Int) {
        self.url = url
        self.duration = duration
        self.thumbnail = thumbnail
        self.width = width
        self.height = height
        super.init(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete)
    }
    
}
