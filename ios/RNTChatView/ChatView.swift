import UIKit
import AVFoundation

let emotionList = [
    
    Emotion(code: "😄", name: "", localImage: UIImage(named: "emoji_1f604"), inline: true),
    Emotion(code: "😷", name: "", localImage: UIImage(named: "emoji_1f637"), inline: true),
    Emotion(code: "😂", name: "", localImage: UIImage(named: "emoji_1f602"), inline: true),
    Emotion(code: "😝", name: "", localImage: UIImage(named: "emoji_1f61d"), inline: true),
    Emotion(code: "😳", name: "", localImage: UIImage(named: "emoji_1f633"), inline: true),
    Emotion(code: "😱", name: "", localImage: UIImage(named: "emoji_1f631"), inline: true),
    Emotion(code: "😔", name: "", localImage: UIImage(named: "emoji_1f614"), inline: true),
    Emotion(code: "😒", name: "", localImage: UIImage(named: "emoji_1f612"), inline: true),
    Emotion(code: "🤗", name: "", localImage: UIImage(named: "emoji_1f917"), inline: true),
    Emotion(code: "🙂", name: "", localImage: UIImage(named: "emoji_1f642"), inline: true),
    Emotion(code: "😊", name: "", localImage: UIImage(named: "emoji_1f60a"), inline: true),
    Emotion(code: "😋", name: "", localImage: UIImage(named: "emoji_1f60b"), inline: true),
    Emotion(code: "😌", name: "", localImage: UIImage(named: "emoji_1f60c"), inline: true),
    Emotion(code: "😍", name: "", localImage: UIImage(named: "emoji_1f60d"), inline: true),
    Emotion(code: "😎", name: "", localImage: UIImage(named: "emoji_1f60e"), inline: true),
    Emotion(code: "😪", name: "", localImage: UIImage(named: "emoji_1f62a"), inline: true),
    Emotion(code: "😓", name: "", localImage: UIImage(named: "emoji_1f613"), inline: true),
    Emotion(code: "😭", name: "", localImage: UIImage(named: "emoji_1f62d"), inline: true),
    Emotion(code: "😘", name: "", localImage: UIImage(named: "emoji_1f618"), inline: true),
    Emotion(code: "😏", name: "", localImage: UIImage(named: "emoji_1f60f"), inline: true),
    Emotion(code: "😚", name: "", localImage: UIImage(named: "emoji_1f61a"), inline: true),
    Emotion(code: "😛", name: "", localImage: UIImage(named: "emoji_1f61b"), inline: true),
    Emotion(code: "😜", name: "", localImage: UIImage(named: "emoji_1f61c"), inline: true),
    
    
    Emotion(code: "💪", name: "", localImage: UIImage(named: "emoji_1f4aa"), inline: true),
    Emotion(code: "👊", name: "", localImage: UIImage(named: "emoji_1f44a"), inline: true),
    Emotion(code: "👍", name: "", localImage: UIImage(named: "emoji_1f44d"), inline: true),
    Emotion(code: "🤘", name: "", localImage: UIImage(named: "emoji_1f918"), inline: true),
    Emotion(code: "👏", name: "", localImage: UIImage(named: "emoji_1f44f"), inline: true),
    Emotion(code: "👋", name: "", localImage: UIImage(named: "emoji_1f44b"), inline: true),
    Emotion(code: "🙌", name: "", localImage: UIImage(named: "emoji_1f64c"), inline: true),
    Emotion(code: "🖐", name: "", localImage: UIImage(named: "emoji_1f590"), inline: true),
    Emotion(code: "🖖", name: "", localImage: UIImage(named: "emoji_1f596"), inline: true),
    Emotion(code: "👎", name: "", localImage: UIImage(named: "emoji_1f44e"), inline: true),
    Emotion(code: "🙏", name: "", localImage: UIImage(named: "emoji_1f64f"), inline: true),
    Emotion(code: "👌", name: "", localImage: UIImage(named: "emoji_1f44c"), inline: true),
    Emotion(code: "👈", name: "", localImage: UIImage(named: "emoji_1f448"), inline: true),
    Emotion(code: "👉", name: "", localImage: UIImage(named: "emoji_1f449"), inline: true),
    Emotion(code: "👆", name: "", localImage: UIImage(named: "emoji_1f446"), inline: true),
    Emotion(code: "👇", name: "", localImage: UIImage(named: "emoji_1f447"), inline: true),
    Emotion(code: "🎃", name: "", localImage: UIImage(named: "emoji_1f383"), inline: true),
    Emotion(code: "👀", name: "", localImage: UIImage(named: "emoji_1f440"), inline: true),
    Emotion(code: "👃", name: "", localImage: UIImage(named: "emoji_1f443"), inline: true),
    Emotion(code: "👄", name: "", localImage: UIImage(named: "emoji_1f444"), inline: true),
    Emotion(code: "👂", name: "", localImage: UIImage(named: "emoji_1f442"), inline: true),
    Emotion(code: "👻", name: "", localImage: UIImage(named: "emoji_1f47b"), inline: true),
    Emotion(code: "💋", name: "", localImage: UIImage(named: "emoji_1f48b"), inline: true),
    
    Emotion(code: "😞", name: "", localImage: UIImage(named: "emoji_1f61e"), inline: true),
    Emotion(code: "😟", name: "", localImage: UIImage(named: "emoji_1f61f"), inline: true),
    Emotion(code: "😫", name: "", localImage: UIImage(named: "emoji_1f62b"), inline: true),
    Emotion(code: "😮", name: "", localImage: UIImage(named: "emoji_1f62e"), inline: true),
    Emotion(code: "😯", name: "", localImage: UIImage(named: "emoji_1f62f"), inline: true),
    Emotion(code: "😉", name: "", localImage: UIImage(named: "emoji_1f609"), inline: true),
    Emotion(code: "😡", name: "", localImage: UIImage(named: "emoji_1f621"), inline: true),
    Emotion(code: "😢", name: "", localImage: UIImage(named: "emoji_1f622"), inline: true),
    Emotion(code: "😣", name: "", localImage: UIImage(named: "emoji_1f623"), inline: true),
    Emotion(code: "😤", name: "", localImage: UIImage(named: "emoji_1f624"), inline: true),
    Emotion(code: "😥", name: "", localImage: UIImage(named: "emoji_1f625"), inline: true),
    Emotion(code: "😧", name: "", localImage: UIImage(named: "emoji_1f627"), inline: true),
    Emotion(code: "😨", name: "", localImage: UIImage(named: "emoji_1f628"), inline: true),
    Emotion(code: "😩", name: "", localImage: UIImage(named: "emoji_1f629"), inline: true),
    Emotion(code: "😲", name: "", localImage: UIImage(named: "emoji_1f632"), inline: true),
    Emotion(code: "😴", name: "", localImage: UIImage(named: "emoji_1f634"), inline: true),
    Emotion(code: "😵", name: "", localImage: UIImage(named: "emoji_1f635"), inline: true),
    Emotion(code: "🙄", name: "", localImage: UIImage(named: "emoji_1f644"), inline: true),
    Emotion(code: "🤒", name: "", localImage: UIImage(named: "emoji_1f912"), inline: true),
    Emotion(code: "🤓", name: "", localImage: UIImage(named: "emoji_1f913"), inline: true),
    Emotion(code: "🤔", name: "", localImage: UIImage(named: "emoji_1f914"), inline: true),
    
]

