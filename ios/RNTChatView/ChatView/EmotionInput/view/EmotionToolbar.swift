
import UIKit

class EmotionToolbar: UIView {
    
    var onIconClick: ((EmotionIcon) -> Void)!
    var onSendClick: (() -> Void)!
    
    var emotionIconList = [EmotionIcon]() {
        didSet {
            collectionView.reloadData()
        }
    }

    private var topBorder: UIView!
    private var collectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    
    private var sendButton: SimpleButton!
    
    private let cellIdentifier = "icon"

    private var configuration: EmotionPagerConfiguration!
    
    public convenience init(configuration: EmotionPagerConfiguration) {
        self.init()
        self.configuration = configuration
        setup()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        backgroundColor = configuration.toolbarBackgroundColor
        
        topBorder = UIView()
        topBorder.backgroundColor = configuration.toolbarTopBorderColor
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topBorder)
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(EmotionIconCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        addSubview(collectionView)
        
        sendButton = SimpleButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle(configuration.sendButtonText, for: .normal)
        sendButton.titleLabel?.font = configuration.sendButtonTextFont
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: configuration.sendButtonPaddingHorizontal, bottom: 0, right: configuration.sendButtonPaddingHorizontal)
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOpacity = 0.12
        sendButton.layer.shadowOffset = CGSize(width: -2, height: 0)
        sendButton.layer.shadowRadius = 3
        
        sendButton.onClick = {
            self.onSendClick()
        }

        addSubview(sendButton)

        addConstraints([
            
            NSLayoutConstraint(item: topBorder, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topBorder, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topBorder, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topBorder, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.toolbarTopBorderWidth),
            
            NSLayoutConstraint(item: sendButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .top, relatedBy: .equal, toItem: topBorder, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),

            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: sendButton, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: topBorder, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            
        ])
        
        // 隐藏垂直方向的阴影
        clipsToBounds = true
        
        disableSendButton()

    }
    
    func enableSendButton() {
        
        sendButton.isEnabled = true
        
        sendButton.setTitleColor(configuration.sendButtonTextColorEnabled, for: .normal)
        sendButton.backgroundColor = configuration.sendButtonBackgroundColorEnabledNormal
        sendButton.setBackgroundColor(configuration.sendButtonBackgroundColorEnabledPressed, for: .highlighted)
        
        sendButton.setLeftBorder(width: configuration.sendButtonLeftBorderWidth, color: configuration.sendButtonLeftBorderColorEnabled)
        
    }
    
    func disableSendButton() {
        
        sendButton.isEnabled = false
        
        sendButton.setTitleColor(configuration.sendButtonTextColorDisabled, for: .normal)
        sendButton.backgroundColor = configuration.sendButtonBackgroundColorDisabled

        sendButton.setLeftBorder(width: configuration.sendButtonLeftBorderWidth, color: configuration.sendButtonLeftBorderColorDisabled)
        
    }
    
}

extension EmotionToolbar: UICollectionViewDelegate {
    
    // 点击事件
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onIconClick(emotionIconList[indexPath.item])
    }
    
    // 按下事件
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = configuration.toolbarCellBackgroundColorPressed
    }
    
    // 松手事件
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .clear
    }
    
}

extension EmotionToolbar: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionIconList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EmotionIconCell
        cell.configuration = configuration
        
        let index = indexPath.item
        let icon = emotionIconList[index]
        
        cell.dividerView.isHidden = index == 0
        cell.imageView.image = icon.localImage
        cell.backgroundColor = icon.selected ? configuration.toolbarCellBackgroundColorPressed : .clear
        
        return cell
    }
    
}

extension EmotionToolbar: UICollectionViewDelegateFlowLayout {
    
    // 行间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 列间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: configuration.toolbarCellWidth, height: configuration.toolbarHeight)
    }
    
}

extension EmotionToolbar {
    
    class EmotionIconCell: UICollectionViewCell {
        
        var dividerView: UIView!
        var imageView: UIImageView!
        
        var configuration: EmotionPagerConfiguration! {
            willSet {
                if configuration == nil {
                    
                    dividerView = UIView()
                    dividerView.translatesAutoresizingMaskIntoConstraints = false
                    dividerView.backgroundColor = newValue.toolbarCellDividerColor
                    addSubview(dividerView)
                    
                    imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.contentMode = .center
                    addSubview(imageView)
                    
                    addConstraints([
                        
                        NSLayoutConstraint(item: dividerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: dividerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: newValue.toolbarCellDividerOffset),
                        NSLayoutConstraint(item: dividerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -newValue.toolbarCellDividerOffset),
                        NSLayoutConstraint(item: dividerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: newValue.toolbarCellDividerWidth),
                        
                        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                        
                    ])
                    
                }
            }
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

