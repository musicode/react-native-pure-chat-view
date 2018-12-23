
import UIKit

public protocol RoundViewDelegate {
    
    func roundViewDidTouchDown(_ roundView: RoundView)
    
    func roundViewDidTouchUp(_ roundView: RoundView, _ inside: Bool)
    
    func roundViewDidTouchMove(_ roundView: RoundView, _ x: CGFloat, _ y: CGFloat)
    
    func roundViewDidTouchEnter(_ roundView: RoundView)
    
    func roundViewDidTouchLeave(_ roundView: RoundView)
    
}

public extension RoundViewDelegate {
    
    func roundViewDidTouchDown(_ roundView: RoundView) { }
    
    func roundViewDidTouchUp(_ roundView: RoundView, _ inside: Bool) { }
    
    func roundViewDidTouchMove(_ roundView: RoundView, _ x: CGFloat, _ y: CGFloat) { }
    
    func roundViewDidTouchEnter(_ roundView: RoundView) { }
    
    func roundViewDidTouchLeave(_ roundView: RoundView) { }
    
}
