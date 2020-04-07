
import UIKit

@objc public protocol MessageInputDelegate {
    
    func messageInputDidRecordAudioDurationLessThanMinDuration()
    
    func messageInputDidRecordAudioPermissionsNotGranted()
    
    func messageInputDidRecordAudioPermissionsGranted()
    
    func messageInputDidRecordAudioPermissionsDenied()
    
    
    
    func messageInputWillUseAudio()
    
    // 发送语音
    func messageInputDidSendAudio(audioPath: String, audioDuration: Int)
    
    // 发送表情
    func messageInputDidSendEmotion(emotion: Emotion)
    
    // 发送文本
    func messageInputDidSendText(text: String)
    
    // 点击图片按钮
    func messageInputDidClickPhotoFeature()
    
    // 点击相机按钮
    func messageInputDidClickCameraFeature()
    
    // 点击文件按钮
    func messageInputDidClickFileFeature()
    
    // 点击用户按钮
    func messageInputDidClickUserFeature()
    
    // 点击视频通话按钮
    func messageInputDidClickMovieFeature()
    
    // 点击语音通话按钮
    func messageInputDidClickPhoneFeature()
    
    // 点击定位按钮
    func messageInputDidClickLocationFeature()
    
    // 点击收藏按钮
    func messageInputDidClickFavorFeature()
    
    // 文本变化
    func messageInputDidTextChange(text: String)
    
    // 抬起
    func messageInputDidLift()
    
    // 落下
    func messageInputDidFall()
    
}

public extension MessageInputDelegate {

    func messageInputDidRecordAudioDurationLessThanMinDuration() { }
    
    func messageInputDidRecordAudioPermissionsNotGranted() { }
    
    func messageInputDidRecordAudioPermissionsGranted() { }
    
    func messageInputDidRecordAudioPermissionsDenied() { }
    
    func messageInputWillUseAudio() { }
    
    func messageInputDidSendAudio(audioPath: String, audioDuration: Int) { }
    
    func messageInputDidSendEmotion(emotion: Emotion) { }
    
    func messageInputDidClickPhotoFeature() { }
    
    func messageInputDidClickCameraFeature() { }
    
    func messageInputDidClickFileFeature() { }
    
    func messageInputDidClickUserFeature() { }
    
    func messageInputDidClickMovieFeature() { }
    
    func messageInputDidClickPhoneFeature() { }
    
    func messageInputDidClickLocationFeature() { }
    
    func messageInputDidClickFavorFeature() { }
    
    func messageInputDidTextChange(text: String) { }
    
    func messageInputDidLift() { }
    
    func messageInputDidFall() { }
    
}
