
import UIKit
import AVFoundation

class PreviewView: UIImageView {
    
    var video = "" {
        didSet {
            
            guard video != oldValue else {
                return
            }
            
            if let player = playerLayer?.player {
                
                NotificationCenter.default.removeObserver(
                    self,
                    name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem
                )
                
                player.pause()
                
                playerLayer?.removeFromSuperlayer()
                playerLayer = nil
                
            }
            
            if !video.isEmpty {
                
                let player = AVPlayer(url: URL(fileURLWithPath: video))
                
                let newLayer = AVPlayerLayer(player: player)
                newLayer.frame = bounds
                
                layer.addSublayer(newLayer)
                playerLayer = newLayer
                
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(playVideoCompletion),
                    name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem
                )
                
                player.play()
                
            }
        }
    }
    
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
    
    public override func layoutSubviews() {
        playerLayer?.frame = bounds
    }
    
    @objc func playVideoCompletion(_ notification: Notification) {
        guard let player = playerLayer?.player else {
            return
        }
        player.seek(to: CMTime.zero)
        player.play()
    }
    
}

