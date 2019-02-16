
import UIKit

class TextMessageCell: MessageCell {
    
    var timeView = InsetLabel()
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()

    var bubbleView = InteractiveButton()
    
    var textView = LinkTextView()
    
    var textWidthConstraint: NSLayoutConstraint!
    var textHeightConstraint: NSLayoutConstraint!
    
    var avatarTopConstraint: NSLayoutConstraint!
    
    var spinnerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    var failureView = UIButton()

    override func create() {
        
        // 时间
        timeView.numberOfLines = 1
        timeView.textAlignment = .center
        timeView.font = configuration.timeTextFont
        timeView.textColor = configuration.timeTextColor
        timeView.backgroundColor = configuration.timeBackgroundColor
        timeView.contentInsets = UIEdgeInsets(
            top: configuration.timePaddingVertical,
            left: configuration.timePaddingHorizontal,
            bottom: configuration.timePaddingVertical,
            right: configuration.timePaddingHorizontal
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
        avatarView.backgroundColor = configuration.userAvatarBackgroundColor
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarView)
        
        // 昵称
        nameView.numberOfLines = 1
        nameView.lineBreakMode = .byTruncatingTail
        nameView.translatesAutoresizingMaskIntoConstraints = false

        // 气泡
        bubbleView.cell = self
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)

        // 文本内容
        textView.delegate = self
        textView.isSelectable = true
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.tintColor = configuration.textMessageTintColor
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: configuration.linkTextColor
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
        
        configuration.loadImage(
            imageView: avatarView,
            url: message.user.avatar,
            width: configuration.userAvatarWidth,
            height: configuration.userAvatarHeight
        )

        nameView.text = message.user.name
        nameView.sizeToFit()

        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        showTimeView(timeView: timeView, time: message.time, avatarView: avatarView, avatarTopConstraint: avatarTopConstraint)
        
    }
    
    override func createMenuItems() -> [UIMenuItem] {
        
        var items = [
            UIMenuItem(
                title: configuration.menuItemCopy,
                action: #selector(InteractiveButton.onCopy)
            )
        ]
        if message.canShare {
            items.append(
                UIMenuItem(
                    title: configuration.menuItemShare,
                    action: #selector(InteractiveButton.onShare)
                )
            )
        }
        if message.canRecall {
            items.append(
                UIMenuItem(
                    title: configuration.menuItemRecall,
                    action: #selector(InteractiveButton.onRecall)
                )
            )
        }
        if message.canDelete {
            items.append(
                UIMenuItem(
                    title: configuration.menuItemDelete,
                    action: #selector(InteractiveButton.onDelete)
                )
            )
        }
        
        bubbleView.actions = items.map {
            return $0.action
        }
        
        return items
        
    }
    
}

extension TextMessageCell: UITextViewDelegate {
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return textViewShouldInteractWithURL(URL: URL)
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return textViewShouldInteractWithURL(URL: URL)
    }

    func textViewShouldInteractWithURL(URL: URL) -> Bool {
        delegate.messageListDidClickLink(link: URL.absoluteString)
        return false
    }

}
