
import UIKit

class FeatureButton: UIView {
    
    var onClick: (() -> Void)?
    
    private lazy var buttonView: RoundView = {
        
        let view = RoundView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.centerColor = configuration.featureButtonBackgroundColorNormal
        view.borderRadius = configuration.featureButtonBorderRadius
        view.borderWidth = configuration.featureButtonBorderWidth
        view.borderColor = configuration.featureButtonBorderColor
        view.width = configuration.featureButtonWidth
        view.height = configuration.featureButtonHeight
        
        view.delegate = self
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
        ])
        
        return view
        
    }()
    
    private lazy var titleView: UILabel = {
        
        let view = UILabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = configuration.featureButtonTitleTextFont
        view.textColor = configuration.featureButtonTitleTextColor
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.textAlignment = .center
        view.sizeToFit()
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: buttonView, attribute: .bottom, multiplier: 1, constant: configuration.featureButtonTitleMarginTop),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
        return view
        
    }()
    
    private var configuration: MessageInputConfiguration!
    
    public convenience init(title: String, image: UIImage, configuration: MessageInputConfiguration) {
        self.init()
        self.configuration = configuration
        buttonView.centerImage = image
        titleView.text = title
    }
    
}

extension FeatureButton: RoundViewDelegate {
    
    func roundViewDidTouchDown(_ roundView: RoundView) {
        roundView.centerColor = configuration.featureButtonBackgroundColorPressed
        roundView.setNeedsDisplay()
    }
    
    func roundViewDidTouchUp(_ roundView: RoundView, _ inside: Bool) {
        guard inside else {
            return
        }
        roundView.centerColor = configuration.featureButtonBackgroundColorNormal
        roundView.setNeedsDisplay()
        onClick?()
    }
    
    func roundViewDidTouchEnter(_ roundView: RoundView) {
        roundView.centerColor = configuration.featureButtonBackgroundColorPressed
        roundView.setNeedsDisplay()
    }
    
    func roundViewDidTouchLeave(_ roundView: RoundView) {
        roundView.centerColor = configuration.featureButtonBackgroundColorNormal
        roundView.setNeedsDisplay()
    }
    
}

