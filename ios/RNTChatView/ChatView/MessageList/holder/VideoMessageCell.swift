
import UIKit

class VideoMessageCell: MessageCell {
    
    var timeView = InsetLabel()
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()
    
    var thumbnailView = InteractiveImageView()
    
    var thumbnailWidthConstraint: NSLayoutConstraint!
    var thumbnailHeightConstraint: NSLayoutConstraint!
    var avatarTopConstraint: NSLayoutConstraint!
    
    var playView = UIImageView()
    
    var durationView = UILabel()
    
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
        
        // 视频缩略图
        if configuration.videoMessageBorderRadius > 0 {
            thumbnailView.clipsToBounds = true
            thumbnailView.layer.cornerRadius = configuration.videoMessageBorderRadius
        }
        if configuration.videoMessageBorderWidth > 0 {
            thumbnailView.layer.borderWidth = configuration.videoMessageBorderWidth
            thumbnailView.layer.borderColor = configuration.videoMessageBorderColor.cgColor
        }
        thumbnailView.cell = self
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.backgroundColor = configuration.videoMessageBackgroundColor
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailView)
        
        // 播放按钮
        playView.image = configuration.videoMessagePlayImage
        playView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playView)
        
        // 视频时长
        durationView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationView)
        
        // spinner icon
        addSpinnerView(spinnerView)
        
        // failure icon
        addFailureView(failureView)
        
        addContentGesture(view: thumbnailView)
        
        topConstraint = NSLayoutConstraint(item: timeView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: thumbnailView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        thumbnailWidthConstraint = NSLayoutConstraint(item: thumbnailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        thumbnailHeightConstraint = NSLayoutConstraint(item: thumbnailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        avatarTopConstraint = NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .equal, toItem: timeView, attribute: .bottom, multiplier: 1, constant: 0)
        avatarTopConstraint.priority = .defaultLow
        
        contentView.addConstraints([
            topConstraint,
            bottomConstraint,
            thumbnailWidthConstraint,
            thumbnailHeightConstraint,
            avatarTopConstraint,
        ])
        
    }
    
    override func update() {
        
        let videoMessage = message as! VideoMessage
        
        configuration.loadImage(
            imageView: avatarView,
            url: message.user.avatar,
            width: configuration.userAvatarWidth,
            height: configuration.userAvatarHeight
        )
        
        nameView.text = message.user.name
        nameView.sizeToFit()
        
        durationView.text = formatDuration(videoMessage.duration)
        durationView.sizeToFit()
        
        configuration.loadImage(
            imageView: thumbnailView,
            url: videoMessage.thumbnail,
            width: CGFloat(integerLiteral: videoMessage.width),
            height: CGFloat(integerLiteral: videoMessage.height)
        )
        
        updateImageSize(width: videoMessage.width, height: videoMessage.height, widthConstraint: thumbnailWidthConstraint, heightConstraint: thumbnailHeightConstraint)

        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        showTimeView(timeView: timeView, time: message.time, avatarView: avatarView, avatarTopConstraint: avatarTopConstraint)
        
    }
    
    private func formatDuration(_ duration: Int) -> String {
    
        let MINUTE = 60
        let HOUR = MINUTE * 60
        
        var seconds = duration
        let hours = seconds / HOUR
        
        seconds -= hours * HOUR
        
        let minutes = seconds / MINUTE
        
        seconds -= minutes * MINUTE
        
        var result = lpad(minutes) + ":" + lpad(seconds)
        
        if hours > 0 {
            result = lpad(hours) + ":" + result
        }
        
        return result
    
    }
    
    private func lpad(_ value: Int) -> String {
        if value > 9 {
            return "\(value)"
        }
        return "0\(value)"
    }
    
}
