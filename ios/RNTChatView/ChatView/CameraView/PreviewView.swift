
import UIKit
import AVFoundation

class PreviewView: UIImageView {
    
    private var playerLayer: AVPlayerLayer?
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .black
        contentMode = .scaleAspectFit
    }
    
    func startVideoPlaying(videoPath: String) {
        
        let player = AVPlayer(url: URL(fileURLWithPath: videoPath))
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        
        layer.addSublayer(playerLayer)
        
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playVideoCompletion), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        self.playerLayer = playerLayer
        
    }
    
    func stopVideoPlaying() {
        
        guard let player = playerLayer?.player else {
            return
        }
        
        player.pause()
        playerLayer?.removeFromSuperlayer()
        
        playerLayer = nil
        
    }
    
    public override func layoutSubviews() {
        playerLayer?.frame = bounds
    }
    
    @objc func playVideoCompletion(_ notification: Notification) {
        guard let player = playerLayer?.player else {
            return
        }
        player.seek(to: kCMTimeZero)
        player.play()
    }
    
}

