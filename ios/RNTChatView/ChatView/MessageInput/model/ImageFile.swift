
import Foundation
import UIKit

@objc public class ImageFile: NSObject {
    
    @objc public var path: String
    
    @objc public var width: Int
    
    @objc public var height: Int
    
    public init(path: String, width: Int, height: Int) {
        self.path = path
        self.width = width
        self.height = height
    }
    
}
