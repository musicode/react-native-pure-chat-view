
import UIKit

public class CircleView: UIView {

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
                imageView.layer.cornerRadius = centerRadius
                imageView.clipsToBounds = true
                addSubview(imageView)
                centerImageView = imageView
            }
        }
    }
    
    // 内圆
    public var centerRadius: CGFloat {
        get {
            return circleLayer.centerRadius
        }
        set {
            circleLayer.centerRadius = newValue
            circleLayer.setNeedsDisplay()
            invalidateIntrinsicContentSize()
            if let imageView = centerImageView {
                imageView.layer.cornerRadius = newValue
            }
        }
    }
    
    public var centerColor: UIColor {
        get {
            return circleLayer.centerColor
        }
        set {
            circleLayer.centerColor = newValue
            circleLayer.setNeedsDisplay()
        }
    }

    // 圆环
    public var ringWidth: CGFloat {
        get {
            return circleLayer.ringWidth
        }
        set {
            circleLayer.ringWidth = newValue
            circleLayer.setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }
    
    public var ringColor: UIColor {
        get {
            return circleLayer.ringColor
        }
        set {
            circleLayer.ringColor = newValue
            circleLayer.setNeedsDisplay()
        }
    }

    // 高亮轨道
    public var trackWidth: CGFloat {
        get {
            return circleLayer.trackWidth
        }
        set {
            circleLayer.trackWidth = newValue
            circleLayer.setNeedsDisplay()
        }
    }
    
    public var trackColor: UIColor {
        get {
            return circleLayer.trackColor
        }
        set {
            circleLayer.trackColor = newValue
            circleLayer.setNeedsDisplay()
        }
    }
    
    // 轨道默认贴着圆环的外边，给正值可以往内部来点，当然负值就能出去点...
    public var trackOffset: CGFloat {
        get {
            return circleLayer.trackOffset
        }
        set {
            circleLayer.trackOffset = newValue
            circleLayer.setNeedsDisplay()
        }
    }
    
    // 轨道的值 0.0 - 1.0，影响轨道圆弧的大小
    public var trackValue: Double {
        get {
            return circleLayer.trackValue
        }
        set {
            circleLayer.trackValue = newValue
            circleLayer.setNeedsDisplay()
        }
    }
    
    public override class var layerClass: AnyClass {
        return CircleLayer.self
    }
    
    private var circleLayer: CircleLayer {
        return layer as! CircleLayer
    }

    // 存储当前使用的 UIImageView
    private var centerImageView: UIImageView?
    
    // 是否正在触摸
    private var isTouching = false

    // 是否触摸在圆内部
    private var isTouchingInside = false

    // 是否正在长按
    private var isLongPressing = false
    
    // 是否正在等待长按触发
    private var isLongPressWaiting = false
    
    // 按下之后多少秒触发长按回调
    private var longPressInterval: TimeInterval = 1
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 2 * circleLayer.radius, height: 2 * circleLayer.radius)
    }

    public var delegate: CircleViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.contentsScale = UIScreen.main.scale
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        layer.contentsScale = UIScreen.main.scale
    }

    // 点是否在内圆中
    // 因为这个 View 的使用方式一般是把内圆作为可点击的按钮，周围的轨道作为状态指示
    private func isPointInside(_ x: CGFloat, _ y: CGFloat) -> Bool {
        let offsetX = x - frame.width / 2
        let offsetY = y - frame.height / 2
        let distance = sqrt(offsetX * offsetX + offsetY * offsetY)
        return distance <= centerRadius
    }

    // 按下
    private func touchDown() {
        isTouching = true
        isTouchingInside = true
        isLongPressWaiting = true
        
        delegate.circleViewDidTouchDown(self)
        
        Timer.scheduledTimer(timeInterval: longPressInterval, target: self, selector: #selector(longPress), userInfo: nil, repeats: false)
    }

    // 松开，inside 表示是否在内圆松开
    private func touchUp(_ inside: Bool) {
        guard isTouching else {
            return
        }
        isTouching = false
        isTouchingInside = false
        
        if isLongPressing {
            delegate.circleViewDidLongPressEnd(self)
        }
        
        delegate.circleViewDidTouchUp(self, inside, isLongPressing)
        
        isLongPressing = false
    }
    
    @objc private func longPress() {
        guard isTouching, isLongPressWaiting else {
            return
        }
        isLongPressWaiting = false
        isLongPressing = true
        delegate.circleViewDidLongPressStart(self)
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
        delegate.circleViewDidTouchMove(self, point.x, point.y)
        let inside = isPointInside(point.x, point.y)
        if inside != isTouchingInside {
            isTouchingInside = inside
            if isTouchingInside {
                delegate.circleViewDidTouchEnter(self)
            }
            else {
                delegate.circleViewDidTouchLeave(self)
                if isLongPressWaiting {
                    isLongPressWaiting = false
                }
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
    
    public override func layoutSubviews() {
        if let imageView = centerImageView {
            imageView.frame = CGRect(x: ringWidth, y: ringWidth, width: centerRadius * 2, height: centerRadius * 2)
        }
    }

}
