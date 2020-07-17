
import UIKit

class CardMessageCell: MessageCell {
    
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
        
        // 缩略图
        if configuration.cardMessageThumbnailBorderRadius > 0 {
            thumbnailView.clipsToBounds = true
            thumbnailView.layer.cornerRadius = configuration.cardMessageThumbnailBorderRadius
        }
        thumbnailView.backgroundColor = configuration.cardMessageThumbnailBackgroundColor
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailView)
        
        // 标题
        titleView.numberOfLines = 1
        titleView.lineBreakMode = .byTruncatingTail
        titleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleView)
        
        // 描述
        descView.numberOfLines = 1
        descView.lineBreakMode = .byTruncatingTail
        descView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descView)
        
        // 分割线
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dividerView)
        
        // 类型
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
        
        let cardMessage = message as! CardMessage
        
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
            url: cardMessage.thumbnail,
            width: configuration.cardMessageThumbnailWidth,
            height: configuration.cardMessageThumbnailHeight
        )
        
        // 撑起高度
        titleView.text = cardMessage.title != "" ? cardMessage.title : " "
        titleView.sizeToFit()
        
        descView.text = cardMessage.desc
        descView.sizeToFit()
        
        labelView.text = cardMessage.label
        labelView.sizeToFit()
        
        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        showTimeView(timeView: timeView, time: message.time, avatarTopConstraint: avatarTopConstraint)
        
    }

}
