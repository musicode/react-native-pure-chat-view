
import UIKit

public class CameraViewController: UIViewController {
    
    public var configuration: CameraViewConfiguration!
    public var delegate: CameraViewDelegate!
    
    private var cameraView: CameraView!
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cameraView = CameraView(configuration: configuration)
        
        cameraView.onExit = {
            self.delegate.cameraViewDidExit(self)
        }
        cameraView.onCapturePhoto = { photoPath, photoSize, photoWidth, photoHeight in
            self.delegate.cameraViewDidCapturePhoto(self, photoPath: photoPath, photoSize: photoSize, photoWidth: photoWidth, photoHeight: photoHeight)
        }
        cameraView.onRecordVideo = { videoPath, videoSize, videoDuration, photoPath, photoSize, photoWidth, photoHeight in
            self.delegate.cameraViewDidRecordVideo(self, videoPath: videoPath, videoSize: videoSize, videoDuration: videoDuration, photoPath: photoPath, photoSize: photoSize, photoWidth: photoWidth, photoHeight: photoHeight)
        }
        cameraView.onPermissionsGranted = {
            self.delegate.cameraViewDidPermissionsGranted(self)
        }
        cameraView.onPermissionsDenied = {
            self.delegate.cameraViewDidPermissionsDenied(self)
        }
        cameraView.onPermissionsNotGranted = {
            self.delegate.cameraViewDidPermissionsNotGranted(self)
        }
        cameraView.onRecordDurationLessThanMinDuration = {
            self.delegate.cameraViewDidRecordDurationLessThanMinDuration(self)
        }
        
        cameraView.requestPermissions()
        
        view.backgroundColor = .black
        view.addSubview(cameraView)
        
    }
    
    public override func viewDidLayoutSubviews() {
        updateCameraSize()
    }
    
    private func updateCameraSize() {
        if #available(iOS 11.0, *) {
            let safeAreaInsets = view.safeAreaInsets
            cameraView.frame = CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: view.frame.width - safeAreaInsets.left - safeAreaInsets.right, height: view.frame.height - safeAreaInsets.top - safeAreaInsets.bottom)
        }
        else {
            cameraView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        }
    }
    
}


