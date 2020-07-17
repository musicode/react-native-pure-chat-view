
import UIKit

class PostMessageCell: MessageCell {
    
    var timeView = InsetLabel()
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()
    
    var bubbleView = InteractiveButton()
    
    var thumbnailView = UIImageView()
    var titleView = UILabel()
    var descView = UILabel()
    var dividerView = UIView()
    var labelView = UILabel()
    
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
        
        // 标题
        titleView.numberOfLines = 2
        titleView.lineBreakMode = .byTruncatingTail
        titleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleView)
        
        // 描述
        descView.numberOfLines = 3
        descView.lineBreakMode = .byTruncatingTail
        descView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descView)
        
        // 缩略图
        if configuration.postMessageThumbnailBorderRadius > 0 {
            thumbnailView.clipsToBounds = true
            thumbnailView.layer.cornerRadius = configuration.postMessageThumbnailBorderRadius
        }
        thumbnailView.backgroundColor = configuration.postMessageThumbnailBackgroundColor
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailView)
        
        // 分割线
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dividerView)
        
        labelView.numberOfLines = 1
        labelView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelView)
        
        // spinner icon
        addSpinnerView(spinnerView)
        
        // failure icon
        addFailureView(failureView)
        
        addContentGesture(view: bubbleView)
        
        topConstraint = NSLayoutConstraint(item: timeView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: bubbleView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        avatarTopConstraint = NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .equal, toItem: timeView, attribute: .bottom, multiplier: 1, constant: 0)
        avatarTopConstraint.priority = .defaultLow
        
        contentView.addConstraints([
            topConstraint,
            bottomConstraint,
            avatarTopConstraint,
        ])
        
    }
    
    override func update() {
        
        let postMessage = message as! PostMessage
        
        configuration.loadImage(
            imageView: avatarView,
            url: message.user.avatar,
            width: configuration.userAvatarWidth,
            height: configuration.userAvatarHeight
        )
        
        nameView.text = message.user.name
        nameView.sizeToFit()
        
        configuration.loadImage(
            imageView: thumbnailView,
            url: postMessage.thumbnail,
            width: configuration.postMessageThumbnailWidth,
            height: configuration.postMessageThumbnailHeight
        )
        
        titleView.text = postMessage.title
        titleView.sizeToFit()
        
        descView.text = postMessage.desc
        descView.sizeToFit()
        
        labelView.text = postMessage.label
        labelView.sizeToFit()
        
        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        showTimeView(timeView: timeView, time: message.time, avatarTopConstraint: avatarTopConstraint)
        
    }
    
}
