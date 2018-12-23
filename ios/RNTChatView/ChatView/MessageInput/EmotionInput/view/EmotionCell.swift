
import UIKit

class EmotionCell: UIView {
    
    //
    // MARK: - 界面元素
    //
    
    // 显示表情图片
    lazy var emotionView: UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        
        addSubview(view)
        
        emotionTopConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        emotionCenterYConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        emotionWidthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        
        emotionHeightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            emotionWidthConstraint,
            emotionHeightConstraint,
        ])
        
        return view
        
    }()
    
    // 显示表情文字
    lazy var nameView: UILabel = {
        
        let view = UILabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = configuration.emotionNameTextFont
        view.textColor = configuration.emotionNameTextColor
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.textAlignment = .center
        view.isHidden = true
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: emotionView, attribute: .bottom, multiplier: 1, constant: configuration.emotionNameMarginTop),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: emotionView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: emotionView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
        return view
        
    }()
    
    // 显示删除按钮
    lazy var deleteView: UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        return view
        
    }()
    
    //
    // MARK: - 表情数据
    //
    
    var emotion: Emotion?
    
    //
    // MARK: - 布局约束
    //
    
    private var emotionTopConstraint: NSLayoutConstraint!
    private var emotionCenterYConstraint: NSLayoutConstraint!
    private var emotionWidthConstraint: NSLayoutConstraint!
    private var emotionHeightConstraint: NSLayoutConstraint!
    
    private var configuration: EmotionPagerConfiguration!
    
    public convenience init(configuration: EmotionPagerConfiguration) {
        self.init()
        self.configuration = configuration
    }

    func showEmotion(emotion: Emotion, emotionWidth: Int, emotionHeight: Int) {

        var hasEmotion = false
        
        if let localImage = emotion.localImage {
            hasEmotion = true
            emotionView.image = localImage
        }
        else if emotion.remoteImage != "" {
            hasEmotion = true
            configuration.loadImage(imageView: emotionView, url: emotion.remoteImage)
        }
        
        if hasEmotion {
            
            self.emotion = emotion
            
            showEmotionView(emotionWidth: emotionWidth, emotionHeight: emotionHeight)
            
            hideDeleteView()
            
            if emotion.name != "" {
                nameView.text = emotion.name
                showNameView()
            }
            else {
                hideNameView()
            }
            
        }
        else {
            showNothing()
        }
        
    }
    
    func showDelete(image: UIImage) {
        hideEmotionView()
        hideNameView()
        showDeleteView(image: image)
    }
    
    func showNothing() {
        hideEmotionView()
        hideNameView()
        hideDeleteView()
    }
    
    func hasContent() -> Bool {
        return !emotionView.isHidden || !deleteView.isHidden
    }
    
}

extension EmotionCell {
    
    private func showEmotionView(emotionWidth: Int, emotionHeight: Int) {
        
        emotionView.isHidden = false
        
        emotionWidthConstraint.constant = CGFloat(emotionWidth)
        emotionHeightConstraint.constant = CGFloat(emotionHeight)
        
        setNeedsLayout()
        
    }
    
    private func hideEmotionView() {
        
        emotion = nil
        
        emotionView.isHidden = true
        
    }
    
    private func showNameView() {
        
        nameView.isHidden = false
        
        addConstraint(emotionTopConstraint)
        removeConstraint(emotionCenterYConstraint)
        
    }
    
    private func hideNameView() {
        
        nameView.isHidden = true
        
        addConstraint(emotionCenterYConstraint)
        removeConstraint(emotionTopConstraint)
        
    }
    
    private func showDeleteView(image: UIImage) {
        
        deleteView.image = image
        deleteView.isHidden = false
        
    }
    
    private func hideDeleteView() {
        
        deleteView.isHidden = true
        
    }
    
}
