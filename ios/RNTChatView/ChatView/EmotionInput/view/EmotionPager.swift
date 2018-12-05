
import UIKit

public class EmotionPager: UIView {
    
    public var emotionSetList = [EmotionSet]() {
        didSet {
            emotionSetIndex = 0
            collectionView.reloadData()
        }
    }
    
    public var emotionSetIndex = 0 {
        didSet {
            
            if emotionSetList.count > emotionSetIndex {
                let emotionSet = emotionSetList[ emotionSetIndex ]
                if emotionSet.hasIndicator {
                    showIndicatorView()
                    indicatorView.index = 0
                    indicatorView.count = emotionSet.emotionPageList.count
                    indicatorView.setNeedsLayout()
                    indicatorView.setNeedsDisplay()
                }
                else {
                    hideIndicatorView()
                }
            }
            else {
                hideIndicatorView()
            }
            
            var index = 0
            toolbarView.emotionIconList = emotionSetList.map { emotionSet in
                
                let currentIndex = index
                index = index + 1
                
                return EmotionIcon(index: currentIndex, localImage: emotionSet.localImage, selected: currentIndex == emotionSetIndex)
                
            }
            
        }
    }
    
    public var isSendButtonEnabled = false {
        didSet {
            if isSendButtonEnabled {
                toolbarView.enableSendButton()
            }
            else {
                toolbarView.disableSendButton()
            }
        }
    }
    
    public var onEmotionClick: ((Emotion) -> Void)?
    public var onDeleteClick: (() -> Void)?
    public var onSendClick: (() -> Void)?
    
    

    private var collectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    
    private var indicatorView: DotIndicator!
    private var toolbarView: EmotionToolbar!
    
    private let cellIdentifier = "grid"
    
    private var collectionBottomConstraint: NSLayoutConstraint!
    private var indicatorBottomConstraint: NSLayoutConstraint!
    
    
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
    
    private func setup() {
        
        backgroundColor = configuration.backgroundColor
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        collectionView.register(EmotionGrid.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        addSubview(collectionView)
        
        indicatorView = DotIndicator()
        indicatorView.color = configuration.indicatorColorNormal
        indicatorView.radius = configuration.indicatorRadiusNormal
        indicatorView.activeColor = configuration.indicatorColorActive
        indicatorView.activeRadius = configuration.indicatorRadiusActive
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.isHidden = true
        
        addSubview(indicatorView)
        
        toolbarView = EmotionToolbar(configuration: configuration)
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.onIconClick = { icon in
            var count = 0
            for i in 0..<self.emotionSetList.count {
                if i == icon.index {
                    self.collectionView.scrollToItem(at: IndexPath(item: count, section: 0), at: .centeredHorizontally, animated: false)
                    self.emotionSetIndex = i
                    break
                }
                count += self.emotionSetList[i].emotionPageList.count
            }
        }
        toolbarView.onSendClick = {
            self.onSendClick?()
        }
        
        addSubview(toolbarView)

        collectionBottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: indicatorView, attribute: .top, multiplier: 1, constant: 0)
        indicatorBottomConstraint = NSLayoutConstraint(item: indicatorView, attribute: .bottom, relatedBy: .equal, toItem: toolbarView, attribute: .top, multiplier: 1, constant: 0)
        
        addConstraints([
            
            NSLayoutConstraint(item: toolbarView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolbarView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolbarView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolbarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.toolbarHeight + configuration.toolbarTopBorderWidth),
            
            NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            indicatorBottomConstraint,
            
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            collectionBottomConstraint,
            
        ])
        
    }
    
}


extension EmotionPager: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        for set in emotionSetList {
            count += set.emotionPageList.count
        }
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EmotionGrid

        checkRange(index: indexPath.item) {
            cell.emotionPage = emotionSetList[$0].emotionPageList[$1]
        }
        
        cell.configuration = configuration
        cell.onEmotionClick = onEmotionClick
        cell.onDeleteClick = onDeleteClick
        
        return cell
    }
    
}

extension EmotionPager: UICollectionViewDelegateFlowLayout {
    
    // 行间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 列间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 单元格尺寸
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}

extension EmotionPager: UICollectionViewDelegate {
    
    // 翻页开始
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        updateScrollX(x: scrollView.contentOffset.x, width: scrollView.bounds.size.width)
    }
    
    // 翻页结束
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateScrollX(x: scrollView.contentOffset.x, width: scrollView.bounds.size.width)
    }
    
}


extension EmotionPager {
    
    private func showIndicatorView() {
        
        guard indicatorView.isHidden else {
            return
        }
        
        indicatorView.isHidden = false
        collectionBottomConstraint.constant = -configuration.indicatorMarginTop
        indicatorBottomConstraint.constant = -configuration.toolbarMarginTop
        setNeedsLayout()
        
    }
    
    private func hideIndicatorView() {
        
        guard !indicatorView.isHidden else {
            return
        }
        
        indicatorView.isHidden = true
        collectionBottomConstraint.constant = 0
        indicatorBottomConstraint.constant = 0
        setNeedsLayout()
        
    }
    
    private func updateScrollX(x: CGFloat, width: CGFloat) {
        
        let index = Int(ceil(x / width))

        checkRange(index: index) {
            emotionSetIndex = $0
            indicatorView.index = $1
            indicatorView.setNeedsDisplay()
        }
        
    }
    
    /**
     * 绝对 index 到相对 index 的转换
     */
    private func checkRange(index: Int, callback: (_ setIndex: Int, _ pageIndex: Int) -> Void) {
        var from = 0
        for i in 0..<emotionSetList.count {
            let to = from + emotionSetList[i].emotionPageList.count
            if index >= from && index < to {
                callback(i, index - from)
                break
            }
            from = to
        }
    }
    
}
