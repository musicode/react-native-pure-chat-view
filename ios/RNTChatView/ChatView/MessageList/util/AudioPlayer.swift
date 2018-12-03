
import AVFoundation
import UIKit

class AudioPlayer: NSObject {
    
    static let sharedInstance = AudioPlayer()
    
    private var listeners = [AudioPlayerDelegate]()
    
    // 播放器实例
    private var player = AVPlayer(playerItem: nil)
    
    // 当前播放的音频
    private var playerItem: AVPlayerItem!
    
    // 当前正在播放的 url
    private var url = ""
    
    // 播放音频之前的 category
    private var category: String!
    
    // 播放音频
    func play(url: String) {
        
        stop()
        
        self.url = url
        
        let content: URL!
        
        if url.hasPrefix("http") {
            content = URL(string: url)
        }
        else {
            content = URL(fileURLWithPath: url)
        }
        
        playerItem = AVPlayerItem(url: content)
        
        player.replaceCurrentItem(with: playerItem)

        addObservers()
        
        listeners.forEach { listener in
            listener.audioPlayerDidLoad(url: self.url)
        }
        
    }
    
    func stop() {
        
        guard url != "" else {
            return
        }
        
        if playerItem.status == .readyToPlay {
            player.pause()
        }
        
        listeners.forEach { listener in
            listener.audioPlayerDidStop(url: self.url)
        }
        
        removeObservers()
        
        url = ""
        
    }
    
    func isPlaying(url: String) -> Bool {
        return self.url != "" && self.url == url
    }
    
    func addListener(listener: AudioPlayerDelegate) {
        listeners.append(listener)
    }
    
    private func addObservers() {
        
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidPlayToEndTime(notification:)),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sensorStateChange(notification:)),
            name: Notification.Name.UIDeviceProximityStateDidChange,
            object: nil
        )
        
        category = AVAudioSession.sharedInstance().category
        
    }
    
    private func removeObservers() {
        
        playerItem.removeObserver(self, forKeyPath: "status", context: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name.UIDeviceProximityStateDidChange,
            object: nil
        )
        
        try! AVAudioSession.sharedInstance().setCategory(category)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else {
            return
        }
        
        if keyPath == "status" {
            switch playerItem.status {
            case .readyToPlay:
                player.play()
                listeners.forEach { listener in
                    listener.audioPlayerDidPlay(url: self.url)
                }
                break
            default:
                stop()
            }
        }
        
    }

    @objc private func playerItemDidPlayToEndTime(notification: Notification) {
        stop()
    }
    
    @objc private func sensorStateChange(notification: Notification) {
        
        // 贴紧耳朵，听筒播放
        if UIDevice.current.proximityState {
            useEar()
        }
        // 远离耳朵，扬声器播放
        else {
            useSpeaker()
        }
        
    }
    
    private func useSpeaker() {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    }
    
    private func useEar() {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
    }

}

