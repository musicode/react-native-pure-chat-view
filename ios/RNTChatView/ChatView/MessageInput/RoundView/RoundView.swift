
import UIKit

public class RoundView: UIView {
    
    // 背景色
    public var centerColor = UIColor.blue
    
    // 居中的图片
    public var centerImage: UIImage? {
        didSet {
            // 移除老的
            if let imageView = centerImageView {
                imageView.removeFromSuperview()
            }
            if let image = centerImage {
                let imageView = UIImageView(image: image)
                // 保持原比例，不填充
                imageView.contentMode = .center
                imageView.layer.masksToBounds = true
                addSubview(imageView)
                centerImageView = imageView
            }
        }
    }
    
    public var borderWidth: CGFloat = 10
    
    public var borderColor = UIColor.green
    
    public var borderRadius: CGFloat = 20
    
    public var width: CGFloat = 200
    
    public var height: CGFloat = 200

    // 存储当前使用的 UIImageView
    private var centerImageView: UIImageView?
    
    // 是否正在触摸
    private var isTouching = false
    
    // 是否触摸在内部
    private var isTouchingInside = false
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    public var delegate: RoundViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    private func isPointInside(_ x: CGFloat, _ y: CGFloat) -> Bool {
        // 不用那么精确，直接判断矩形区域得了
        return x >= 0 && x <= width && y >= 0 && y < height
    }
    
    // 按下
    private func touchDown() {
        isTouching = true
        isTouchingInside = true
        delegate.roundViewDidTouchDown(self)
    }
    
    // 松开
    private func touchUp(_ inside: Bool) {
        guard isTouching else {
            return
        }
        isTouching = false
        isTouchingInside = false
        delegate.roundViewDidTouchUp(self, inside)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard !isTouching, touches.count == 1, let point = touches.first?.location(in: self), isPointInside(point.x, point.y) else {
            return
        }
        touchDown()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard isTouching, touches.count == 1, let point = touches.first?.location(in: self) else {
            return
        }
        delegate.roundViewDidTouchMove(self, point.x, point.y)
        let inside = isPointInside(point.x, point.y)
        if inside != isTouchingInside {
            isTouchingInside = inside
            if isTouchingInside {
                delegate.roundViewDidTouchEnter(self)
            }
            else {
                delegate.roundViewDidTouchLeave(self)
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchUp(isTouchingInside)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchUp(false)
    }
    
    public override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // 画边框
        context.setFillColor(borderColor.cgColor)
        
        let borderPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: borderRadius)
        context.addPath(borderPath.cgPath)
        
        context.fillPath()
        
        
        // 画背景
        context.setFillColor(centerColor.cgColor)
        
        let backgroundPath = UIBezierPath(roundedRect: CGRect(x: 0 + borderWidth, y: 0 + borderWidth, width: width - 2 * borderWidth, height: height - 2 * borderWidth), cornerRadius: borderRadius - 0.5 * borderWidth)
        context.addPath(backgroundPath.cgPath)
        
        context.fillPath()
        
        
    }
    
    public override func layoutSubviews() {
        if let imageView = centerImageView {
            imageView.frame = CGRect(x: borderWidth, y: borderWidth, width: width - 2 * borderWidth, height: height - 2 * borderWidth)
        }
    }
    
}
