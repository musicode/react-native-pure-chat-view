
import UIKit

public class VoiceInput: UIView {

    public var delegate: VoiceInputDelegate!

    // 让外部判断当前是否在录制
    public var isRecording: Bool {
        get {
            return voiceManager.isRecording
        }
    }
    
    // 让外部判断当前是否在播放
    public var isPlaying: Bool {
        get {
            return voiceManager.isPlaying
        }
    }
    
    //
    // MARK: - 录制界面
    //

    private var recordView = UIView()

    private var recordButton = CircleView()
    private var previewButton = CircleView()
    private var deleteButton = CircleView()

    private var guideLabel = UILabel()
    private var durationLabel = UILabel()

    //
    // MARK: - 预览界面
    //

    private var previewView = UIView()

    private var progressLabel = UILabel()
    private var playButton = CircleView()

    private var cancelButton = SimpleButton()
    private var sendButton = SimpleButton()

    //
    // MARK: - 其他属性
    //

    private var isPreviewButtonPressed = false {
        didSet {
            if oldValue == isPreviewButtonPressed {
                return
            }
            if isPreviewButtonPressed {
                previewButton.centerColor = configuration.previewButtonBackgroundColorHover
                guideLabel.isHidden = false
                durationLabel.isHidden = true
                guideLabel.text = configuration.guideLabelTitlePreview
            }
            else {
                previewButton.centerColor = configuration.previewButtonBackgroundColorNormal
                guideLabel.isHidden = true
                durationLabel.isHidden = false
                guideLabel.text = configuration.guideLabelTitleNormal
            }
            previewButton.setNeedsDisplay()
        }
    }

    private var isDeleteButtonPressed = false {
        didSet {
            if oldValue == isDeleteButtonPressed {
                return
            }
            if isDeleteButtonPressed {
                deleteButton.centerColor = configuration.deleteButtonBackgroundColorHover
                guideLabel.isHidden = false
                durationLabel.isHidden = true
                guideLabel.text = configuration.guideLabelTitleDelete
            }
            else {
                deleteButton.centerColor = configuration.deleteButtonBackgroundColorNormal
                guideLabel.isHidden = true
                durationLabel.isHidden = false
                guideLabel.text = configuration.guideLabelTitleNormal
            }
            deleteButton.setNeedsDisplay()
        }
    }

    private var isPreviewing = false {
        didSet {
            if isPreviewing {
                resetPreviewView()
                recordView.isHidden = true
                previewView.isHidden = false
            }
            else {
                recordView.isHidden = false
                previewView.isHidden = true
            }
            delegate.voiceInputDidPreviewingChange(self, isPreviewing: isPreviewing)
        }
    }
    
    private var configuration: VoiceInputConfiguration!

    private var voiceManager = VoiceManager()

    // 刷新时长的 timer
    private var timer: Timer?

    public convenience init(configuration: VoiceInputConfiguration) {
        self.init()
        self.configuration = configuration
        voiceManager.configuration = configuration
        setup()
    }

    private func setup() {
        
        backgroundColor = configuration.backgroundColor
        
        addRecordView()
        
        addPreviewView()
        
        voiceManager.onPermissionsGranted = {
            self.delegate.voiceInputDidPermissionsGranted(self)
        }
        voiceManager.onPermissionsDenied = {
            self.delegate.voiceInputDidPermissionsDenied(self)
        }
        voiceManager.onRecordWithoutPermissions = {
            self.delegate.voiceInputWillRecordWithoutPermissions(self)
        }
        voiceManager.onRecordDurationLessThanMinDuration = {
            self.delegate.voiceInputDidRecordDurationLessThanMinDuration(self)
        }
        voiceManager.onFinishRecord = { success in
            self.finishRecord()
        }
        voiceManager.onFinishPlay = { success in
            self.finishPlay()
        }
    }

    /**
     * 请求麦克风权限
     */
    public func requestPermissions() -> Bool {
        return voiceManager.requestPermissions()
    }

