
import UIKit

class EmotionToolbar: UIView {
    
    var onIconClick: ((EmotionIcon) -> Void)!
    var onSendClick: (() -> Void)!
    
    var emotionIconList = [EmotionIcon]() {
        didSet {
            collectionView.reloadData()
        }
    }

    private lazy var topBorder: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = configuration.toolbarTopBorderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.toolbarTopBorderWidth),
        ])
        
        return view
        
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let view = UICollectionViewFlowLayout()
        
        view.scrollDirection = .horizontal
        
        return view
        
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let view = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        view.register(EmotionIconCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: sendButton, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topBorder, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        return view
        
    }()

    private lazy var sendButton: SimpleButton = {
        
        let view = SimpleButton()
        
        view.backgroundColor = configuration.sendButtonBackgroundColorEnabledNormal
        view.backgroundColorPressed = configuration.sendButtonBackgroundColorEnabledPressed
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(configuration.sendButtonTitle, for: .normal)
        view.titleLabel?.font = configuration.sendButtonTextFont
        view.contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: configuration.sendButtonPaddingHorizontal,
            bottom: 0,
            right: configuration.sendButtonPaddingHorizontal
        )
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: -2, height: 0)
        view.layer.shadowRadius = 3
        
        view.onClick = {
            self.onSendClick()
        }
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topBorder, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        // 隐藏垂直方向的阴影
        clipsToBounds = true
        
        return view
        
    }()
    
    private let cellIdentifier = "icon"

    private var configuration: EmotionPagerConfiguration!
    
    public convenience init(configuration: EmotionPagerConfiguration) {
        self.init()
        self.configuration = configuration
        backgroundColor = configuration.toolbarBackgroundColor
        disableSendButton()
    }

    func enableSendButton() {
        
        sendButton.isEnabled = true
        
        sendButton.backgroundColor = configuration.sendButtonBackgroundColorEnabledNormal
        sendButton.setTitleColor(configuration.sendButtonTextColorEnabled, for: .normal)

        sendButton.setLeftBorder(width: configuration.sendButtonLeftBorderWidth, color: configuration.sendButtonLeftBorderColorEnabled)
        
    }
    
    func disableSendButton() {
        
        sendButton.isEnabled = false
        
        sendButton.backgroundColor = configuration.sendButtonBackgroundColorDisabled
        sendButton.setTitleColor(configuration.sendButtonTextColorDisabled, for: .normal)

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
        
        lazy var dividerView: UIView = {
        
            let view = UIView()
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = configuration.toolbarCellDividerColor
            
            contentView.addSubview(view)
            
            contentView.addConstraints([
                
                NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: configuration.toolbarCellDividerOffset),
                NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.toolbarCellDividerOffset),
                NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.toolbarCellDividerWidth),
                
            ])
            
            return view
            
        }()
        
        lazy var imageView: UIImageView = {
            
            let view = UIImageView()
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.contentMode = .center
            
            contentView.addSubview(view)
            
            contentView.addConstraints([
                NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            ])
            
            return view
            
        }()
        
        var configuration: EmotionPagerConfiguration!
        
    }
    
}

