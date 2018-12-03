
import UIKit

class FeatureButton: UIView {
    
    private let buttonView = RoundView()
    
    private let titleView = UILabel()
    
    private var configuration: MessageInputConfiguration!
    
    var onClick: (() -> Void)?

    public convenience init(title: String, image: UIImage, configuration: MessageInputConfiguration) {
        self.init()
        self.configuration = configuration
        setup(title: title, image: image)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(title: String, image: UIImage) {

        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonView.centerImage = image
        buttonView.centerColor = configuration.featureButtonBackgroundColorNormal
        buttonView.borderRadius = configuration.featureButtonBorderRadius
        buttonView.borderWidth = configuration.featureButtonBorderWidth
        buttonView.borderColor = configuration.featureButtonBorderColor
        buttonView.width = configuration.featureButtonWidth
        buttonView.height = configuration.featureButtonHeight
        
        buttonView.delegate = self
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.font = configuration.featureButtonTitleTextFont
        titleView.textColor = configuration.featureButtonTitleTextColor
        titleView.numberOfLines = 1
        titleView.lineBreakMode = .byTruncatingTail
        titleView.textAlignment = .center
        titleView.text = title
        titleView.sizeToFit()

        addSubview(buttonView)
        addSubview(titleView)
        
        addConstraints([
            NSLayoutConstraint(item: buttonView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: buttonView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: buttonView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: buttonView, attribute: .bottom, multiplier: 1, constant: configuration.featureButtonTitleMarginTop),
            NSLayoutConstraint(item: titleView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
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