    private func startTimer(interval: TimeInterval, selector: Selector) {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: selector, userInfo: nil, repeats: true)
    }

    private func stopTimer() {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }

    @objc private func onDurationUpdate() {
        durationLabel.text = formatDuration(voiceManager.duration)
    }

    @objc private func onProgressUpdate() {

        // 接近就直接 1 吧
        // 避免总是不能满圆的情况
        var trackValue = Double(voiceManager.progress) / Double(voiceManager.fileDuration)
        if (trackValue > 0.99) {
            trackValue = 1
        }
        playButton.trackValue = trackValue
        playButton.setNeedsDisplay()

        progressLabel.text = formatDuration(voiceManager.progress)
        
    }

    private func startRecord() {

        do {
            try voiceManager.startRecord()

            if voiceManager.isRecording {

                recordButton.centerColor = configuration.recordButtonBackgroundColorPressed
                recordButton.setNeedsDisplay()

                previewButton.isHidden = false
                deleteButton.isHidden = false

                guideLabel.isHidden = true
                durationLabel.isHidden = false
                durationLabel.text = formatDuration(0)

                startTimer(interval: 0.1, selector: #selector(VoiceInput.onDurationUpdate))
            }
        }
        catch {
            print(error.localizedDescription)
        }

    }

    public func stopRecord() {

        do {
            try voiceManager.stopRecord()
        }
        catch {
            print(error.localizedDescription)
        }

    }

    private func finishRecord() {

        stopTimer()

        if voiceManager.filePath != "" {
            if isPreviewButtonPressed {
                isPreviewing = true
            }
            else if isDeleteButtonPressed {
                voiceManager.deleteFile()
            }
            else {
                delegate.voiceInputDidFinishRecord(self, audioPath: voiceManager.filePath, audioDuration: voiceManager.fileDuration)
            }
        }

        isPreviewButtonPressed = false
        isDeleteButtonPressed = false
        
        recordButton.centerColor = configuration.recordButtonBackgroundColorNormal
        recordButton.setNeedsDisplay()

        previewButton.isHidden = true
        deleteButton.isHidden = true

        guideLabel.isHidden = false
        durationLabel.isHidden = true

    }

    private func startPlay() {

        do {
            try voiceManager.startPlay()
            if voiceManager.isPlaying {
                playButton.centerImage = configuration.stopButtonImage
                playButton.setNeedsDisplay()
                // interval 设小一点才能看到进度条走完
                // 否则就是还剩一段就结束了
                startTimer(interval: 1 / 200, selector: #selector(VoiceInput.onProgressUpdate))
            }
        }
        catch {
            print(error.localizedDescription)
        }

    }

    public func stopPlay() {

        voiceManager.stopPlay()

        finishPlay()

    }

    private func finishPlay() {

        stopTimer()

        resetPreviewView()

    }

    private func resetPreviewView() {
        progressLabel.text = formatDuration(voiceManager.fileDuration)

        playButton.centerImage = configuration.playButtonImage
        playButton.trackValue = 0
        playButton.setNeedsDisplay()
    }

    private func cancel() {
        stopPlay()
        voiceManager.deleteFile()
        isPreviewing = false
    }

    private func send() {
        stopPlay()
        isPreviewing = false
        delegate.voiceInputDidFinishRecord(self, audioPath: voiceManager.filePath, audioDuration: voiceManager.fileDuration)
    }

}

//
// MARK: - 界面搭建
//

extension VoiceInput {

    private func addRecordView() {
        
        recordView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(recordView)

        addConstraints([
            NSLayoutConstraint(item: recordView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: recordView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: recordView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: recordView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
        ])

        addRecordButton()
        addPreviewButton()
        addDeleteButton()

        addGuideLabel()
        addDurationLabel()

    }

    private func addRecordButton() {

        recordButton.delegate = self
        recordButton.centerRadius = configuration.recordButtonRadius
        recordButton.centerColor = configuration.recordButtonBackgroundColorNormal
        recordButton.centerImage = configuration.recordButtonImage
        recordButton.ringWidth = configuration.recordButtonBorderWidth
        recordButton.ringColor = configuration.recordButtonBorderColor

        recordButton.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(recordButton)

        addConstraints([
            NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: recordView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: recordButton, attribute: .centerY, relatedBy: .equal, toItem: recordView, attribute: .centerY, multiplier: 1, constant: 0)
        ])

    }

    private func addPreviewButton() {

        previewButton.delegate = self
        previewButton.isHidden = true

        previewButton.centerRadius = configuration.previewButtonRadius
        previewButton.centerColor = configuration.previewButtonBackgroundColorNormal
        previewButton.centerImage = configuration.previewButtonImage
        previewButton.ringWidth = configuration.previewButtonBorderWidth
        previewButton.ringColor = configuration.previewButtonBorderColor

        previewButton.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(previewButton)

        addConstraints([
            NSLayoutConstraint(item: previewButton, attribute: .centerY, relatedBy: .equal, toItem: recordButton, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewButton, attribute: .right, relatedBy: .equal, toItem: recordButton, attribute: .left, multiplier: 1, constant: -configuration.previewButtonMarginRight),
        ])

    }

    private func addDeleteButton() {

        deleteButton.delegate = self
        deleteButton.isHidden = true

        deleteButton.centerRadius = configuration.deleteButtonRadius
        deleteButton.centerColor = configuration.deleteButtonBackgroundColorNormal
        deleteButton.centerImage = configuration.deleteButtonImage
        deleteButton.ringWidth = configuration.deleteButtonBorderWidth
        deleteButton.ringColor = configuration.deleteButtonBorderColor

        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(deleteButton)

        addConstraints([
            NSLayoutConstraint(item: deleteButton, attribute: .centerY, relatedBy: .equal, toItem: recordButton, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: deleteButton, attribute: .left, relatedBy: .equal, toItem: recordButton, attribute: .right, multiplier: 1, constant: configuration.deleteButtonMarginLeft)
        ])

    }

    private func addGuideLabel() {

        guideLabel.text = configuration.guideLabelTitleNormal
        guideLabel.textColor = configuration.guideLabelTextColor
        guideLabel.font = configuration.guideLabelTextFont

        guideLabel.sizeToFit()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(guideLabel)

        addConstraints([
            NSLayoutConstraint(item: guideLabel, attribute: .centerX, relatedBy: .equal, toItem: recordButton, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: guideLabel, attribute: .bottom, relatedBy: .equal, toItem: recordButton, attribute: .top, multiplier: 1, constant: -configuration.guideLabelMarginBottom)
        ])

    }

    private func addDurationLabel() {

        durationLabel.isHidden = true

        durationLabel.text = "00:00"
        durationLabel.textColor = configuration.durationLabelTextColor
        durationLabel.font = configuration.durationLabelTextFont

        durationLabel.sizeToFit()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(durationLabel)

        addConstraints([
            NSLayoutConstraint(item: durationLabel, attribute: .centerX, relatedBy: .equal, toItem: recordButton, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: durationLabel, attribute: .bottom, relatedBy: .equal, toItem: recordButton, attribute: .top, multiplier: 1, constant: -configuration.durationLabelMarginBottom)
        ])

    }

    private func addPreviewView() {

        previewView.isHidden = true
        previewView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(previewView)
        
        addConstraints([
            NSLayoutConstraint(item: previewView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
        ])

        addPlayButton()
        addProgressLabel()
        addCancelButton()
        addSendButton()

    }

    private func addPlayButton() {

        playButton.delegate = self
        playButton.centerRadius = configuration.playButtonCenterRadius
        playButton.centerColor = configuration.playButtonCenterColorNormal
        playButton.centerImage = configuration.playButtonImage
        playButton.ringWidth = configuration.playButtonRingWidth
        playButton.ringColor = configuration.playButtonRingColor
        playButton.trackWidth = configuration.playButtonRingWidth
        playButton.trackColor = configuration.playButtonTrackColor

        playButton.translatesAutoresizingMaskIntoConstraints = false

        previewView.addSubview(playButton)

        addConstraints([
            NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: previewView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: previewView, attribute: .centerY, multiplier: 1, constant: 0)
        ])

    }

    private func addProgressLabel() {

        progressLabel.text = "00:00"
        progressLabel.textColor = configuration.progressLabelTextColor
        progressLabel.font = configuration.progressLabelTextFont

        progressLabel.sizeToFit()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false

        previewView.addSubview(progressLabel)

        addConstraints([
            NSLayoutConstraint(item: progressLabel, attribute: .centerX, relatedBy: .equal, toItem: playButton, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: progressLabel, attribute: .bottom, relatedBy: .equal, toItem: playButton, attribute: .top, multiplier: 1, constant: -configuration.progressLabelMarginBottom)
        ])


    }

    private func addCancelButton() {

        cancelButton.backgroundColor = configuration.footerButtonBackgroundColorNormal
        cancelButton.backgroundColorPressed = configuration.footerButtonBackgroundColorPressed
        cancelButton.setTitle(configuration.footerCancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(configuration.footerButtonTextColor, for: .normal)

        cancelButton.titleLabel?.font = configuration.footerButtonTextFont

        cancelButton.contentEdgeInsets = UIEdgeInsets(top: configuration.footerButtonPaddingTop, left: 0, bottom: configuration.footerButtonPaddingBottom, right: 0)

        cancelButton.sizeToFit()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        previewView.addSubview(cancelButton)

        addConstraints([
            NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: previewView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cancelButton, attribute: .left, relatedBy: .equal, toItem: previewView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cancelButton, attribute: .right, relatedBy: .equal, toItem: previewView, attribute: .centerX, multiplier: 1, constant: 0)
        ])

        cancelButton.setTopBorder(width: configuration.footerButtonBorderWidth, color: configuration.footerButtonBorderColor)
        
        cancelButton.onClick = {
            self.cancel()
        }

    }

    private func addSendButton() {

        sendButton.backgroundColor = configuration.footerButtonBackgroundColorNormal
        sendButton.backgroundColorPressed = configuration.footerButtonBackgroundColorPressed
        
        sendButton.setTitle(configuration.footerSendButtonTitle, for: .normal)
        sendButton.setTitleColor(configuration.footerButtonTextColor, for: .normal)

        sendButton.titleLabel?.font = configuration.footerButtonTextFont

        sendButton.contentEdgeInsets = UIEdgeInsets(top: configuration.footerButtonPaddingTop, left: 0, bottom: configuration.footerButtonPaddingBottom, right: 0)
        
        sendButton.sizeToFit()
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        previewView.addSubview(sendButton)

        addConstraints([
            NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: previewView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .left, relatedBy: .equal, toItem: previewView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .right, relatedBy: .equal, toItem: previewView, attribute: .right, multiplier: 1, constant: 0),
        ])
        
        sendButton.setLeftBorder(width: configuration.footerButtonBorderWidth, color: configuration.footerButtonBorderColor)
        sendButton.setTopBorder(width: configuration.footerButtonBorderWidth, color: configuration.footerButtonBorderColor)

        sendButton.onClick = {
            self.send()
        }

    }

}

