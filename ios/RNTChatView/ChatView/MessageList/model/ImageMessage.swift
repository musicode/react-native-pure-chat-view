
import Foundation

@objc public class ImageMessage: Message {
    
    @objc public var url: String
    
    @objc public var width: Int
    
    @objc public var height: Int
    
    @objc public init(id: String, user: User, status: MessageStatus, time: String, url: String, width: Int, height: Int) {
        self.url = url
        self.width = width
        self.height = height
        super.init(id: id, user: user, status: status, time: time)
    }
    
}
