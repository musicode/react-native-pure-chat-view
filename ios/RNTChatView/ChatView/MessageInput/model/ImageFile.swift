
import Foundation
import UIKit

@objc public class ImageFile: NSObject {
    
    @objc public var path: String
    
    @objc public var width: CGFloat
    
    @objc public var height: CGFloat
    
    public init(path: String, width: CGFloat, height: CGFloat) {
        self.path = path
        self.width = width
        self.height = height
    }
    
}
