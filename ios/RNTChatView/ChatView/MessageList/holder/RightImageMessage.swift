
import UIKit

class RightImageMessageCell: ImageMessageCell {

    override func create() {
        
        super.create()
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
            
            NSLayoutConstraint(item: photoView, attribute: .right, relatedBy: .equal, toItem: avatarView, attribute: .left, multiplier: 1, constant: -configuration.rightImageMessageMarginRight),
            
            NSLayoutConstraint(item: spinnerView, attribute: .right, relatedBy: .equal, toItem: photoView, attribute: .left, multiplier: 1, constant: -configuration.rightStatusViewMarginRight),
            NSLayoutConstraint(item: spinnerView, attribute: .bottom, relatedBy: .equal, toItem: photoView, attribute: .bottom, multiplier: 1, constant: -configuration.rightStatusViewMarginBottom),
            
            NSLayoutConstraint(item: failureView, attribute: .right, relatedBy: .equal, toItem: photoView, attribute: .left, multiplier: 1, constant: -configuration.rightStatusViewMarginRight),
            NSLayoutConstraint(item: failureView, attribute: .bottom, relatedBy: .equal, toItem: photoView, attribute: .bottom, multiplier: 1, constant: -configuration.rightStatusViewMarginBottom),
            
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
                
                NSLayoutConstraint(item: photoView, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1, constant: configuration.rightUserNameMarginBottom),
                
            ])
            
        }
        else {
            contentView.addConstraints([
                
                NSLayoutConstraint(item: photoView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                
            ])
        }
        
    }
    
}