let emojiFilter = EmojiFilter(emotionList: emotionList)

class Configuration: MessageListConfiguration {
    
    var currentUserId = ""
    
    override func loadImage(imageView: UIImageView, url: String, width: CGFloat, height: CGFloat) {
        ChatView.loadImage(imageView, url, Int(width), Int(height))
    }
    
    override func isRightMessage(message: Message) -> Bool {
        return message.user.id == currentUserId
    }
    
    override func formatText(font: UIFont, text: NSMutableAttributedString) {
        emojiFilter.filter(attributedString: text, text: NSString(string: text.string), font: font, emotionTextHeightRatio: 1)
    }
    
}

@objc public class ChatView: UIView {
    
    @objc public static var loadImage: ((UIImageView, String, Int, Int) -> Void)!
    
    @objc public static var setAudioCategory: ((AVAudioSession.Category) -> Void)!
    
    var messageList: MessageList!
    var messageInput: MessageInput!

    var messageListConfiguration: Configuration!
    var messageInputConfiguration: MessageInputConfiguration!
    
    var messageListBottomLayoutConstraint: NSLayoutConstraint!
    
    @objc public var currentUserId = "" {
        didSet {
            messageListConfiguration.currentUserId = currentUserId
        }
    }
    
    @objc public var featureList = [String]() {
        didSet {
            messageInputConfiguration.featureList = featureList.map {
                switch $0 {
                case "photo":
                    return FeatureType.photo
                case "camera":
                    return FeatureType.camera
                case "file":
                    return FeatureType.file
                case "user":
                    return FeatureType.user
                case "movie":
                    return FeatureType.movie
                case "phone":
                    return FeatureType.phone
                case "favor":
                    return FeatureType.favor
                default:
                    return FeatureType.location
                }
            }
        }
    }
    
