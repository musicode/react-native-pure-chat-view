
import UIKit

public class SimpleButton: UIButton {
    
    public var onClick: (() -> Void)?
    public var backgroundColorPressed: UIColor?
    
    private var isTouching = false
    private var isTouchingInside = false
    private var backgroundColorNormal: UIColor?

    private var leftBorder: UIView?
    private var leftBorderConstraints: [NSLayoutConstraint]?
    
    private var topBorder: UIView?
    private var topBorderConstraints: [NSLayoutConstraint]?
    
    private var rightBorder: UIView?
    private var rightBorderConstraints: [NSLayoutConstraint]?
    
    private var bottomBorder: UIView?
    private var bottomBorderConstraints: [NSLayoutConstraint]?
    
    private func isPointInside(_ x: CGFloat, _ y: CGFloat) -> Bool {
        return x >= 0
            && y >= 0
            && x <= bounds.width
            && y <= bounds.height
    }
    
    private func touchDown() {
        
        isTouching = true
        isTouchingInside = true
        
        guard let color = backgroundColorPressed else {
            return
        }

        backgroundColorNormal = backgroundColor != nil ? backgroundColor : .clear
        backgroundColor = color
        
    }
    
    private func touchEnter() {
        
        guard isTouching, let color = backgroundColorPressed else {
            return
        }
        
        backgroundColorNormal = backgroundColor != nil ? backgroundColor : .clear
        backgroundColor = color
        
    }
    
    private func touchLeave() {
        
        guard isTouching, let color = backgroundColorNormal else {
            return
        }
        backgroundColor = color
        backgroundColorNormal = nil
        
    }

    private func touchUp(_ inside: Bool) {
        
        guard isTouching else {
            return
        }
        
        isTouching = false
        isTouchingInside = false
        
        if inside {
            onClick?()
        }
        
        guard let color = backgroundColorNormal else {
            return
        }
        backgroundColor = color
        backgroundColorNormal = nil
        
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
        let inside = isPointInside(point.x, point.y)
        if inside != isTouchingInside {
            isTouchingInside = inside
            if isTouchingInside {
                touchEnter()
            }
            else {
                touchLeave()
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
    
    public func setLeftBorder(width: CGFloat, color: UIColor) {
        
        if let border = leftBorder {
            removeConstraints(leftBorderConstraints!)
            border.removeFromSuperview()
        }
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        addSubview(border)
        
        leftBorderConstraints = [
            NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width),
        ]
        
        addConstraints(leftBorderConstraints!)
        
        leftBorder = border
    }
    
    public func setTopBorder(width: CGFloat, color: UIColor) {
        
        if let border = topBorder {
            removeConstraints(topBorderConstraints!)
            border.removeFromSuperview()
        }
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        addSubview(border)
        
        topBorderConstraints = [
            NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: width),
        ]
        
        addConstraints(topBorderConstraints!)
        
        topBorder = border
        
    }
    
    public func setRightBorder(width: CGFloat, color: UIColor) {
        
        if let border = rightBorder {
            removeConstraints(rightBorderConstraints!)
            border.removeFromSuperview()
        }
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        addSubview(border)
        
        rightBorderConstraints = [
            NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width),
        ]
        
        addConstraints(rightBorderConstraints!)
        
        rightBorder = border
        
    }
    
    public func setBottomBorder(width: CGFloat, color: UIColor) {
        
        if let border = bottomBorder {
            removeConstraints(bottomBorderConstraints!)
            border.removeFromSuperview()
        }
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        addSubview(border)
        
        bottomBorderConstraints = [
            NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: width),
        ]
        
        addConstraints(bottomBorderConstraints!)
        
        bottomBorder = border
        
    }
    
}
