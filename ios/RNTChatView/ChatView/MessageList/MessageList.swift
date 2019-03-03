
import UIKit

public class MessageList: UIView {
    
    public var delegate: MessageListDelegate!
    
    public var messageList = [Message]()
    
    public var hasMoreMessage = false {
        didSet {
            if hasMoreMessage {
                refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
                tableView.addSubview(refreshControl)
            }
            else {
                refreshControl.removeTarget(self, action: #selector(refresh), for: .valueChanged)
                refreshControl.removeFromSuperview()
            }
        }
    }
    
    private var configuration: MessageListConfiguration!
    
    private var tableView = UITableView()
    
    private var refreshControl = UIRefreshControl()
    
    public convenience init(configuration: MessageListConfiguration) {
        self.init()
        self.configuration = configuration
        setup()
    }

    func setup() {
        
        configuration.audioPlayer.onPlay = {
            self.delegate.messageListWillUseAudio()
        }
        configuration.audioPlayer.setCategory = configuration.setAudioCategory
        
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(LeftTextMessageCell.self, forCellReuseIdentifier: CellIdentifier.leftTextMessage.rawValue)
        tableView.register(RightTextMessageCell.self, forCellReuseIdentifier: CellIdentifier.rightTextMessage.rawValue)
        
        tableView.register(LeftImageMessageCell.self, forCellReuseIdentifier: CellIdentifier.leftImageMessage.rawValue)
        tableView.register(RightImageMessageCell.self, forCellReuseIdentifier: CellIdentifier.rightImageMessage.rawValue)
        
        tableView.register(LeftAudioMessageCell.self, forCellReuseIdentifier: CellIdentifier.leftAudioMessage.rawValue)
        tableView.register(RightAudioMessageCell.self, forCellReuseIdentifier: CellIdentifier.rightAudioMessage.rawValue)
        
        tableView.register(LeftVideoMessageCell.self, forCellReuseIdentifier: CellIdentifier.leftVideoMessage.rawValue)
        tableView.register(RightVideoMessageCell.self, forCellReuseIdentifier: CellIdentifier.rightVideoMessage.rawValue)
        
        tableView.register(LeftCardMessageCell.self, forCellReuseIdentifier: CellIdentifier.leftCardMessage.rawValue)
        tableView.register(RightCardMessageCell.self, forCellReuseIdentifier: CellIdentifier.rightCardMessage.rawValue)
        
        tableView.register(LeftPostMessageCell.self, forCellReuseIdentifier: CellIdentifier.leftPostMessage.rawValue)
        tableView.register(RightPostMessageCell.self, forCellReuseIdentifier: CellIdentifier.rightPostMessage.rawValue)
        
        tableView.register(LeftFileMessageCell.self, forCellReuseIdentifier: CellIdentifier.leftFileMessage.rawValue)
        tableView.register(RightFileMessageCell.self, forCellReuseIdentifier: CellIdentifier.rightFileMessage.rawValue)
        
        tableView.register(EventMessageCell.self, forCellReuseIdentifier: CellIdentifier.eventMessage.rawValue)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        addConstraints([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(click))
        gesture.numberOfTapsRequired = 1
        
        addGestureRecognizer(gesture)
        
    }
    
    public func stopAudio() {
        configuration.audioPlayer.stop()
    }
    
    public func loadMoreComplete(hasMoreMessage: Bool) {
        
        self.hasMoreMessage = hasMoreMessage
        self.refreshControl.endRefreshing()
        
    }
    
    public func scrollToBottom(animated: Bool) {
        guard messageList.count > 0 else {
            return
        }
        tableView.scrollToRow(at: getIndexPath(index: messageList.count - 1), at: .bottom, animated: animated)
    }
    
    public func append(message: Message) {
        append(messages: [message])
    }
    
    public func append(messages: [Message]) {
        guard messages.count > 0 else {
            return
        }
        messageList.insert(contentsOf: messages, at: messageList.count)
        tableView.reloadData()
    }
    
    public func prepend(message: Message) {
        prepend(messages: [message])
    }
    
    public func prepend(messages: [Message]) {
        let count = messages.count
        guard count > 0 else {
            return
        }
        messageList.insert(contentsOf: messages, at: 0)
        tableView.reloadData()
        
        // 定位在新增的最后一个
        self.tableView.scrollToRow(at: self.getIndexPath(index: count - 1), at: .top, animated: false)
        
    }
    
    public func removeAll() {
        guard messageList.count > 0 else {
            return
        }
        messageList.removeAll()
        tableView.reloadData()
    }
    
    public func remove(messageId: String) {
        guard let index = messageList.index(where: { $0.id == messageId }) else {
            return
        }
        messageList.remove(at: index)
        tableView.deleteRows(at: getIndexPaths(index: index, count: 1), with: .none)
    }
    
    public func update(messageId: String, message: Message) {
        guard let index = messageList.index(where: { $0.id == messageId }) else {
            return
        }
        messageList[ index ] = message
        tableView.reloadRows(at: getIndexPaths(index: index, count: 1), with: .none)
    }
    
    // 确保音频可用，通常是外部要用音频了
    public func ensureAudioAvailable() {
        stopAudio()
    }
    
    @objc private func refresh() {
        delegate.messageListDidLoadMore()
    }
    
    @objc private func click() {
        delegate.messageListDidClickList()
    }
    
    private func getIndexPath(index: Int) -> IndexPath {
        return IndexPath(row: index, section: 0)
    }
    
    private func getIndexPaths(index: Int, count: Int) -> [IndexPath] {
        var list = [IndexPath]()
        for i in index..<(index + count) {
            list.append(getIndexPath(index: i))
        }
        return list
    }
    
}

//
// MARK: - 数据源
//

extension MessageList: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var messageCell: MessageCell?
        
        let rowIndex = indexPath.row
        let message = messageList[ rowIndex ]
        let isRight = configuration.isRightMessage(message: message)
        if message is TextMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.rightTextMessage.rawValue) as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.leftTextMessage.rawValue) as? MessageCell
            }
        }
        else if message is ImageMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.rightImageMessage.rawValue) as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.leftImageMessage.rawValue) as? MessageCell
            }
        }
        else if message is AudioMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.rightAudioMessage.rawValue) as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.leftAudioMessage.rawValue) as? MessageCell
            }
        }
        else if message is VideoMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.rightVideoMessage.rawValue) as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.leftVideoMessage.rawValue) as? MessageCell
            }
        }
        else if message is CardMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.rightCardMessage.rawValue) as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.leftCardMessage.rawValue) as? MessageCell
            }
        }
        else if message is PostMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.rightPostMessage.rawValue) as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.leftPostMessage.rawValue) as? MessageCell
            }
        }
        else if message is FileMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.rightFileMessage.rawValue) as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.leftFileMessage.rawValue) as? MessageCell
            }
        }
        else if message is EventMessage {
            messageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.eventMessage.rawValue) as? MessageCell
        }
        
        messageCell?.bind(configuration: configuration, delegate: delegate, message: message, index: rowIndex, count: messageList.count)
        
        return messageCell!
        
    }
    
}

//
// MARK: - 枚举
//

extension MessageList {
    
    enum CellIdentifier: String {
        case leftTextMessage, rightTextMessage
        case leftImageMessage, rightImageMessage
        case leftAudioMessage, rightAudioMessage
        case leftVideoMessage, rightVideoMessage
        case leftCardMessage, rightCardMessage
        case leftPostMessage, rightPostMessage
        case leftFileMessage, rightFileMessage
        case eventMessage
    }
}
