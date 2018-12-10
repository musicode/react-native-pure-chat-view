
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopAudio()
    }
    
    func setup() {
 
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(LeftTextMessageCell.self, forCellReuseIdentifier: "LeftTextMessage")
        tableView.register(RightTextMessageCell.self, forCellReuseIdentifier: "RightTextMessage")
        
        tableView.register(LeftImageMessageCell.self, forCellReuseIdentifier: "LeftImageMessage")
        tableView.register(RightImageMessageCell.self, forCellReuseIdentifier: "RightImageMessage")
        
        tableView.register(LeftAudioMessageCell.self, forCellReuseIdentifier: "LeftAudioMessage")
        tableView.register(RightAudioMessageCell.self, forCellReuseIdentifier: "RightAudioMessage")
        
        tableView.register(LeftVideoMessageCell.self, forCellReuseIdentifier: "LeftVideoMessage")
        tableView.register(RightVideoMessageCell.self, forCellReuseIdentifier: "RightVideoMessage")
        
        tableView.register(LeftCardMessageCell.self, forCellReuseIdentifier: "LeftCardMessage")
        tableView.register(RightCardMessageCell.self, forCellReuseIdentifier: "RightCardMessage")
        
        tableView.register(LeftPostMessageCell.self, forCellReuseIdentifier: "LeftPostMessage")
        tableView.register(RightPostMessageCell.self, forCellReuseIdentifier: "RightPostMessage")
        
        tableView.register(EventMessageCell.self, forCellReuseIdentifier: "EventMessage")
        
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
                messageCell = tableView.dequeueReusableCell(withIdentifier: "RightTextMessage") as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "LeftTextMessage") as? MessageCell
            }
        }
        else if message is ImageMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "RightImageMessage") as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "LeftImageMessage") as? MessageCell
            }
        }
        else if message is AudioMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "RightAudioMessage") as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "LeftAudioMessage") as? MessageCell
            }
        }
        else if message is VideoMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "RightVideoMessage") as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "LeftVideoMessage") as? MessageCell
            }
        }
        else if message is CardMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "RightCardMessage") as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "LeftCardMessage") as? MessageCell
            }
        }
        else if message is PostMessage {
            if isRight {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "RightPostMessage") as? MessageCell
            }
            else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "LeftPostMessage") as? MessageCell
            }
        }
        else if message is EventMessage {
            messageCell = tableView.dequeueReusableCell(withIdentifier: "EventMessage") as? MessageCell
        }
        
        messageCell?.bind(configuration: configuration, delegate: delegate, message: message, index: rowIndex, count: messageList.count)
        
        return messageCell!
        
    }
    
}

