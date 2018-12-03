
import UIKit

public class SimpleButton: UIButton {
    
    public var onClick: (() -> Void)?
    
    public var borderRadius: CGFloat = 0
    
    private var leftBorder: UIView?
    private var leftBorderConstraints: [NSLayoutConstraint]?
    
    private var topBorder: UIView?
    private var topBorderConstraints: [NSLayoutConstraint]?
    
    private var rightBorder: UIView?
    private var rightBorderConstraints: [NSLayoutConstraint]?
    
    private var bottomBorder: UIView?
    private var bottomBorderConstraints: [NSLayoutConstraint]?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addTarget(self, action: #selector(self.touchUpInside), for: .touchUpInside)
    }
    
    public func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        if let image = makeImage(color: color) {
            setBackgroundImage(UIImage(cgImage: image), for: state)
        }
    }
    
    public func setLeftBorder(width: CGFloat, color: UIColor) {
        if let border = leftBorder {
            removeConstraints(leftBorderConstraints!)
            border.removeFromSuperview()
        }
        leftBorder = UIView()
        if let border = leftBorder {
            
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
            
        }
    }
    
    public func setTopBorder(width: CGFloat, color: UIColor) {
        if let border = topBorder {
            removeConstraints(topBorderConstraints!)
            border.removeFromSuperview()
        }
        topBorder = UIView()
        if let border = topBorder {
            
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
            
        }
    }
    
    public func setRightBorder(width: CGFloat, color: UIColor) {
        if let border = rightBorder {
            removeConstraints(rightBorderConstraints!)
            border.removeFromSuperview()
        }
        rightBorder = UIView()
        if let border = rightBorder {
            
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
            
        }
    }
    
    public func setBottomBorder(width: CGFloat, color: UIColor) {
        if let border = bottomBorder {
            removeConstraints(bottomBorderConstraints!)
            border.removeFromSuperview()
        }
        bottomBorder = UIView()
        if let border = bottomBorder {
            
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
            
        }
    }
    
    private func makeImage(color: UIColor) -> CGImage? {
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        if borderRadius > 0 {
            let borderPath = UIBezierPath(roundedRect: rect, cornerRadius: borderRadius)
            context?.addPath(borderPath.cgPath)
            context?.fillPath()
        }
        else {
            context?.fill(rect)
        }
        
        let image = context?.makeImage()
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    @objc private func touchUpInside() {
        onClick?()
    }
    
}
