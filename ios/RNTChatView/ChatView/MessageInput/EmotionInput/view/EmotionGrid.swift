
import UIKit

class EmotionGrid: UICollectionViewCell {
    
    var onEmotionClick: ((Emotion) -> Void)?
    var onDeleteClick: (() -> Void)?

    var configuration: EmotionPagerConfiguration!
    
    var emotionPage = EmotionPage() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let cellIdentifier = "cell"
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let view = UICollectionViewFlowLayout()
        
        view.scrollDirection = .vertical
        
        return view
        
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let view = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = false
        
        view.register(EmotionGridCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        
        contentView.addSubview(view)
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
            
        ])
        
        return view
        
    }()

}

extension EmotionGrid: UICollectionViewDataSource {
    
    // 获取表情数量
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionPage.emotionList.count
    }
    
    // 复用 cell 组件
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EmotionGridCell
        cell.configuration = configuration
        
        let index = indexPath.item
        let emotion = emotionPage.emotionList[index]
        
        
        if emotionPage.hasDeleteButton && index == emotionPage.rows * emotionPage.columns - 1 {
            cell.emotionCell.showDelete(image: configuration.deleteButtonImage!)
        }
        else if emotion.code != "" {
            cell.emotionCell.showEmotion(emotion: emotion, emotionWidth: emotionPage.width, emotionHeight: emotionPage.height)
        }
        else {
            cell.emotionCell.showNothing()
        }
        
        return cell
    }
    
}

extension EmotionGrid: UICollectionViewDelegate {
    
    // 点击事件
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmotionGridCell
        if cell.emotionCell.hasContent() {
            if let emotion = cell.emotionCell.emotion {
                onEmotionClick?(emotion)
            }
            else {
                onDeleteClick?()
            }
        }
    }
    
    // 按下事件
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmotionGridCell
        if cell.emotionCell.hasContent() {
            cell.backgroundColor = configuration.emotionCellBackgroundColorPressed
        }
    }
    
    // 松手事件
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmotionGridCell
        if cell.emotionCell.hasContent() {
            cell.backgroundColor = .clear
        }
    }
    
}

extension EmotionGrid: UICollectionViewDelegateFlowLayout {
    
    // 设置内边距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let rowCount = CGFloat(emotionPage.rows)
        let rowHeight = getCellSize().height
        let contentHeight = rowCount * rowHeight + (rowCount - 1) * configuration.emotionGridRowSpacing
        
        let paddingHorizontal = configuration.emotionGridPaddingHorizontal
        let paddingVertical = (collectionView.frame.height - contentHeight) / 2
        
        return UIEdgeInsets(top: paddingVertical, left: paddingHorizontal, bottom: paddingVertical, right: paddingHorizontal)
    
    }
    
    // 行间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return configuration.emotionGridRowSpacing
    }
    
    // 列间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return configuration.emotionGridColumnSpacing
    }
    
    // 设置单元格尺寸
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize()
    }
    
}

extension EmotionGrid {
    
    // 实时计算单元格尺寸
    func getCellSize() -> CGSize {
        
        let columnCount = CGFloat(emotionPage.columns)
        let spacing = configuration.emotionGridPaddingHorizontal * 2 + flowLayout.sectionInset.left + flowLayout.sectionInset.right + configuration.emotionGridColumnSpacing * (columnCount - 1)
        let width = ((collectionView.frame.width - spacing) / columnCount).rounded(.down)

        // 计算 itemHeight 最大值
        let rowCount = CGFloat(emotionPage.rows)
        let maxHeight = ((collectionView.frame.height - 2 * configuration.emotionGridPaddingVertical - (rowCount - 1) * configuration.emotionGridRowSpacing) / rowCount).rounded(.down)
        
        return CGSize(width: width, height: min(width, maxHeight))
        
    }
    
    // 为了让 View 垂直居中搞的这么麻烦...
    class EmotionGridCell: UICollectionViewCell {
        
        lazy var emotionCell: EmotionCell = {
            
            let view = EmotionCell(configuration: configuration)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
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
