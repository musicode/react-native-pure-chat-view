
import UIKit

@objc public protocol MessageInputDelegate {
    
    func messageInputWillRecordAudioWithoutPermissions()
    
    func messageInputDidRecordAudioDurationLessThanMinDuration()
    
    func messageInputDidRecordAudioPermissionsGranted()
    
    func messageInputDidRecordAudioPermissionsDenied()
    
    func messageInputWillUseCameraWithoutPermissions()
    
    func messageInputDidRecordVideoDurationLessThanMinDuration()
    
    func messageInputDidRecordVideoPermissionsGranted()
    
    func messageInputDidRecordVideoPermissionsDenied()
    
    func messageInputWillUseAudio()
    
    // 发送语音
    func messageInputDidSendAudio(audioPath: String, audioDuration: Int)
    
    // 发送表情
    func messageInputDidSendEmotion(emotion: Emotion)
    
    // 发送文本
    func messageInputDidSendText(text: String)
    
    // 拍照
    func messageInputDidSendPhoto(photo: ImageFile)
    
    // 录制视频
    func messageInputDidSendVideo(videoPath: String, videoDuration: Int, thumbnail: ImageFile)
    
    // 点击图片按钮
    func messageInputDidClickPhotoFeature()
    
    // 文本变化
    func messageInputDidTextChange(text: String)
    
    // 抬起
    func messageInputDidLift()
    
    // 落下
    func messageInputDidFall()
    
}

public extension MessageInputDelegate {
    
    func messageInputWillRecordAudioWithoutPermissions() { }
    
    func messageInputDidRecordAudioDurationLessThanMinDuration() { }
    
    func messageInputDidRecordAudioPermissionsGranted() { }
    
    func messageInputDidRecordAudioPermissionsDenied() { }
    
    func messageInputWillUseCameraWithoutPermissions() { }
    
    func messageInputDidRecordVideoDurationLessThanMinDuration() { }
    
    func messageInputDidRecordVideoPermissionsGranted() { }
    
    func messageInputDidRecordVideoPermissionsDenied() { }
    
    func messageInputWillUseAudio() { }
    
    func messageInputDidSendAudio(audioPath: String, audioDuration: Int) { }
    
    func messageInputDidSendEmotion(emotion: Emotion) { }
    
    func messageInputDidSendText(text: String) { }
    
    func messageInputDidSendPhoto(photo: ImageFile) { }
    
    func messageInputDidSendVideo(videoPath: String, videoDuration: Int, thumbnail: ImageFile) { }
    
    func messageInputDidClickPhotoFeature() { }
    
    func messageInputDidTextChange(text: String) { }
    
    func messageInputDidLift() { }
    
    func messageInputDidFall() { }
    
}
