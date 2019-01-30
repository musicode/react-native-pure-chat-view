
import UIKit

// https://www.cnblogs.com/yongbufangqi1988/p/8945643.html

public class EmotionTextarea: UITextView {
    
    public var onTextChange: (() -> Void)?
    
    public var plainText: String {
        get {
            // 这里不能用 text.count，因为计算 emoji 的长度有问题
            let str = NSString(string: text)
            return getPlainText(in: NSRange(location: 0, length: str.length))
        }
    }
    
    private var filters = [EmotionFilter]()
    
    private var typingAttrs: [NSAttributedString.Key: Any]!
    
    private var maxHeight: CGFloat = 0
    
    private var configuration: EmotionTextareaConfiguration!
    
    public override var intrinsicContentSize: CGSize {
        return frame.size
    }
    
    public convenience init(configuration: EmotionTextareaConfiguration) {
        self.init()
        self.configuration = configuration
        setup()
    }

    func setup() {
        
        typingAttributes[NSAttributedString.Key.foregroundColor] = configuration.textColor
        typingAttributes[NSAttributedString.Key.font] = configuration.textFont
        
        typingAttrs = typingAttributes
        
        // 自动大写
        autocapitalizationType = .none
        
        // 自动修正
        autocorrectionType = .no
        
        // 拼写检查
        spellCheckingType = .no

        textContainer.lineFragmentPadding = 0
        
        textAlignment = .left
        
        tintColor = configuration.tintColor
        
        // 左右内边距必须设置为 0，否则粘贴大段文本会显示错乱
        // 为了保持统一的样式配置，把 内间距/边框/背景色 全部改成让外部去设置

//        backgroundColor = configuration.backgroundColor
//
//        layer.borderColor = configuration.borderColor.cgColor
//        layer.borderWidth = configuration.borderWidth
//        layer.cornerRadius = configuration.borderRadius
        
        delegate = self
        
        layoutManager.allowsNonContiguousLayout = false

        if let font = font {
            maxHeight = configuration.maxLines * font.lineHeight + 2 * configuration.paddingVertical
        }
        
    }
    
    public func addFilter(_ filter: EmotionFilter) {
        filters.append(filter)
    }
    
    public func removeFilter(_ filter: EmotionFilter) {
        filters = filters.filter { $0 !== filter }
    }
    
    public func insertEmotion(_ emotion: Emotion) {
        for filter in filters {
            if filter.insert(textInput: self, emotion: emotion, font: font!, emotionTextHeightRatio: configuration.emotionTextHeightRatio) {
                textChanged()
                break
            }
        }
    }
    
    override public func insertText(_ text: String) {
        
        let pastedAttributedString = NSMutableAttributedString(string: text, attributes: [
            NSAttributedString.Key.foregroundColor: configuration.textColor,
            NSAttributedString.Key.font: configuration.textFont
        ])
        
        let pastedString = NSString(string: text)
        
        for filter in filters {
            filter.filter(attributedString: pastedAttributedString, text: pastedString, font: font!, emotionTextHeightRatio: configuration.emotionTextHeightRatio)
        }
        
        let location = selectedRange.location
        
        textStorage.replaceCharacters(in: selectedRange, with: pastedAttributedString)
        selectedRange = NSRange(location: location + pastedString.length, length: 0)
        
        textChanged()
        
    }
    
    // 清空文本
    public func clear() {
        let length = NSString(string: text).length
        if length > 0 {
            textStorage.deleteCharacters(in: NSRange(location: 0, length: length))
            textChanged()
        }
    }

    // 富文本转成普通文本
    func getPlainText(in range: NSRange) -> String {
        
        let fullText = NSString(string: text)
        var plainText = ""

        var effectiveRange = NSRange(location: range.location, length: 0)
        let maxLength = NSMaxRange(range)
        
        while NSMaxRange(effectiveRange) < maxLength {
            if let attachment = attributedText.attribute(NSAttributedString.Key.attachment, at: NSMaxRange(effectiveRange), effectiveRange: &effectiveRange) {
                if (attachment is EmotionAttachment) {
                    plainText += (attachment as! EmotionAttachment).emotion.code
                }
            }
            else {
                plainText += fullText.substring(with: effectiveRange)
            }
        }
        
        return plainText
        
    }
    
    public override func cut(_ sender: Any?) {
        let string = getPlainText(in: selectedRange)
        super.cut(sender)
        UIPasteboard.general.string = string
    }
    
    public override func copy(_ sender: Any?) {
        UIPasteboard.general.string = getPlainText(in: selectedRange)
    }

    public override func paste(_ sender: Any?) {
        
        guard let string = UIPasteboard.general.string, string.count > 0 else {
            return
        }
        
        insertText(string)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        autoHeight()
    }

    private func autoHeight() {
    
        let newSize = sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))

        var newHeight = newSize.height
        if newHeight > maxHeight {
            newHeight = maxHeight
        }

        if frame.height != newHeight {
            frame.size = CGSize(width: frame.width, height: newHeight)
            invalidateIntrinsicContentSize()
            // 滚动到光标处
            scrollRangeToVisible(selectedRange)
        }
        
    }
    
    private func textChanged() {
        onTextChange?()
        autoHeight()
    }
    
}

extension EmotionTextarea: UITextViewDelegate {
    
    // 文本变化
    public func textViewDidChange(_ textView: UITextView) {
        textChanged()
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        typingAttributes = typingAttrs
    }
    
    // 避免 ios 10.11+ 长按表情会触发保存图片的系统窗口
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return false
    }
    
}