    @objc public var inputVisible = true {
        didSet {
            if messageInput != nil {
                removeConstraint(messageListBottomLayoutConstraint)
                messageInput.isHidden = !inputVisible
                messageListBottomLayoutConstraint = self.getMessageListBottomLayoutConstraint()
                addConstraint(messageListBottomLayoutConstraint)
            }
        }
    }
    
    @objc public var leftUserNameVisible = true {
        didSet {
            messageListConfiguration.leftUserNameVisible = leftUserNameVisible
        }
    }
    
    @objc public var rightUserNameVisible = true {
        didSet {
            messageListConfiguration.rightUserNameVisible = rightUserNameVisible
        }
    }
    
    @objc public var userAvatarWidth = 0 {
        didSet {
            messageListConfiguration.userAvatarWidth = CGFloat(userAvatarWidth)
        }
    }
    
    @objc public var userAvatarHeight = 0 {
        didSet {
            messageListConfiguration.userAvatarHeight = CGFloat(userAvatarHeight)
        }
    }
    
    @objc public var userAvatarBorderRadius = 0 {
        didSet {
            messageListConfiguration.userAvatarBorderRadius = CGFloat(userAvatarBorderRadius)
        }
    }
    
    @objc var array = [String]()
    
    @objc var object = [String: String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func setup(messageListDelegate: MessageListDelegate, messageInputDelegate: MessageInputDelegate) {
        
        messageListConfiguration = Configuration()
        messageListConfiguration.setAudioCategory = ChatView.setAudioCategory
        messageList = MessageList(configuration: messageListConfiguration)
        
        messageList.delegate = messageListDelegate
        messageList.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageList)
        
        messageInputConfiguration = MessageInputConfiguration()
        messageInputConfiguration.audioBitRate = 128000
        messageInputConfiguration.audioQuality = .medium
        messageInputConfiguration.audioSampleRate = 44100.0
        messageInputConfiguration.emotionTextHeightRatio = 1
        messageInputConfiguration.setAudioCategory = ChatView.setAudioCategory
        messageInput = MessageInput(configuration: messageInputConfiguration)
        
        messageInput.delegate = messageInputDelegate
        messageInput.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageInput)
        
        
        
        messageInput.setEmotionSetList([
            EmotionSet.build(localImage: UIImage(named: "emoji_icon")!, emotionList: emotionList, columns: 7, rows: 3, width: 26, height: 26, hasDeleteButton: true, hasIndicator: true)
        ])
        
        messageInput.addEmotionFilter(emojiFilter)

        messageListBottomLayoutConstraint = self.getMessageListBottomLayoutConstraint()

        addConstraints([
            NSLayoutConstraint(item: messageInput, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messageInput, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messageInput, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: messageList, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messageList, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messageList, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            messageListBottomLayoutConstraint,
        ])

    }
    