//
// MARK: - 圆形按钮的事件响应
//

extension VoiceInput: CircleViewDelegate {

    public func circleViewDidTouchDown(_ circleView: CircleView) {
        if circleView == recordButton {
            delegate.voiceInputDidRecordButtonClick(self)
            startRecord()
        }
        else if circleView == playButton {
            delegate.voiceInputDidPlayButtonClick(self)
            playButton.centerColor = configuration.playButtonCenterColorPressed
            playButton.setNeedsDisplay()
        }
    }

    public func circleViewDidTouchUp(_ circleView: CircleView, _ inside: Bool, _ isLongPress: Bool) {
        if circleView == recordButton {
            if voiceManager.isRecording {
                stopRecord()
            }
        }
        else if circleView == playButton {
            playButton.centerColor = configuration.playButtonCenterColorNormal
            playButton.setNeedsDisplay()
            if inside {
                if voiceManager.isPlaying {
                    stopPlay()
                }
                else {
                    startPlay()
                }
            }
        }
    }

    public func circleViewDidTouchEnter(_ circleView: CircleView) {
        if circleView == playButton {
            playButton.centerColor = configuration.playButtonCenterColorPressed
            playButton.setNeedsDisplay()
        }
    }

    public func circleViewDidTouchLeave(_ circleView: CircleView) {
        if circleView == playButton {
            playButton.centerColor = configuration.playButtonCenterColorNormal
            playButton.setNeedsDisplay()
        }
    }

