
import UIKit

class RightFileMessageCell: FileMessageCell {
    
    override func create() {
        
        super.create()
        
        bubbleView.setBackgroundImage(configuration.rightFileMessageBubbleImageNormal, for: .normal)
        bubbleView.setBackgroundImage(configuration.rightFileMessageBubbleImagePressed, for: .selected)
        bubbleView.setBackgroundImage(configuration.rightFileMessageBubbleImagePressed, for: .highlighted)
        
        titleView.font = configuration.rightFileMessageTitleTextFont
        titleView.textColor = configuration.rightFileMessageTitleTextColor
        
        descView.font = configuration.rightFileMessageDescTextFont
        descView.textColor = configuration.rightFileMessageDescTextColor
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
            
            NSLayoutConstraint(item: bubbleView, attribute: .right, relatedBy: .equal, toItem: avatarView, attribute: .left, multiplier: 1, constant: -configuration.rightFileMessageMarginRight),
            NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.fileMessageBubbleWidth),
            
            NSLayoutConstraint(item: iconView, attribute: .top, relatedBy: .equal, toItem: bubbleView, attribute: .top, multiplier: 1, constant: configuration.rightFileMessagePaddingVertical),
            NSLayoutConstraint(item: iconView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.rightFileMessagePaddingHorizontal),
            NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.fileMessageIconWidth),
            NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.fileMessageIconHeight),
            NSLayoutConstraint(item: iconView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.rightFileMessagePaddingVertical),
            
            NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: iconView, attribute: .right, multiplier: 1, constant: configuration.rightFileMessageTitleMarginLeft),
            NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .top, multiplier: 1, constant: configuration.rightFileMessageTitleMarginTop),
            NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.rightFileMessagePaddingHorizontal),
            
            NSLayoutConstraint(item: descView, attribute: .left, relatedBy: .equal, toItem: titleView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: descView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1, constant: configuration.rightFileMessageDescMarginTop),
            NSLayoutConstraint(item: descView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.rightFileMessagePaddingRight),
            NSLayoutConstraint(item: descView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.rightFileMessagePaddingVertical),
            
            NSLayoutConstraint(item: spinnerView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: -configuration.rightStatusViewMarginRight),
            NSLayoutConstraint(item: spinnerView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.rightStatusViewMarginBottom),
            
            NSLayoutConstraint(item: failureView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: -configuration.rightStatusViewMarginRight),
            NSLayoutConstraint(item: failureView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.rightStatusViewMarginBottom),
            
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
                
                NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1, constant: configuration.rightUserNameMarginBottom),
                
            ])
            
        }
        else {
            contentView.addConstraints([
                
                NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                
            ])
        }
        
    }
    
}
