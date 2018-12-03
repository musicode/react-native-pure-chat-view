
import UIKit

class LeftPostMessageCell: PostMessageCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create() {
        
        super.create()
        
        bubbleView.setBackgroundImage(configuration.leftPostMessageBubbleImageNormal, for: .normal)
        bubbleView.setBackgroundImage(configuration.leftPostMessageBubbleImagePressed, for: .highlighted)
        
        titleView.font = configuration.leftPostMessageTitleTextFont
        titleView.textColor = configuration.leftPostMessageTitleTextColor
        
        descView.font = configuration.leftPostMessageDescTextFont
        descView.textColor = configuration.leftPostMessageDescTextColor
        
        dividerView.backgroundColor = configuration.leftPostMessageDividerColor
        
        labelView.font = configuration.leftPostMessageLabelTextFont
        labelView.textColor = configuration.leftPostMessageLabelTextColor
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
            
            NSLayoutConstraint(item: bubbleView, attribute: .left, relatedBy: .equal, toItem: avatarView, attribute: .right, multiplier: 1, constant: configuration.leftPostMessageMarginLeft),
            NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.postMessageBubbleWidth),
            
            NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: bubbleView, attribute: .top, multiplier: 1, constant: configuration.leftPostMessageTitleMarginTop),
            NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftPostMessageTitleMarginLeft),
            NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.leftPostMessageTitleMarginRight),
            
            NSLayoutConstraint(item: thumbnailView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1, constant: configuration.leftPostMessageThumbnailMarginTop),
            NSLayoutConstraint(item: thumbnailView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.leftPostMessageThumbnailMarginRight),
            NSLayoutConstraint(item: thumbnailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.leftPostMessageThumbnailWidth),
            NSLayoutConstraint(item: thumbnailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.leftPostMessageThumbnailHeight),
            
            NSLayoutConstraint(item: descView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1, constant: configuration.leftPostMessageDescMarginTop),
            NSLayoutConstraint(item: descView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftPostMessageDescMarginLeft),
            NSLayoutConstraint(item: descView, attribute: .right, relatedBy: .equal, toItem: thumbnailView, attribute: .left, multiplier: 1, constant: -configuration.leftPostMessageThumbnailMarginLeft),
            
            NSLayoutConstraint(item: dividerView, attribute: .top, relatedBy: .equal, toItem: thumbnailView, attribute: .bottom, multiplier: 1, constant: configuration.leftPostMessageDividerMarginTop),
            NSLayoutConstraint(item: dividerView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftPostMessageDividerMarginLeft),
            NSLayoutConstraint(item: dividerView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.leftPostMessageDividerMarginRight),
            NSLayoutConstraint(item: dividerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.postMessageDividerWidth),
            
            NSLayoutConstraint(item: labelView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftPostMessageLabelMarginLeft),
            NSLayoutConstraint(item: labelView, attribute: .top, relatedBy: .equal, toItem: dividerView, attribute: .top, multiplier: 1, constant: configuration.leftPostMessageLabelMarginTop),
            NSLayoutConstraint(item: labelView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.leftPostMessageLabelMarginBottom),
            
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