    private func getMessageListBottomLayoutConstraint() -> NSLayoutConstraint {
        if inputVisible {
            return NSLayoutConstraint(item: messageList, attribute: .bottom, relatedBy: .equal, toItem: messageInput, attribute: .top, multiplier: 1, constant: 0)
        }
        return NSLayoutConstraint(item: messageList, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
    }
    
    @objc public func ensureInputAudioAvailable() {
        messageInput.ensureAudioAvailable()
    }
    
    @objc public func ensureListAudioAvailable() {
        messageList.ensureAudioAvailable()
    }
    
    @objc public func resetInput() {
        messageInput.reset()
    }
    
    @objc public func setText(_ text: String) {
        messageInput.setText(text)
    }
    
    @objc public func stopAudio() {
        messageList.stopAudio()
    }
    
    @objc public func scrollToBottom(animated: Bool) {
        messageList.scrollToBottom(animated: animated)
    }
    
    @objc public func loadMoreComplete(hasMoreMessage: Bool) {
        messageList.loadMoreComplete(hasMoreMessage: hasMoreMessage)
    }
    
    @objc public func append(message: [String: Any]) {
        messageList.append(message: formatMessage(data: message))
    }
    
    @objc public func append(messages: [[String: Any]]) {
        messageList.append(messages: messages.map {
            return formatMessage(data: $0)
        })
    }
    
    @objc public func prepend(message: [String: Any]) {
        messageList.prepend(message: formatMessage(data: message))
    }
    
    @objc public func prepend(messages: [[String: Any]]) {
        messageList.prepend(messages: messages.map {
            return formatMessage(data: $0)
        })
    }
    
    @objc public func remove(messageId: String) {
        messageList.remove(messageId: messageId)
    }
    
    @objc public func removeAll() {
        messageList.removeAll()
    }
    
    @objc public func update(messageId: String, message: [String: Any]) {
        messageList.update(messageId: messageId, message: formatMessage(data: message))
    }
    
    @objc public func setAll(messages: [[String: Any]]) {
        messageList.removeAll()
        append(messages: messages)
    }
    
    private func formatMessage(data: [String: Any]) -> Message {
        
        let userDict = data["user"]! as! NSDictionary
        let userId = userDict.object(forKey: "id") as! String
        let userName = userDict.object(forKey: "name") as! String
        let userAvatar = userDict.object(forKey: "avatar") as! String
        
        let user = User(id: userId, name: userName, avatar: userAvatar)
        
        
        let statusInt = data["status"] as! Int
        var status: MessageStatus!
        
        switch statusInt {
        case 1:
            status = .sendIng
            break
        case 2:
            status = .sendSuccess
            break
        default:
            status = .sendFailure
            break
        }
        
        let id = data["id"] as! String
        let time = data["time"] as! String
        
        let canCopy = data["canCopy"] as? Bool ?? false
        let canShare = data["canShare"] as? Bool ?? false
        let canRecall = data["canRecall"] as? Bool ?? false
        let canDelete = data["canDelete"] as? Bool ?? false
        
        let typeInt = data["type"] as! Int
        var message: Message!
        
        switch typeInt {
        case 1:
            message = TextMessage(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete, text: data["text"] as! String)
            break
        case 2:
            message = ImageMessage(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete, url: data["url"] as! String, width: data["width"] as! Int, height: data["height"] as! Int)
            break
        case 3:
            message = AudioMessage(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete, url: data["url"] as! String, duration: data["duration"] as! Int)
            break
        case 4:
            message = VideoMessage(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete, url: data["url"] as! String, duration: data["duration"] as! Int, thumbnail: data["thumbnail"] as! String, width: data["width"] as! Int, height: data["height"] as! Int)
            break
        case 5:
            message = CardMessage(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete, thumbnail: data["thumbnail"] as! String, title: data["title"] as! String, desc: data["desc"] as! String, label: data["label"] as! String, link: data["link"] as! String)
            break
        case 6:
            message = PostMessage(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete, thumbnail: data["thumbnail"] as! String, title: data["title"] as! String, desc: data["desc"] as! String, label: data["label"] as! String, link: data["link"] as! String)
            break
        case 7:
            let iconInt = data["icon"] as! Int
            var icon: FileIcon!
            
            switch iconInt {
            case 1:
                icon = .word
                break
            case 2:
                icon = .excel
                break
            case 3:
                icon = .ppt
                break
            case 4:
                icon = .pdf
                break
            default:
                icon = .txt
                break
            }
            
            message = FileMessage(id: id, user: user, status: status, time: time, canCopy: canCopy, canShare: canShare, canRecall: canRecall, canDelete: canDelete, icon: icon, title: data["title"] as! String, desc: data["desc"] as! String, link: data["link"] as! String)
            break
        default:
            message = EventMessage(id: id, user: user, status: status, time: time, event: data["event"] as! String)
            break
        }
        
        return message
        
    }
}


