
import UIKit

@objc public class Emotion: NSObject {
    
    // 表情值
    public var code: String
    
    // 显示在图片下方的文本
    public var name: String
    
    // 表情对应的本地图片
    public var localImage: UIImage?
    
    // 表情对应的网络图片
    public var remoteImage: String

    // 是否支持在输入框显示
    public var inline: Bool
    
    public init(code: String, name: String, localImage: UIImage?, remoteImage: String, inline: Bool) {
        self.code = code
        self.name = name
        self.localImage = localImage
        self.remoteImage = remoteImage
        self.inline = inline
    }
    
    public convenience init(code: String, name: String, localImage: UIImage?, inline: Bool) {
        self.init(code: code, name: name, localImage: localImage, remoteImage: "", inline: inline)
    }
    
    public convenience init(code: String, name: String, remoteImage: String) {
        self.init(code: code, name: name, localImage: nil, remoteImage: remoteImage, inline: false)
    }
    
    public override convenience init() {
        self.init(code: "", name: "", remoteImage: "")
    }
    
}
