
import UIKit

class TextMessageCell: MessageCell {
    
    var timeView = InsetLabel()
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()

    var bubbleView = InteractiveButton()
    
    var textView = InteractiveTextView()
    
    var textWidthConstraint: NSLayoutConstraint!
    var textHeightConstraint: NSLayoutConstraint!
    
    var avatarTopConstraint: NSLayoutConstraint!
    
    var spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var failureView = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create() {
        
        menuItems.append(
            UIMenuItem(
                title: configuration.menuItemCopy,
                action: #selector(InteractiveButton.onCopy)
            )
        )
        
        // 时间
        timeView.numberOfLines = 1
        timeView.textAlignment = .center
        timeView.font = configuration.timeTextFont
        timeView.textColor = configuration.timeTextColor
        timeView.backgroundColor = configuration.timeBackgroundColor
        timeView.contentInsets = UIEdgeInsetsMake(
            configuration.timePaddingVertical,
            configuration.timePaddingHorizontal,
            configuration.timePaddingVertical,
            configuration.timePaddingHorizontal
        )
        if configuration.timeBorderRadius > 0 {
            timeView.clipsToBounds = true
            timeView.layer.cornerRadius = configuration.timeBorderRadius
        }
        timeView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeView)
        
        // 头像
        if configuration.userAvatarBorderRadius > 0 {
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = configuration.userAvatarBorderRadius
        }
        if configuration.userAvatarBorderWidth > 0 {
            avatarView.layer.borderWidth = configuration.userAvatarBorderWidth
            avatarView.layer.borderColor = configuration.userAvatarBorderColor.cgColor
        }
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarView)
        
        // 昵称
        nameView.numberOfLines = 1
        nameView.lineBreakMode = .byTruncatingTail
        nameView.translatesAutoresizingMaskIntoConstraints = false

        // 气泡
        bubbleView.bind(cell: self)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)

        // 文本内容
        textView.delegate = self
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.tintColor = configuration.textMessageTintColor
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.linkTextAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue: configuration.linkTextColor
        ]
        contentView.addSubview(textView)
        
        // spinner icon
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinnerView)
        
        // failure icon
        failureView.translatesAutoresizingMaskIntoConstraints = false
        failureView.setBackgroundImage(configuration.messageFailureIconNormal, for: .normal)
        failureView.setBackgroundImage(configuration.messageFailureIconPressed, for: .highlighted)
        contentView.addSubview(failureView)
        
        addContentGesture(view: bubbleView)
        addClickHandler(view: avatarView, selector: #selector(onUserAvatarClick))
        addClickHandler(view: failureView, selector: #selector(onFailureClick))
        
        
        topConstraint = NSLayoutConstraint(item: timeView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        textWidthConstraint = NSLayoutConstraint(item: textView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        textHeightConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        avatarTopConstraint = NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .equal, toItem: timeView, attribute: .bottom, multiplier: 1, constant: 0)
        avatarTopConstraint.priority = .defaultLow
        
        contentView.addConstraints([
            topConstraint,
            bottomConstraint,
            textWidthConstraint,
            textHeightConstraint,
            avatarTopConstraint,
        ])
        
    }
    
    override func update() {
        
        configuration.loadImage(imageView: avatarView, url: message.user.avatar)

        nameView.text = message.user.name
        nameView.sizeToFit()

        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        showTimeView(timeView: timeView, time: message.time, avatarView: avatarView, avatarTopConstraint: avatarTopConstraint)
        
    }
    
}

extension TextMessageCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate.messageListDidClickLink(link: URL.absoluteString)
        return false
    }

}
