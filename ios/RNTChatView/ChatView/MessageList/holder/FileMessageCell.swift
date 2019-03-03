
import UIKit

class FileMessageCell: MessageCell {
    
    var timeView = InsetLabel()
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()
    
    var bubbleView = InteractiveButton()
    
    var iconView = UIImageView()
    var titleView = UILabel()
    var descView = UILabel()
    
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
        
        // 文件类型图标
        if configuration.fileMessageIconBorderRadius > 0 {
            iconView.clipsToBounds = true
            iconView.layer.cornerRadius = configuration.fileMessageIconBorderRadius
        }
        iconView.backgroundColor = configuration.fileMessageIconBackgroundColor
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)
        
        // 文件名称
        titleView.numberOfLines = 2
        titleView.lineBreakMode = .byTruncatingMiddle
        titleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleView)
        
        // 描述
        descView.numberOfLines = 1
        descView.lineBreakMode = .byTruncatingTail
        descView.textAlignment = .left
        descView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descView)
        
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
        
        let fileMessage = message as! FileMessage
        
        configuration.loadImage(
            imageView: avatarView,
            url: message.user.avatar,
            width: configuration.userAvatarWidth,
            height: configuration.userAvatarHeight
        )
        
        nameView.text = message.user.name
        nameView.sizeToFit()
        
        switch fileMessage.icon {
        case .word:
            iconView.image = configuration.fileMessageIconWord
            break
        case .excel:
            iconView.image = configuration.fileMessageIconExcel
            break
        case .ppt:
            iconView.image = configuration.fileMessageIconPpt
            break
        case .pdf:
            iconView.image = configuration.fileMessageIconPdf
            break
        default:
            iconView.image = configuration.fileMessageIconTxt
            break
        }
        
        // 撑起高度
        titleView.text = fileMessage.title != "" ? fileMessage.title : " "
        titleView.sizeToFit()
        
        descView.text = fileMessage.desc
        descView.sizeToFit()
        
        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        showTimeView(timeView: timeView, time: message.time, avatarView: avatarView, avatarTopConstraint: avatarTopConstraint)
        
    }

}
