
import AVFoundation
import UIKit

class AudioPlayer: NSObject {
    
    var onPlay: (() -> Void)?
    
    private var listeners = [AudioPlayerDelegate]()
    
    // 播放器实例
    private var player = AVPlayer(playerItem: nil)
    
    // 当前播放的音频
    private var playerItem: AVPlayerItem!
    
    // 当前正在播放的音频
    private var id = ""
    private var url = ""
    
    override init() {
        super.init()
        // 避免静音时播不了声音或视频
        useSpeaker()
    }
    
    // 播放音频
    func play(id: String, url: String) {
        
        onPlay?()
        
        stop()
        
        self.id = id
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
            listener.audioPlayerDidLoad(id: self.id)
        }
        
    }
    
    func stop() {
        
        guard id != "" else {
            return
        }
        
        if playerItem.status == .readyToPlay {
            player.pause()
        }
        
        listeners.forEach { listener in
            listener.audioPlayerDidStop(id: self.id)
        }
        
        removeObservers()
        
        id = ""
        url = ""
        
    }
    
    func isPlaying(id: String) -> Bool {
        return self.id != "" && self.id == id
    }
    
    func addListener(listener: AudioPlayerDelegate) {
        listeners.append(listener)
    }
    
    private func addObservers() {
        
        UIDevice.current.isProximityMonitoringEnabled = true
        
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidPlayToEndTime),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sensorStateChange),
            name: Notification.Name.UIDeviceProximityStateDidChange,
            object: nil
        )
        
        useSpeaker()
        
    }
    
    private func removeObservers() {
        
        UIDevice.current.isProximityMonitoringEnabled = false
        
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
        
        useSpeaker()
        
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
                    listener.audioPlayerDidPlay(id: self.id)
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

