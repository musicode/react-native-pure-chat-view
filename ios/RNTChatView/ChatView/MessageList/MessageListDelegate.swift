
import Foundation

@objc public protocol MessageListDelegate {
    
    // 点击列表
    func messageListDidClickList()
    
    // 点击消息用户头像
    func messageListDidClickUserAvatar(message: Message)
    
    // 点击消息用户名称
    func messageListDidClickUserName(message: Message)
    
    // 点击消息正文
    func messageListDidClickContent(message: Message)

    // 点击消息复制菜单
    func messageListDidClickCopy(message: Message)
    
    // 点击消息分享菜单
    func messageListDidClickShare(message: Message)
    
    // 点击消息失败图标
    func messageListDidClickFailure(message: Message)
    
    // 点击文本链接
    func messageListDidClickLink(link: String)
    
    // 加载历史消息
    func messageListDidLoadMore()
    
    // 即将播放音频
    func messageListWillUseAudio()
    
}

public extension MessageListDelegate {
    
    func messageListDidClickList() { }
    
    func messageListDidClickUserAvatar(message: Message) { }
    
    func messageListDidClickUserName(message: Message) { }
    
    func messageListDidClickContent(message: Message) { }
    
    func messageListDidClickCopy(message: Message) { }
    
    func messageListDidClickShare(message: Message) { }
    
    func messageListDidClickFailure(message: Message) { }
    
    func messageListDidClickLink(link: String) { }
    
    func messageListDidLoadMore() { }
    
    func messageListWillUseAudio() { }
    
}