    public func circleViewDidTouchMove(_ circleView: CircleView, _ x: CGFloat, _ y: CGFloat) {
        if circleView == recordButton && voiceManager.isRecording {

            let offsetY = y - configuration.recordButtonRadius

            var centerX = -1 * (configuration.previewButtonMarginRight + configuration.previewButtonRadius + configuration.previewButtonBorderWidth)
            var offsetX = x - centerX

            isPreviewButtonPressed = sqrt(offsetX * offsetX + offsetY * offsetY) <= configuration.previewButtonRadius
            if isPreviewButtonPressed {
                return
            }

            centerX = 2 * configuration.recordButtonRadius + configuration.deleteButtonMarginLeft + configuration.deleteButtonRadius + configuration.deleteButtonBorderWidth
            offsetX = x - centerX

            isDeleteButtonPressed = sqrt(offsetX * offsetX + offsetY * offsetY) <= configuration.deleteButtonRadius

        }
    }

}

//
// MARK: - 辅助方法
//

extension VoiceInput {

    private func formatDuration(_ millisecond: Int) -> String {

        var value = millisecond / 1000
        if millisecond < 0 {
            value = 0
        }

        let minutes = value / 60
        let seconds = value - minutes * 60

        var a = String(minutes)
        if minutes < 10 {
            a = "0" + a
        }

        var b = String(seconds)
        if seconds < 10 {
            b = "0" + b
        }

        return "\(a):\(b)"
    }

}
