
import UIKit

class LeftTextMessageCell: TextMessageCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create() {
        
        super.create()
        
        bubbleView.image = configuration.leftTextMessageBubbleImage
        
        textView.textContainerInset = UIEdgeInsetsMake(
            configuration.leftTextMessagePaddingTop,
            configuration.leftTextMessagePaddingLeft,
            configuration.leftTextMessagePaddingBottom,
            configuration.leftTextMessagePaddingRight
        )
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: timeView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: avatarView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.messagePaddingHorizontal),
            NSLayoutConstraint(item: avatarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.userAvatarWidth),
            NSLayoutConstraint(item: avatarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),

            // 用 textView 确定气泡尺寸
            NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: avatarView, attribute: .right, multiplier: 1, constant: configuration.leftTextMessageMarginLeft),
            
            // textview 尺寸确定了之后，气泡依附它
            NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleView, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleView, attribute: .left, relatedBy: .equal, toItem: textView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleView, attribute: .right, relatedBy: .equal, toItem: textView, attribute: .right, multiplier: 1, constant: 0),
            
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

                NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1, constant: configuration.leftUserNameMarginBottom),

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
            font: configuration.leftTextMessageTextFont,
            color: configuration.leftTextMessageTextColor,
            lineSpacing: configuration.leftTextMessageLineSpacing
        )
        
        configuration.formatText(textView: textView, text: attributedString)
        
        textView.attributedText = attributedString
        
        updateTextSize(textView: textView, minWidth: configuration.leftTextMessageMinWidth, widthConstraint: textWidthConstraint, heightConstraint: textHeightConstraint)
        
    }
    
}
