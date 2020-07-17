
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
        addTimeView(timeView)
        
        // 头像
        addAvatarView(avatarView)
        
        // 昵称
        addNameView(nameView)

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
        addSpinnerView(spinnerView)
        
        // failure icon
        addFailureView(failureView)
        
        addContentGesture(view: bubbleView)
        
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
        
        showTimeView(timeView: timeView, time: message.time, avatarTopConstraint: avatarTopConstraint)
        
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
