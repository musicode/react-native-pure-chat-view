
import UIKit

public protocol CircleViewDelegate {

    func circleViewDidTouchDown(_ circleView: CircleView)

    func circleViewDidTouchUp(_ circleView: CircleView, _ inside: Bool, _ isLongPress: Bool)
    
    func circleViewDidTouchMove(_ circleView: CircleView, _ x: CGFloat, _ y: CGFloat)

    func circleViewDidTouchEnter(_ circleView: CircleView)

    func circleViewDidTouchLeave(_ circleView: CircleView)
    
    func circleViewDidLongPressStart(_ circleView: CircleView)
    
    func circleViewDidLongPressEnd(_ circleView: CircleView)

}

public extension CircleViewDelegate {

    func circleViewDidTouchDown(_ circleView: CircleView) { }

    func circleViewDidTouchUp(_ circleView: CircleView, _ inside: Bool, _ isLongPress: Bool) { }

    func circleViewDidTouchMove(_ circleView: CircleView, _ x: CGFloat, _ y: CGFloat) { }
    
    func circleViewDidTouchEnter(_ circleView: CircleView) { }

    func circleViewDidTouchLeave(_ circleView: CircleView) { }
    
    func circleViewDidLongPressStart(_ circleView: CircleView) { }
    
    func circleViewDidLongPressEnd(_ circleView: CircleView) { }

}
