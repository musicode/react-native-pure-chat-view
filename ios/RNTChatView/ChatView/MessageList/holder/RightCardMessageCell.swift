
import UIKit

class RightCardMessageCell: CardMessageCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create() {
        
        super.create()
        
        bubbleView.setBackgroundImage(configuration.rightCardMessageBubbleImageNormal, for: .normal)
        bubbleView.setBackgroundImage(configuration.rightCardMessageBubbleImagePressed, for: .highlighted)
        
        titleView.font = configuration.rightCardMessageTitleTextFont
        titleView.textColor = configuration.rightCardMessageTitleTextColor
        
        descView.font = configuration.rightCardMessageDescTextFont
        descView.textColor = configuration.rightCardMessageDescTextColor
        
        dividerView.backgroundColor = configuration.rightCardMessageDividerColor
        
        labelView.font = configuration.rightCardMessageLabelTextFont
        labelView.textColor = configuration.rightCardMessageLabelTextColor
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
            
            NSLayoutConstraint(item: bubbleView, attribute: .right, relatedBy: .equal, toItem: avatarView, attribute: .left, multiplier: 1, constant: -configuration.rightCardMessageMarginRight),
            NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.cardMessageBubbleWidth),

            NSLayoutConstraint(item: thumbnailView, attribute: .top, relatedBy: .equal, toItem: bubbleView, attribute: .top, multiplier: 1, constant: configuration.rightCardMessageThumbnailMarginTop),
            NSLayoutConstraint(item: thumbnailView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.rightCardMessageThumbnailMarginLeft),
            NSLayoutConstraint(item: thumbnailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.cardMessageThumbnailWidth),
            NSLayoutConstraint(item: thumbnailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.cardMessageThumbnailHeight),
            
            NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: thumbnailView, attribute: .right, multiplier: 1, constant: configuration.rightCardMessageTitleMarginLeft),
            NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: bubbleView, attribute: .top, multiplier: 1, constant: configuration.rightCardMessageTitleMarginTop),
            NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.rightCardMessageTitleMarginRight),
            
            NSLayoutConstraint(item: descView, attribute: .left, relatedBy: .equal, toItem: thumbnailView, attribute: .right, multiplier: 1, constant: configuration.rightCardMessageDescMarginLeft),
            NSLayoutConstraint(item: descView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1, constant: configuration.rightCardMessageDescMarginTop),
            NSLayoutConstraint(item: descView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.rightCardMessageDescMarginRight),
            
            NSLayoutConstraint(item: dividerView, attribute: .top, relatedBy: .equal, toItem: thumbnailView, attribute: .bottom, multiplier: 1, constant: configuration.rightCardMessageDividerMarginTop),
            NSLayoutConstraint(item: dividerView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.rightCardMessageDividerMarginLeft),
            NSLayoutConstraint(item: dividerView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: -configuration.rightCardMessageDividerMarginRight),
            NSLayoutConstraint(item: dividerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.cardMessageDividerWidth),
            
            NSLayoutConstraint(item: labelView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.rightCardMessageLabelMarginLeft),
            NSLayoutConstraint(item: labelView, attribute: .top, relatedBy: .equal, toItem: dividerView, attribute: .top, multiplier: 1, constant: configuration.rightCardMessageLabelMarginTop),
            NSLayoutConstraint(item: labelView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.rightCardMessageLabelMarginBottom),
            
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
