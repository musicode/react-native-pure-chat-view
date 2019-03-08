
import UIKit

public class CircleLayer: CALayer {
    
    // 内圆
    @objc dynamic public var centerRadius: CGFloat = 0
    
    @objc dynamic public var centerColor = UIColor.clear
    
    // 圆环
    @objc dynamic public var ringWidth: CGFloat = 0
    
    @objc dynamic public var ringColor = UIColor.clear
    
    // 高亮轨道
    @objc dynamic public var trackWidth: CGFloat = 0
    @objc dynamic public var trackColor = UIColor.clear
    
    // 轨道默认贴着圆环的外边，给正值可以往内部来点，当然负值就能出去点...
    @objc dynamic public var trackOffset: CGFloat = 0
    
    // 轨道的值 0.0 - 1.0，影响轨道圆弧的大小
    @objc dynamic public var trackValue = 0.0 {
        didSet {
            if trackValue > 1 {
                trackValue = 1
            }
            else if trackValue < 0 {
                trackValue = 0
            }
        }
    }
    
    // 半径 = 内圆 + 圆环
    public var radius: CGFloat {
        return centerRadius + ringWidth
    }
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        
        if let other = layer as? CircleLayer {
            self.centerRadius = other.centerRadius
            self.centerColor = other.centerColor
            self.ringWidth = other.ringWidth
            self.ringColor = other.ringColor
            self.trackWidth = other.trackWidth
            self.trackColor = other.trackColor
            self.trackOffset = other.trackOffset
            self.trackValue = other.trackValue
        }
        else {
            fatalError()
        }
        
        super.init(layer: layer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func draw(in ctx: CGContext) {
        
        let centerX = bounds.midX
        let centerY = bounds.midY
        
        // 画外圆
        if ringWidth > 0 {
            ctx.setFillColor(ringColor.cgColor)
            ctx.addEllipse(in: CGRect(x: centerX - radius, y: centerY - radius, width: 2 * radius, height: 2 * radius))
            ctx.drawPath(using: .fill)
            
            // 在上面画高亮圆弧
            if trackWidth > 0 && ringWidth >= trackWidth {
                ctx.setStrokeColor(trackColor.cgColor)
                ctx.setLineWidth(trackWidth)
                
                let startAngle = -0.5 * Double.pi
                let endAngle = 2 * Double.pi * trackValue + startAngle
                
                ctx.addArc(center: CGPoint(x: centerX, y: centerY), radius: radius - trackWidth * 0.5 - trackOffset, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
                ctx.drawPath(using: .stroke)
            }
        }
        
        // 画内圆
        ctx.setFillColor(centerColor.cgColor)
        ctx.addEllipse(in: CGRect(x: centerX - centerRadius, y: centerY - centerRadius, width: 2 * centerRadius, height: 2 * centerRadius))
        ctx.drawPath(using: .fill)
        
    }
    
    public override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(CircleLayer.centerRadius)
            || key == #keyPath(CircleLayer.centerColor)
            || key == #keyPath(CircleLayer.ringWidth)
            || key == #keyPath(CircleLayer.ringColor)
            || key == #keyPath(CircleLayer.trackWidth)
            || key == #keyPath(CircleLayer.trackColor)
            || key == #keyPath(CircleLayer.trackOffset)
            || key == #keyPath(CircleLayer.trackValue) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    public override func action(forKey event: String) -> CAAction? {
        if event == #keyPath(CircleLayer.trackValue) {
            let anim = CABasicAnimation(keyPath: #keyPath(CircleLayer.trackValue))
            anim.byValue = 0.01
            anim.timingFunction = CAMediaTimingFunction(name: .linear)
            anim.fromValue = 0
            return anim
        }
        return super.action(forKey: event)
    }
    
}
