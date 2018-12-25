
import Foundation

@objc public class User: NSObject {
    
    @objc public var id: String
    
    @objc public var name: String
    
    @objc public var avatar: String
    
    @objc public init(id: String, name: String, avatar: String) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
    
}
