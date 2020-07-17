
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
    
    override func create() {
        
        copySelector = #selector(InteractiveImageView.onCopy)
        shareSelector = #selector(InteractiveImageView.onShare)
        recallSelector = #selector(InteractiveImageView.onRecall)
        deleteSelector = #selector(InteractiveImageView.onDelete)
        
        // 时间
        addTimeView(timeView)
        
        // 头像
        addAvatarView(avatarView)
        
        // 昵称
        addNameView(nameView)
        
        // 图片
        if configuration.imageMessageBorderRadius > 0 {
            photoView.clipsToBounds = true
            photoView.layer.cornerRadius = configuration.imageMessageBorderRadius
        }
        if configuration.imageMessageBorderWidth > 0 {
            photoView.layer.borderWidth = configuration.imageMessageBorderWidth
            photoView.layer.borderColor = configuration.imageMessageBorderColor.cgColor
        }
        photoView.cell = self
        photoView.contentMode = .scaleAspectFill
        photoView.backgroundColor = configuration.imageMessageBackgroundColor
        photoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoView)
        
        // spinner icon
        addSpinnerView(spinnerView)
        
        // failure icon
        addFailureView(failureView)
        
        addContentGesture(view: photoView)
        
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
        
        showTimeView(timeView: timeView, time: message.time, avatarTopConstraint: avatarTopConstraint)
        
    }
    
}
