
import UIKit

class RightVideoMessageCell: VideoMessageCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create() {
        
        super.create()
        
        durationView.font = configuration.rightVideoMessageDurationTextFont
        durationView.textColor = configuration.rightVideoMessageDurationTextColor
        
        durationView.layer.shadowColor = configuration.rightVideoMessageDurationShadowColor.cgColor
        durationView.layer.shadowOffset = configuration.rightVideoMessageDurationShadowOffset
        durationView.layer.shadowOpacity = configuration.rightVideoMessageDurationShadowOpacity
        durationView.layer.shadowRadius = configuration.rightVideoMessageDurationShadowRadius
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
            
            NSLayoutConstraint(item: thumbnailView, attribute: .right, relatedBy: .equal, toItem: avatarView, attribute: .left, multiplier: 1, constant: -configuration.rightVideoMessageMarginRight),
            
            NSLayoutConstraint(item: playView, attribute: .centerX, relatedBy: .equal, toItem: thumbnailView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: playView, attribute: .centerY, relatedBy: .equal, toItem: thumbnailView, attribute: .centerY, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: durationView, attribute: .right, relatedBy: .equal, toItem: thumbnailView, attribute: .right, multiplier: 1, constant: -configuration.videoMessageDurationMarginRight),
            NSLayoutConstraint(item: durationView, attribute: .bottom, relatedBy: .equal, toItem: thumbnailView, attribute: .bottom, multiplier: 1, constant: -configuration.videoMessageDurationMarginBottom),
            
            NSLayoutConstraint(item: spinnerView, attribute: .right, relatedBy: .equal, toItem: thumbnailView, attribute: .left, multiplier: 1, constant: -configuration.rightStatusViewMarginRight),
            NSLayoutConstraint(item: spinnerView, attribute: .bottom, relatedBy: .equal, toItem: thumbnailView, attribute: .bottom, multiplier: 1, constant: -configuration.rightStatusViewMarginBottom),
            
            NSLayoutConstraint(item: failureView, attribute: .right, relatedBy: .equal, toItem: thumbnailView, attribute: .left, multiplier: 1, constant: -configuration.rightStatusViewMarginRight),
            NSLayoutConstraint(item: failureView, attribute: .bottom, relatedBy: .equal, toItem: thumbnailView, attribute: .bottom, multiplier: 1, constant: -configuration.rightStatusViewMarginBottom),
            
        ])
        
        if configuration.rightUserNameVisible {
            
            nameView.font = configuration.rightUserNameTextFont
            nameView.textColor = configuration.rightUserNameTextColor
            nameView.textAlignment = .right
            
            contentView.addSubview(nameView)
            addClickHandler(view: nameView, selector: #selector(onUserNameClick))
            
            contentView.addConstraints([
                
                NSLayoutConstraint(item: nameView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: nameView, attribute: .right, relatedBy: .equal, toItem: avatarView, attribute: .left, multiplier: 1, constant: -configuration.rightUserNameMarginRight),
                NSLayoutConstraint(item: nameView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: getContentMaxWidth()),
                
                NSLayoutConstraint(item: thumbnailView, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1, constant: configuration.rightUserNameMarginBottom),
                
            ])
            
        }
        else {
            contentView.addConstraints([
                
                NSLayoutConstraint(item: thumbnailView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                
            ])
        }
        
    }
    
}
