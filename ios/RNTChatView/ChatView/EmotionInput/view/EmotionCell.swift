
import UIKit

class EmotionCell: UIView {
    
    //
    // MARK: - 界面元素
    //
    
    // 显示表情图片
    var emotionView: UIImageView!
    
    // 显示表情文字
    var nameView: UILabel!
    
    // 显示删除按钮
    var deleteView: UIImageView!
    
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
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化界面元素和约束
    func setup() {
        
        emotionView = UIImageView(frame: CGRect.zero)
        emotionView.translatesAutoresizingMaskIntoConstraints = false
        emotionView.contentMode = UIViewContentMode.scaleAspectFit
        emotionView.isHidden = true
        addSubview(emotionView)
        
        nameView = UILabel()
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameView.font = configuration.emotionNameTextFont
        nameView.textColor = configuration.emotionNameTextColor
        nameView.numberOfLines = 1
        nameView.lineBreakMode = .byTruncatingTail
        nameView.textAlignment = .center
        nameView.isHidden = true
        addSubview(nameView)
        
        deleteView = UIImageView(frame: CGRect.zero)
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        deleteView.isHidden = true
        addSubview(deleteView)

        emotionTopConstraint = NSLayoutConstraint(item: emotionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        emotionCenterYConstraint = NSLayoutConstraint(item: emotionView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        emotionWidthConstraint = NSLayoutConstraint(item: emotionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        
        emotionHeightConstraint = NSLayoutConstraint(item: emotionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        
        addConstraints([
            NSLayoutConstraint(item: emotionView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            emotionWidthConstraint,
            emotionHeightConstraint,
            
            NSLayoutConstraint(item: nameView, attribute: .top, relatedBy: .equal, toItem: emotionView, attribute: .bottom, multiplier: 1, constant: configuration.emotionNameMarginTop),
            NSLayoutConstraint(item: nameView, attribute: .left, relatedBy: .equal, toItem: emotionView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameView, attribute: .right, relatedBy: .equal, toItem: emotionView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: deleteView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: deleteView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
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
