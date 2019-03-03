
import UIKit

class LeftCardMessageCell: CardMessageCell {

    override func create() {
        
        super.create()
        
        bubbleView.setBackgroundImage(configuration.leftCardMessageBubbleImageNormal, for: .normal)
        bubbleView.setBackgroundImage(configuration.leftCardMessageBubbleImagePressed, for: .selected)
        bubbleView.setBackgroundImage(configuration.leftCardMessageBubbleImagePressed, for: .highlighted)
        
        titleView.font = configuration.leftCardMessageTitleTextFont
        titleView.textColor = configuration.leftCardMessageTitleTextColor
        
        descView.font = configuration.leftCardMessageDescTextFont
        descView.textColor = configuration.leftCardMessageDescTextColor
        
        dividerView.backgroundColor = configuration.leftCardMessageDividerColor
        
        labelView.font = configuration.leftCardMessageLabelTextFont
        labelView.textColor = configuration.leftCardMessageLabelTextColor
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
            
            NSLayoutConstraint(item: bubbleView, attribute: .left, relatedBy: .equal, toItem: avatarView, attribute: .right, multiplier: 1, constant: configuration.leftCardMessageMarginLeft),
            NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.cardMessageBubbleWidth),
            
            NSLayoutConstraint(item: thumbnailView, attribute: .top, relatedBy: .equal, toItem: bubbleView, attribute: .top, multiplier: 1, constant: configuration.leftCardMessagePaddingVertical),
            NSLayoutConstraint(item: thumbnailView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftCardMessagePaddingLeft),
            NSLayoutConstraint(item: thumbnailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.cardMessageThumbnailWidth),
            NSLayoutConstraint(item: thumbnailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.cardMessageThumbnailHeight),
            
            NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: thumbnailView, attribute: .right, multiplier: 1, constant: configuration.leftCardMessageTitleMarginLeft),
            NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: thumbnailView, attribute: .top, multiplier: 1, constant: configuration.leftCardMessageTitleMarginTop),
            NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.leftCardMessagePaddingHorizontal),
            
            NSLayoutConstraint(item: descView, attribute: .left, relatedBy: .equal, toItem: titleView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: descView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1, constant: configuration.leftCardMessageDescMarginTop),
            NSLayoutConstraint(item: descView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.leftCardMessagePaddingHorizontal),
            
            NSLayoutConstraint(item: dividerView, attribute: .top, relatedBy: .equal, toItem: thumbnailView, attribute: .bottom, multiplier: 1, constant: configuration.leftCardMessagePaddingVertical),
            NSLayoutConstraint(item: dividerView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftCardMessageDividerMarginLeft),
            NSLayoutConstraint(item: dividerView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.leftCardMessageDividerMarginRight),
            NSLayoutConstraint(item: dividerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.cardMessageDividerWidth),

            NSLayoutConstraint(item: labelView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftCardMessagePaddingLeft),
            NSLayoutConstraint(item: labelView, attribute: .top, relatedBy: .equal, toItem: dividerView, attribute: .top, multiplier: 1, constant: configuration.leftCardMessageLabelMarginTop),
            NSLayoutConstraint(item: labelView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.leftCardMessageLabelMarginBottom),
            
            NSLayoutConstraint(item: spinnerView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: configuration.leftStatusViewMarginLeft),
            NSLayoutConstraint(item: spinnerView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.leftStatusViewMarginBottom),
            
            NSLayoutConstraint(item: failureView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: configuration.leftStatusViewMarginLeft),
            NSLayoutConstraint(item: failureView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.leftStatusViewMarginBottom),
            
        ])
        
        if configuration.leftUserNameVisible {
            
            nameView.font = configuration.leftUserNameTextFont
            nameView.textColor = configuration.leftUserNameTextColor
            nameView.textAlignment = .left
            
            contentView.addSubview(nameView)
            addClickHandler(view: nameView, selector: #selector(onUserNameClick))
            
            contentView.addConstraints([
                
                NSLayoutConstraint(item: nameView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: nameView, attribute: .left, relatedBy: .equal, toItem: avatarView, attribute: .right, multiplier: 1, constant: configuration.leftUserNameMarginLeft),
                NSLayoutConstraint(item: nameView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: getContentMaxWidth()),
                
                NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1, constant: configuration.leftUserNameMarginBottom),
                
            ])
            
        }
        else {
            contentView.addConstraints([
                
                NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                
            ])
        }
        
    }
    
}
