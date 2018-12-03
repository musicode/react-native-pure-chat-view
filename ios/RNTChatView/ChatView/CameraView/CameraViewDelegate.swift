
import UIKit

public protocol CameraViewDelegate {
    
    // 点击退出按钮
    func cameraViewDidExit(_ cameraView: CameraView)

    // 点击确定按钮选择照片
    func cameraViewDidPickPhoto(_ cameraView: CameraView, photoPath: String, photoWidth: CGFloat, photoHeight: CGFloat)
    
    // 点击确定按钮选择视频
    func cameraViewDidPickVideo(_ cameraView: CameraView, videoPath: String, videoDuration: Int, photoPath: String, photoWidth: CGFloat, photoHeight: CGFloat)
    
    // 录制视频时间太短
    func cameraViewDidRecordDurationLessThanMinDuration(_ cameraView: CameraView)
    
    // 点击拍照或摄像按钮时，发现没权限
    func cameraViewWillCaptureWithoutPermissions(_ cameraView: CameraView)
    
    // 用户点击同意授权
    func cameraViewDidPermissionsGranted(_ cameraView: CameraView)
    
    // 用户点击拒绝授权
    func cameraViewDidPermissionsDenied(_ cameraView: CameraView)

}

public extension CameraViewDelegate {
    
    func cameraViewDidExit(_ cameraView: CameraView) { }

    func cameraViewDidPickPhoto(_ cameraView: CameraView, photoPath: String, photoWidth: CGFloat, photoHeight: CGFloat) { }
    
    func cameraViewDidPickVideo(_ cameraView: CameraView, videoPath: String, videoDuration: Int, photoPath: String, photoWidth: CGFloat, photoHeight: CGFloat) { }

    func cameraViewDidRecordDurationLessThanMinDuration(_ cameraView: CameraView) { }
    
    func cameraViewWillCaptureWithoutPermissions(_ cameraView: CameraView) { }
    
    func cameraViewDidPermissionsGranted(_ cameraView: CameraView) { }
    
    func cameraViewDidPermissionsDenied(_ cameraView: CameraView) { }
    
}
