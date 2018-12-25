
import UIKit

class EventMessageCell: MessageCell {
    
    var eventView = LinkTextView()
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!

    override func create() {

        eventView.delegate = self
        eventView.isEditable = false
        eventView.tintColor = configuration.textMessageTintColor
        eventView.backgroundColor = configuration.eventBackgroundColor
        eventView.isScrollEnabled = false
        eventView.isUserInteractionEnabled = true
        eventView.textContainer.lineFragmentPadding = 0

        
        eventView.linkTextAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue: configuration.linkTextColor
        ]
        
        eventView.textContainerInset = UIEdgeInsetsMake(
            configuration.eventPaddingVertical,
            configuration.eventPaddingHorizontal,
            configuration.eventPaddingVertical,
            configuration.eventPaddingHorizontal
        )
        
        if configuration.eventBorderRadius > 0 {
            eventView.clipsToBounds = true
            eventView.layer.cornerRadius = configuration.eventBorderRadius
        }
        
        eventView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventView)
        
        topConstraint = NSLayoutConstraint(item: eventView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: eventView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.priority = .defaultLow
        
        widthConstraint = NSLayoutConstraint(item: eventView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        heightConstraint = NSLayoutConstraint(item: eventView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        
        contentView.addConstraints([
            
            topConstraint,
            bottomConstraint,
            widthConstraint,
            heightConstraint,
            NSLayoutConstraint(item: eventView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
        
        ])
        
    }
    
    override func update() {
        
        let eventMessage = message as! EventMessage
        
        eventView.attributedText = formatLinks(
            text: eventMessage.event,
            font: configuration.eventTextFont,
            color: configuration.eventTextColor,
            lineSpacing: configuration.eventTextLineSpacing
        )
        updateTextSize(textView: eventView, minWidth: 0, widthConstraint: widthConstraint, heightConstraint: heightConstraint)
        
    }
    
}

extension EventMessageCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate.messageListDidClickLink(link: URL.absoluteString)
        return false
    }
    
}

