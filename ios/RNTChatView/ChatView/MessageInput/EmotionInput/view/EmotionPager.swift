
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
    
    public var isSubmitButtonEnabled = false {
        didSet {
            if isSubmitButtonEnabled {
                toolbarView.enableSubmitButton()
            }
            else {
                toolbarView.disableSubmitButton()
            }
        }
    }
    
    public var onEmotionClick: ((Emotion) -> Void)?
    public var onDeleteClick: (() -> Void)?
    public var onSubmitClick: (() -> Void)?
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let view = UICollectionViewFlowLayout()
        
        view.scrollDirection = .horizontal
        
        return view
        
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let view = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        
        view.register(EmotionGrid.self, forCellWithReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        
        addSubview(view)
        
        collectionBottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: indicatorView, attribute: .top, multiplier: 1, constant: 0)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            collectionBottomConstraint,
        ])
        
        return view
        
    }()
    
    
    private lazy var indicatorView: DotIndicator = {
    
        let view = DotIndicator()
        
        view.color = configuration.indicatorColorNormal
        view.radius = configuration.indicatorRadiusNormal
        view.activeColor = configuration.indicatorColorActive
        view.activeRadius = configuration.indicatorRadiusActive
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        addSubview(view)
        
        indicatorBottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: toolbarView, attribute: .top, multiplier: 1, constant: 0)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            indicatorBottomConstraint,
        ])
        
        return view
        
    }()
    
    private lazy var toolbarView: EmotionToolbar = {
        
        let view = EmotionToolbar(configuration: configuration)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onIconClick = { icon in
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
        view.onSubmitClick = {
            self.onSubmitClick?()
        }
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.toolbarHeight + configuration.toolbarTopBorderWidth)
        ])
        
        return view
        
    }()
    
    private let cellIdentifier = "grid"
    
    private var collectionBottomConstraint: NSLayoutConstraint!
    private var indicatorBottomConstraint: NSLayoutConstraint!
    
    
    private var configuration: EmotionPagerConfiguration!
    
    public convenience init(configuration: EmotionPagerConfiguration) {
        
        self.init()
        self.configuration = configuration
        
        backgroundColor = configuration.backgroundColor
        collectionView.backgroundColor = .clear
        
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        checkRange(index: index) {
            emotionSetIndex = $0
            indicatorView.index = $1
            indicatorView.setNeedsDisplay()
        }
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
