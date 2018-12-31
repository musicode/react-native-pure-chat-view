
import UIKit

class ImageMessageCell: MessageCell {
    
    var timeView = InsetLabel()
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()
    
    // imageView 被占用了
    var photoView = InteractiveImageView()

    var photoWidthConstraint: NSLayoutConstraint!
    var photoHeightConstraint: NSLayoutConstraint!
    var avatarTopConstraint: NSLayoutConstraint!
    
    var spinnerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    var failureView = UIButton()
    
    override var menuItems: [UIMenuItem] {
        get {
            return createMenuItems([
                UIMenuItem(
                    title: configuration.menuItemShare,
                    action: #selector(InteractiveImageView.onShare)
                )
            ])
        }
    }

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
        
        // 图片
        if configuration.imageMessageBorderRadius > 0 {
            photoView.clipsToBounds = true
            photoView.layer.cornerRadius = configuration.imageMessageBorderRadius
        }
        if configuration.imageMessageBorderWidth > 0 {
            photoView.layer.borderWidth = configuration.imageMessageBorderWidth
            photoView.layer.borderColor = configuration.imageMessageBorderColor.cgColor
        }
        photoView.bind(cell: self)
        photoView.contentMode = .scaleAspectFill
        photoView.backgroundColor = configuration.imageMessageBackgroundColor
        photoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoView)
        
        // spinner icon
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinnerView)
        
        // failure icon
        failureView.translatesAutoresizingMaskIntoConstraints = false
        failureView.setBackgroundImage(configuration.messageFailureIconNormal, for: .normal)
        failureView.setBackgroundImage(configuration.messageFailureIconPressed, for: .highlighted)
        contentView.addSubview(failureView)
        
        addContentGesture(view: photoView)
        addClickHandler(view: avatarView, selector: #selector(onUserAvatarClick))
        addClickHandler(view: failureView, selector: #selector(onFailureClick))
        
        topConstraint = NSLayoutConstraint(item: timeView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: photoView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        photoWidthConstraint = NSLayoutConstraint(item: photoView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        photoHeightConstraint = NSLayoutConstraint(item: photoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        avatarTopConstraint = NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .equal, toItem: timeView, attribute: .bottom, multiplier: 1, constant: 0)
        avatarTopConstraint.priority = .defaultLow
        
        contentView.addConstraints([
            topConstraint,
            bottomConstraint,
            photoWidthConstraint,
            photoHeightConstraint,
            avatarTopConstraint,
        ])
        
    }
    
    override func update() {
        
        let imageMessage = message as! ImageMessage
        
        configuration.loadImage(
            imageView: avatarView,
            url: message.user.avatar,
            width: configuration.userAvatarWidth,
            height: configuration.userAvatarHeight
        )
        
        nameView.text = message.user.name
        nameView.sizeToFit()
        
        configuration.loadImage(
            imageView: photoView,
            url: imageMessage.url,
            width: CGFloat(integerLiteral: imageMessage.width),
            height: CGFloat(integerLiteral: imageMessage.height)
        )
        
        updateImageSize(width: imageMessage.width, height: imageMessage.height, widthConstraint: photoWidthConstraint, heightConstraint: photoHeightConstraint)
        
        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        showTimeView(timeView: timeView, time: message.time, avatarView: avatarView, avatarTopConstraint: avatarTopConstraint)
        
    }
    
}
