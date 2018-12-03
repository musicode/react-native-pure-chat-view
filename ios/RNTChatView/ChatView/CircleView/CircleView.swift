
import UIKit

public class CircleView: UIView {

    // 内圆
    public var centerRadius: CGFloat = 36 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public var centerColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    public var centerImage: UIImage? {
        didSet {
            // 移除老的
            if let imageView = centerImageView {
                imageView.removeFromSuperview()
            }
            if let image = centerImage {
                centerImageView = UIImageView(image: image)
                // 保持原比例，不填充
                centerImageView!.contentMode = .center
                centerImageView!.layer.masksToBounds = true
                addSubview(centerImageView!)
            }
        }
    }
    

    // 圆环
    public var ringWidth: CGFloat = 7 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public var ringColor = UIColor(red: 221.0 / 255.0, green: 221.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)

    // 高亮轨道
    public var trackWidth: CGFloat = 7
    public var trackColor = UIColor(red: 80.0 / 255.0, green: 210.0 / 255.0, blue: 17.0 / 255.0, alpha: 1.0)
    
    // 轨道默认贴着圆环的外边，给正值可以往内部来点，当然负值就能出去点...
    public var trackOffset: CGFloat = 0
    
    // 轨道的值 0.0 - 1.0，影响轨道圆弧的大小
    public var trackValue = 0.0

    // 存储当前使用的 UIImageView
    private var centerImageView: UIImageView?
    
    // 是否正在触摸
    private var isTouching = false

    // 是否触摸在圆内部
    private var isTouchInside = false

    // 是否正在长按
    private var isLongPressing = false
    
    // 按下之后多少秒触发长按回调
    private var longPressInterval: TimeInterval = 1
    
    // 是否正在等待长按触发
    private var longPressWaiting = false
    
    // 半径 = 内圆 + 圆环
    private var radius: CGFloat {
        return centerRadius + ringWidth
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 2 * radius, height: 2 * radius)
    }

    public var delegate: CircleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        isTouchInside = true
        longPressWaiting = true
        
        delegate?.circleViewDidTouchDown(self)
        
        Timer.scheduledTimer(timeInterval: longPressInterval, target: self, selector: #selector(CircleView.longPress), userInfo: nil, repeats: false)
    }

    // 松开，inside 表示是否在内圆松开
    private func touchUp(_ inside: Bool) {
        guard isTouching else {
            return
        }
        isTouching = false
        isTouchInside = false
        
        if isLongPressing {
            delegate?.circleViewDidLongPressEnd(self)
        }
        
        delegate?.circleViewDidTouchUp(self, inside, isLongPressing)
        
        isLongPressing = false
    }
    
    @objc private func longPress() {
        guard isTouching, longPressWaiting else {
            return
        }
        longPressWaiting = false
        isLongPressing = true
        delegate?.circleViewDidLongPressStart(self)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isTouching, touches.count == 1 else {
            return
        }
        if let point = touches.first?.location(in: self) {
            if isPointInside(point.x, point.y) {
                touchDown()
            }
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTouching, touches.count == 1 else {
            return
        }
        if let point = touches.first?.location(in: self) {
            delegate?.circleViewDidTouchMove(self, point.x, point.y)
            let inside = isPointInside(point.x, point.y)
            if inside != isTouchInside {
                isTouchInside = inside
                if isTouchInside {
                    delegate?.circleViewDidTouchEnter(self)
                }
                else {
                    delegate?.circleViewDidTouchLeave(self)
                    if longPressWaiting {
                        longPressWaiting = false
                    }
                }
            }
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(isTouchInside)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(false)
    }

    public override func draw(_ rect: CGRect) {

        let currentContext = UIGraphicsGetCurrentContext()
        guard let context = currentContext else {
            return
        }

        let centerX = frame.width / 2
        let centerY = frame.height / 2

        // 画外圆
        if ringWidth > 0 {
            context.setFillColor(ringColor.cgColor)
            context.addEllipse(in: CGRect(x: centerX - radius, y: centerY - radius, width: 2 * radius, height: 2 * radius))
            context.fillPath()

            // 在上面画高亮圆弧
            if trackWidth > 0 && ringWidth >= trackWidth {
                context.setStrokeColor(trackColor.cgColor)
                context.setLineWidth(trackWidth)

                let startAngle = -0.5 * Double.pi
                let endAngle = 2 * Double.pi * trackValue + startAngle

                context.addArc(center: CGPoint(x: centerX, y: centerY), radius: radius - trackWidth * 0.5 - trackOffset, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
                context.strokePath()
            }
        }

        // 画内圆
        context.setFillColor(centerColor.cgColor)
        context.addEllipse(in: CGRect(x: centerX - centerRadius, y: centerY - centerRadius, width: 2 * centerRadius, height: 2 * centerRadius))
        context.fillPath()

    }
    
    public override func layoutSubviews() {
        if let imageView = centerImageView {
            imageView.frame = CGRect(x: ringWidth, y: ringWidth, width: centerRadius * 2, height: centerRadius * 2)
            imageView.layer.cornerRadius = centerRadius
        }
    }

}