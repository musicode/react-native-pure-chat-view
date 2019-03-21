
import UIKit

public protocol CameraViewDelegate {
    
    // 点击退出按钮
    func cameraViewDidExit(_ viewController: CameraViewController)

    // 点击确定按钮选择照片
    func cameraViewDidCapturePhoto(_ viewController: CameraViewController, photoPath: String, photoSize: Int, photoWidth: Int, photoHeight: Int)
    
    // 点击确定按钮选择视频
    func cameraViewDidRecordVideo(_ viewController: CameraViewController, videoPath: String, videoSize: Int, videoDuration: Int, photoPath: String, photoSize: Int, photoWidth: Int, photoHeight: Int)
    
    // 录制视频时间太短
    func cameraViewDidRecordDurationLessThanMinDuration(_ viewController: CameraViewController)
    
    // 点击拍照或摄像按钮时，发现没权限
    func cameraViewDidPermissionsNotGranted(_ viewController: CameraViewController)
    
    // 用户点击同意授权
    func cameraViewDidPermissionsGranted(_ viewController: CameraViewController)
    
    // 用户点击拒绝授权
    func cameraViewDidPermissionsDenied(_ viewController: CameraViewController)

}

public extension CameraViewDelegate {
    
    func cameraViewDidExit(_ viewController: CameraViewController) { }

    func cameraViewDidCapturePhoto(_ viewController: CameraViewController, photoPath: String, photoSize: Int, photoWidth: Int, photoHeight: Int) { }
    
    func cameraViewDidRecordVideo(_ viewController: CameraViewController, videoPath: String, videoSize: Int, videoDuration: Int, photoPath: String, photoSize: Int, photoWidth: Int, photoHeight: Int) { }

    func cameraViewDidRecordDurationLessThanMinDuration(_ viewController: CameraViewController) { }
    
    func cameraViewDidPermissionsNotGranted(_ viewController: CameraViewController) { }
    
    func cameraViewDidPermissionsGranted(_ viewController: CameraViewController) { }
    
    func cameraViewDidPermissionsDenied(_ viewController: CameraViewController) { }
    
}
