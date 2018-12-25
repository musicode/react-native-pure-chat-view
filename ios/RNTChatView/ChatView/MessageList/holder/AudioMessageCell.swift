
import UIKit

class AudioMessageCell: MessageCell {
    
    var timeView = InsetLabel()
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()
    
    var bubbleView = InteractiveButton()
    
    var animationView = UIImageView()
    
    var durationView = UILabel()
    
    var unitView = UILabel()
    
    var bubbleWidthConstraint: NSLayoutConstraint!
    var avatarTopConstraint: NSLayoutConstraint!
    
    var loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var failureView = UIButton()

    override func create() {
        
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
        
        // 声波
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animationDuration = 1
        animationView.animationRepeatCount = 0
        animationView.isUserInteractionEnabled = false
        contentView.addSubview(animationView)
        
        // 时长
        durationView.font = configuration.leftAudioMessageDurationTextFont
        durationView.textColor = configuration.leftAudioMessageDurationTextColor
        durationView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationView)
        
        // 单位
        unitView.text = "''"
        unitView.font = configuration.leftAudioMessageUnitTextFont
        unitView.textColor = configuration.leftAudioMessageUnitTextColor
        unitView.translatesAutoresizingMaskIntoConstraints = false
        unitView.sizeToFit()
        contentView.addSubview(unitView)
        
        // loading icon
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadingView)
        
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
        bottomConstraint = NSLayoutConstraint(item: bubbleView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        bubbleWidthConstraint = NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        avatarTopConstraint = NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .equal, toItem: timeView, attribute: .bottom, multiplier: 1, constant: 0)
        avatarTopConstraint.priority = .defaultLow
        
        contentView.addConstraints([
            topConstraint,
            bottomConstraint,
            bubbleWidthConstraint,
            avatarTopConstraint,
        ])
        
        configuration.audioPlayer.addListener(listener: self)
        
    }
    
    override func update() {
        
        let audioMessage = message as! AudioMessage

        configuration.loadImage(imageView: avatarView, url: message.user.avatar)
        
        nameView.text = message.user.name
        nameView.sizeToFit()
        
        updateContentSize(duration: audioMessage.duration)
        
        if message.status == .sendSuccess {
            durationView.text = "\(audioMessage.duration)"
            durationView.sizeToFit()
            
            durationView.isHidden = false
            unitView.isHidden = false
        }
        else {
            durationView.isHidden = true
            unitView.isHidden = true
        }

        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        showTimeView(timeView: timeView, time: message.time, avatarView: avatarView, avatarTopConstraint: avatarTopConstraint)
        
        // 把动画状态同步回来
        if configuration.audioPlayer.isPlaying(id: message.id) {
            playAnimation()
        }
        else {
            stopAnimation()
        }
        
    }
    
    private func updateContentSize(duration: Int) {
        
        let durationRatio = Float(duration) / configuration.audioMessageMaxDuration
        
        let maxWidth = configuration.audioMessageMaxRatio * getContentMaxWidth()
        let minWidth = configuration.audioMessageBubbleMinWidth
        
        var bubbleWidth = maxWidth * CGFloat(durationRatio)
        
        if bubbleWidth > maxWidth {
            bubbleWidth = maxWidth
        }
        else if bubbleWidth < minWidth {
            bubbleWidth = minWidth
        }
        
        if bubbleWidth != bubbleWidthConstraint.constant {
            bubbleWidthConstraint.constant = bubbleWidth
            setNeedsLayout()
        }
        
    }
    
    private func playAnimation() {
        animationView.startAnimating()
    }
    
    private func stopAnimation() {
        animationView.stopAnimating()
    }
    
    private func showLoading() {
        loadingView.isHidden = false
        animationView.isHidden = true
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
        animationView.isHidden = false
    }
    
    @objc override func onContentClick() {
        let player = configuration.audioPlayer
        if player.isPlaying(id: message.id) {
            player.stop()
        }
        else {
            let audioMessage = message as! AudioMessage
            player.play(id: audioMessage.id, url: audioMessage.url)
        }
        delegate.messageListDidClickContent(message: message)
    }
    
}

extension AudioMessageCell: AudioPlayerDelegate {
    
    func audioPlayerDidLoad(id: String) {
        if id == message.id {
            showLoading()
        }
    }
    
    func audioPlayerDidPlay(id: String) {
        if id == message.id {
            hideLoading()
            playAnimation()
        }
    }
    
    func audioPlayerDidStop(id: String) {
        if id == message.id {
            hideLoading()
            stopAnimation()
        }
    }
    
}

