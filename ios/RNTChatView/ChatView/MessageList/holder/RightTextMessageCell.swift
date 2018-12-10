
import UIKit

class RightTextMessageCell: TextMessageCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create() {
        
        super.create()
        
        bubbleView.setBackgroundImage(configuration.rightTextMessageBubbleImageNormal, for: .normal)
        bubbleView.setBackgroundImage(configuration.rightTextMessageBubbleImagePressed, for: .selected)
        bubbleView.setBackgroundImage(configuration.rightTextMessageBubbleImagePressed, for: .highlighted)
        
        textView.textContainerInset = UIEdgeInsetsMake(
            configuration.rightTextMessagePaddingTop,
            configuration.rightTextMessagePaddingLeft,
            configuration.rightTextMessagePaddingBottom,
            configuration.rightTextMessagePaddingRight
        )
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
            
            // 用 textView 确定气泡尺寸
            NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: avatarView, attribute: .left, multiplier: 1, constant: -configuration.rightTextMessageMarginRight),
            
            // textview 尺寸确定了之后，气泡依附它
            NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleView, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleView, attribute: .left, relatedBy: .equal, toItem: textView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleView, attribute: .right, relatedBy: .equal, toItem: textView, attribute: .right, multiplier: 1, constant: 0),
            
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
                
                NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1, constant: configuration.rightUserNameMarginBottom),

            ])
            
        }
        else {
            contentView.addConstraints([

                NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),

            ])
        }
        
    }
    
    override func update() {
        
        super.update()
        
        let textMessage = message as! TextMessage
        
        let attributedString = formatLinks(
            text: textMessage.text,
            font: configuration.rightTextMessageTextFont,
            color: configuration.rightTextMessageTextColor,
            lineSpacing: configuration.rightTextMessageLineSpacing
        )
        
        configuration.formatText(font: configuration.rightTextMessageTextFont, text: attributedString)
        
        textView.attributedText = attributedString
        
        updateTextSize(textView: textView, minWidth: configuration.rightTextMessageMinWidth, widthConstraint: textWidthConstraint, heightConstraint: textHeightConstraint)
        
    }

}
