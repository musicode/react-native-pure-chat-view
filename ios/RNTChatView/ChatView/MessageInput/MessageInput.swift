
import UIKit

public class MessageInput: UIView {
    
    private static let KEY_KEYBOARD_HEIGHT = "message_input_keyboard_height"

    public var delegate: MessageInputDelegate!
    
    private let voicePanelConfiguration = VoiceInputConfiguration()
    private let emotionPagerConfiguration = EmotionPagerConfiguration()
    
    private let voiceButton = CircleView()
    private let emotionButton = CircleView()
    private var textarea: EmotionTextarea!
    
    private let rightButtons = UIView()
    private let moreButton = CircleView()
    private let sendButton = SimpleButton()
    
    private let contentPanel = UIView()
    private let contentPanelTopBorder = UIView()
    
    private var voicePanel: VoiceInput!
    private var emotionPanel: EmotionPager!
    private let morePanel = UIView()
    
    private var cameraViewController: CameraViewController?
    
    private var textareaBottomConstraint: NSLayoutConstraint!
    
    private var voicePanelBottomConstraint: NSLayoutConstraint!
    private var emotionPanelBottomConstraint: NSLayoutConstraint!
    private var morePanelBottomConstraint: NSLayoutConstraint!
    
    private var contentPanelHeightConstraint: NSLayoutConstraint!
    private var contentPanelBottomConstraint: NSLayoutConstraint!
    
    private var configuration: MessageInputConfiguration!
    
    private var isContentPanelHeightDirty = false
    
    private var isKeyboardVisible = false
    
    private var isVoicePreviewing = false
    
    public var viewMode = ViewMode.keyboard {
        didSet {
            
            switch viewMode {
            case .voice:
                voicePanel.requestPermissions()
                voicePanel.isHidden = false
                emotionPanel.isHidden = true
                morePanel.isHidden = true
                updateVoicePanelBackgroundColor()
                break
            case .emotion:
                voicePanel.isHidden = true
                emotionPanel.isHidden = false
                morePanel.isHidden = true
                contentPanel.backgroundColor = emotionPagerConfiguration.toolbarBackgroundColor
                break
            case .more:
                voicePanel.isHidden = true
                emotionPanel.isHidden = true
                morePanel.isHidden = false
                contentPanel.backgroundColor = configuration.contentPanelBackgroundColor
                break
            case .keyboard:
                contentPanel.backgroundColor = configuration.contentPanelBackgroundColor
                break
            }
            
            // 切换到语音、表情、更多
            if viewMode != .keyboard {
                setContentPanelHeight(configuration.contentPanelHeight)
                showContentPanel()
                hideKeyboard()
            }
            
        }
    }
    
    private var plainText = "" {
        didSet {
            if oldValue.isEmpty || plainText.isEmpty {
                if oldValue.isEmpty {
                    sendButton.isHidden = false
                    moreButton.isHidden = true
                    emotionPanel.isSendButtonEnabled = true
                }
                else {
                    sendButton.isHidden = true
                    moreButton.isHidden = false
                    emotionPanel.isSendButtonEnabled = false
                }
            }
            delegate.messageInputDidTextChange(text: plainText)
        }
    }
    
    public convenience init(configuration: MessageInputConfiguration) {
        
        self.init()
        self.configuration = configuration
        
        backgroundColor = configuration.inputBarBackgroundColor
        
        addContentPanel()
        addInputBar()
        
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardVisible(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
    }

    public func reset() {
        if viewMode == .keyboard {
            if isKeyboardVisible {
                hideKeyboard()
            }
        }
        else {
            viewMode = .keyboard
            hideContentPanel()
        }
    }
    
    public func getText() -> String {
        return plainText
    }
    
    public func setText(_ text: String) {
        textarea.clear()
        textarea.insertText(text)
    }

    public func setEmotionSetList(_ emotionSetList: [EmotionSet]) {
        emotionPanel.emotionSetList = emotionSetList
    }
    
    public func addEmotionFilter(_ emotionFilter: EmotionFilter) {
        textarea.addFilter(emotionFilter)
    }
    
    public func removeEmotionFilter(_ emotionFilter: EmotionFilter) {
        textarea.removeFilter(emotionFilter)
    }
    
    // 确保音频可用，通常是外部要用音频了
    public func ensureAudioAvailable() {
        if voicePanel.isRecording {
            voicePanel.stopRecord()
        }
        else if voicePanel.isPlaying {
            voicePanel.stopPlay()
        }
    }

}

extension MessageInput {
    
    private func addInputBar() {

        addTextarea()
        
        addVoiceButton()
        addRightButtons()
        
        addEmotionButton()
        
        addInputBarTopBorder()
        
    }
    
    private func addTextarea() {
        
        let textareaConfiguration = EmotionTextareaConfiguration()
        textareaConfiguration.emotionTextHeightRatio = configuration.emotionTextHeightRatio
        textarea = EmotionTextarea(configuration: textareaConfiguration)
        
        textarea.translatesAutoresizingMaskIntoConstraints = false
        textarea.onTextChange = {
            self.plainText = self.textarea.plainText
        }
        
        addSubview(textarea)
        
        textareaBottomConstraint = NSLayoutConstraint(item: textarea, attribute: .bottom, relatedBy: .equal, toItem: contentPanel, attribute: .top, multiplier: 1, constant: -configuration.inputBarPaddingVertical)
        
        addConstraints([
            textareaBottomConstraint,
        ])
        
    }

    private func addVoiceButton() {
        
        voiceButton.centerImage = configuration.voiceButtonImage
        voiceButton.centerRadius = configuration.circleButtonRadius - configuration.circleButtonBorderWidth
        voiceButton.centerColor = configuration.circleButtonBackgroundColorNormal
        voiceButton.ringWidth = configuration.circleButtonBorderWidth
        voiceButton.ringColor = configuration.circleButtonBorderColor
        voiceButton.trackWidth = 0
        
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        voiceButton.delegate = self
        
        addSubview(voiceButton)
        
        addConstraints([
            NSLayoutConstraint(item: voiceButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: configuration.inputBarPaddingHorizontal),
            NSLayoutConstraint(item: voiceButton, attribute: .right, relatedBy: .equal, toItem: textarea, attribute: .left, multiplier: 1, constant: -configuration.inputBarItemSpacing),
            NSLayoutConstraint(item: voiceButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 2 * configuration.circleButtonRadius),
            NSLayoutConstraint(item: voiceButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 2 * configuration.circleButtonRadius),
            NSLayoutConstraint(item: voiceButton, attribute: .bottom, relatedBy: .equal, toItem: textarea, attribute: .bottom, multiplier: 1, constant: -configuration.circleButtonMarginBottom),
        ])
        
    }
    
    private func addEmotionButton() {
        
        emotionButton.centerImage = configuration.emotionButtonImage
        emotionButton.centerRadius = configuration.circleButtonRadius - configuration.circleButtonBorderWidth
        emotionButton.centerColor = configuration.circleButtonBackgroundColorNormal
        emotionButton.ringWidth = configuration.circleButtonBorderWidth
        emotionButton.ringColor = configuration.circleButtonBorderColor
        emotionButton.trackWidth = 0
        
        emotionButton.translatesAutoresizingMaskIntoConstraints = false
        emotionButton.delegate = self
        
        addSubview(emotionButton)
        
        addConstraints([
            NSLayoutConstraint(item: emotionButton, attribute: .left, relatedBy: .equal, toItem: textarea, attribute: .right, multiplier: 1, constant: configuration.inputBarItemSpacing),
            NSLayoutConstraint(item: emotionButton, attribute: .right, relatedBy: .equal, toItem: rightButtons, attribute: .left, multiplier: 1, constant: -configuration.inputBarItemSpacing),
            NSLayoutConstraint(item: emotionButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 2 * configuration.circleButtonRadius),
            NSLayoutConstraint(item: emotionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 2 * configuration.circleButtonRadius),
            NSLayoutConstraint(item: emotionButton, attribute: .bottom, relatedBy: .equal, toItem: voiceButton, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
    }
    
    private func addRightButtons() {
        
        // 右边要放两个互斥按钮
        // 当没有内容时，显示更多按钮，当有内容时，显示发送按钮
        rightButtons.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightButtons)
        
        addConstraints([
            NSLayoutConstraint(item: rightButtons, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -configuration.inputBarPaddingHorizontal),
            NSLayoutConstraint(item: rightButtons, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.sendButtonWidth),
            NSLayoutConstraint(item: rightButtons, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.sendButtonHeight),
            NSLayoutConstraint(item: rightButtons, attribute: .bottom, relatedBy: .equal, toItem: textarea, attribute: .bottom, multiplier: 1, constant: -configuration.sendButtonMarginBottom),
        ])
        
        addMoreButton()
        addSendButton()
        
    }
    
    private func addMoreButton() {
        
        moreButton.centerImage = configuration.moreButtonImage
        moreButton.centerRadius = configuration.circleButtonRadius - configuration.circleButtonBorderWidth
        moreButton.centerColor = configuration.circleButtonBackgroundColorNormal
        moreButton.ringWidth = configuration.circleButtonBorderWidth
        moreButton.ringColor = configuration.circleButtonBorderColor
        moreButton.trackWidth = 0
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.delegate = self
        
        rightButtons.addSubview(moreButton)
        
        rightButtons.addConstraints([
            NSLayoutConstraint(item: moreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 2 * configuration.circleButtonRadius),
            NSLayoutConstraint(item: moreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 2 * configuration.circleButtonRadius),
            NSLayoutConstraint(item: moreButton, attribute: .centerX, relatedBy: .equal, toItem: rightButtons, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: moreButton, attribute: .centerY, relatedBy: .equal, toItem: rightButtons, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
    }
    
    private func addSendButton() {
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.isHidden = true
        
        sendButton.backgroundColor = configuration.sendButtonBackgroundColorNormal
        sendButton.backgroundColorPressed = configuration.sendButtonBackgroundColorPressed
        
        sendButton.titleLabel?.font = configuration.sendButtonTextFont
        sendButton.setTitle(configuration.sendButtonTitle, for: .normal)
        sendButton.setTitleColor(configuration.sendButtonTextColor, for: .normal)

        sendButton.layer.borderWidth = configuration.sendButtonBorderWidth
        sendButton.layer.borderColor = configuration.sendButtonBorderColor.cgColor
        sendButton.layer.cornerRadius = configuration.sendButtonBorderRadius
        
        if configuration.sendButtonBorderRadius > 0 {
            sendButton.layer.cornerRadius = configuration.sendButtonBorderRadius
            sendButton.clipsToBounds = true
        }
        
        rightButtons.addSubview(sendButton)
        
        sendButton.onClick = {
            self.sendText()
        }
        
        rightButtons.addConstraints([
            NSLayoutConstraint(item: sendButton, attribute: .centerX, relatedBy: .equal, toItem: rightButtons, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .centerY, relatedBy: .equal, toItem: rightButtons, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.sendButtonWidth),
            NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.sendButtonHeight),
        ])
        
    }

    private func addInputBarTopBorder() {
        
        let border = UIView()
        
        border.backgroundColor = configuration.inputBarBorderColor
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        
        addConstraints([
            NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: textarea, attribute: .top, multiplier: 1, constant: -configuration.inputBarPaddingVertical),
            NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.inputBarBorderWidth),
        ])
        
    }
    
    private func addContentPanel() {
        
        contentPanel.backgroundColor = configuration.contentPanelBackgroundColor
        contentPanel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentPanel)

        contentPanelHeightConstraint = NSLayoutConstraint(item: contentPanel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.contentPanelHeight)
        
        contentPanelBottomConstraint = NSLayoutConstraint(item: contentPanel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: configuration.contentPanelHeight)
        
        addConstraints([
            NSLayoutConstraint(item: contentPanel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentPanel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            contentPanelBottomConstraint,
            contentPanelHeightConstraint,
        ])
        
        addContentTopBorder()
        
        addVoicePanel()
        addEmotionPanel()
        addMorePanel()
        
    }
    
    private func addContentTopBorder() {
        
        contentPanelTopBorder.backgroundColor = configuration.inputBarBorderColor
        contentPanelTopBorder.translatesAutoresizingMaskIntoConstraints = false
        
        contentPanel.addSubview(contentPanelTopBorder)
        
        contentPanel.addConstraints([
            NSLayoutConstraint(item: contentPanelTopBorder, attribute: .top, relatedBy: .equal, toItem: contentPanel, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentPanelTopBorder, attribute: .left, relatedBy: .equal, toItem: contentPanel, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentPanelTopBorder, attribute: .right, relatedBy: .equal, toItem: contentPanel, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentPanelTopBorder, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.inputBarBorderWidth),
        ])
        
    }
    
    private func addVoicePanel() {
        
        voicePanelConfiguration.backgroundColor = configuration.contentPanelBackgroundColor
        voicePanelConfiguration.audioBitRate = configuration.audioBitRate
        voicePanelConfiguration.audioQuality = configuration.audioQuality
        voicePanelConfiguration.audioSampleRate = configuration.audioSampleRate
        voicePanelConfiguration.setAudioCategory = configuration.setAudioCategory
        
        voicePanel = VoiceInput(configuration: voicePanelConfiguration)
        
        voicePanel.delegate = self
        voicePanel.isHidden = true
        voicePanel.translatesAutoresizingMaskIntoConstraints = false
        contentPanel.addSubview(voicePanel)
        
        voicePanelBottomConstraint = NSLayoutConstraint(item: voicePanel, attribute: .bottom, relatedBy: .equal, toItem: contentPanel, attribute: .bottom, multiplier: 1, constant: 0)
        
        addConstraints([
            NSLayoutConstraint(item: voicePanel, attribute: .left, relatedBy: .equal, toItem: contentPanel, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: voicePanel, attribute: .right, relatedBy: .equal, toItem: contentPanel, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: voicePanel, attribute: .top, relatedBy: .equal, toItem: contentPanelTopBorder, attribute: .bottom, multiplier: 1, constant: 0),
            voicePanelBottomConstraint,
        ])
        
    }
    
    private func addEmotionPanel() {
        
        emotionPagerConfiguration.backgroundColor = configuration.contentPanelBackgroundColor
        emotionPanel = EmotionPager(configuration: emotionPagerConfiguration)
        
        emotionPanel.isHidden = true
        emotionPanel.translatesAutoresizingMaskIntoConstraints = false

        emotionPanel.onSendClick = {
            self.sendText()
        }
        emotionPanel.onEmotionClick = { emotion in
            if emotion.inline {
                self.textarea.insertEmotion(emotion)
            }
            else {
                self.delegate.messageInputDidSendEmotion(emotion: emotion)
            }
        }
        emotionPanel.onDeleteClick = {
            self.textarea.deleteBackward()
        }
        contentPanel.addSubview(emotionPanel)

        emotionPanelBottomConstraint = NSLayoutConstraint(item: emotionPanel, attribute: .bottom, relatedBy: .equal, toItem: contentPanel, attribute: .bottom, multiplier: 1, constant: 0)
        
        addConstraints([
            NSLayoutConstraint(item: emotionPanel, attribute: .left, relatedBy: .equal, toItem: contentPanel, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: emotionPanel, attribute: .right, relatedBy: .equal, toItem: contentPanel, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: emotionPanel, attribute: .top, relatedBy: .equal, toItem: contentPanelTopBorder, attribute: .bottom, multiplier: 1, constant: 0),
            emotionPanelBottomConstraint,
        ])
        
    }
    
    private func addMorePanel() {
        
        morePanel.isHidden = true
        morePanel.translatesAutoresizingMaskIntoConstraints = false
        contentPanel.addSubview(morePanel)
        
        let photoFeature = FeatureButton(title: configuration.photoFeatureTitle, image: configuration.photoFeatureImage, configuration: configuration)
        photoFeature.translatesAutoresizingMaskIntoConstraints = false
        photoFeature.onClick = {
            self.delegate.messageInputDidClickPhotoFeature()
        }
        morePanel.addSubview(photoFeature)
        
        let cameraFeature = FeatureButton(title: configuration.cameraFeatureTitle, image: configuration.cameraFeatureImage, configuration: configuration)
        cameraFeature.translatesAutoresizingMaskIntoConstraints = false
        cameraFeature.onClick = {
            self.openCamera()
        }
        morePanel.addSubview(cameraFeature)
        
        morePanelBottomConstraint = NSLayoutConstraint(item: morePanel, attribute: .bottom, relatedBy: .equal, toItem: contentPanel, attribute: .bottom, multiplier: 1, constant: 0)
        
        contentPanel.addConstraints([
            NSLayoutConstraint(item: morePanel, attribute: .left, relatedBy: .equal, toItem: contentPanel, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: morePanel, attribute: .right, relatedBy: .equal, toItem: contentPanel, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: morePanel, attribute: .top, relatedBy: .equal, toItem: contentPanelTopBorder, attribute: .bottom, multiplier: 1, constant: 0),
            morePanelBottomConstraint,

            NSLayoutConstraint(item: photoFeature, attribute: .top, relatedBy: .equal, toItem: morePanel, attribute: .top, multiplier: 1, constant: configuration.featurePanelPaddingVertical),
            NSLayoutConstraint(item: photoFeature, attribute: .left, relatedBy: .equal, toItem: morePanel, attribute: .left, multiplier: 1, constant: configuration.featurePanelPaddingHorizontal),

            NSLayoutConstraint(item: cameraFeature, attribute: .top, relatedBy: .equal, toItem: morePanel, attribute: .top, multiplier: 1, constant: configuration.featurePanelPaddingVertical),
            NSLayoutConstraint(item: cameraFeature, attribute: .left, relatedBy: .equal, toItem: morePanel, attribute: .left, multiplier: 1, constant: configuration.featurePanelPaddingHorizontal + configuration.featureButtonWidth + configuration.featureButtonSpacing),
        ])
        
    }
    
    private func showKeyboard() {
        
        textarea.becomeFirstResponder()
        
    }
    
    private func hideKeyboard() {
        
        textarea.resignFirstResponder()
        
    }
    
    private func showContentPanel() {
        
        guard contentPanelBottomConstraint.constant > 0 else {
            updateContentPanelHeight(force: false, completion: nil)
            return
        }
        
        contentPanelBottomConstraint.constant = 0
        
        updateContentPanelHeight(force: true, completion: { finished in
            self.delegate.messageInputDidLift()
        })
        
    }
    
    private func hideContentPanel() {
        
        guard contentPanelBottomConstraint.constant == 0 else {
            updateContentPanelHeight(force: false, completion: nil)
            return
        }
        
        contentPanelBottomConstraint.constant = contentPanelHeightConstraint.constant
        
        updateContentPanelHeight(force: true, completion: { finished in
            self.resetPanels()
            self.delegate.messageInputDidFall()
        })
        
    }
    
    private func sendText() {
        
        if plainText != "" {
            delegate.messageInputDidSendText(text: plainText)
            textarea.clear()
        }
        
    }
    
    private func resetPanels() {
        
        voicePanel.isHidden = true
        emotionPanel.isHidden = true
        morePanel.isHidden = true
        
    }
    
    private func openCamera() {
        
        guard let parentViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        let cameraViewController = CameraViewController()
        
        let cameraViewConfiguration = CameraViewConfiguration()
        cameraViewConfiguration.preset = configuration.videoPreset
        
        cameraViewController.configuration = cameraViewConfiguration
        cameraViewController.delegate = self
        
        parentViewController.present(cameraViewController, animated: true, completion: nil)
        
        self.cameraViewController = cameraViewController
        
    }
    
    public override func layoutSubviews() {
        
        if #available(iOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets {
                
                let safeAreaBottom = safeAreaInsets.bottom
                
                var bottom = configuration.inputBarPaddingVertical
                if contentPanelBottomConstraint.constant > 0 {
                    bottom += safeAreaBottom
                }
                textareaBottomConstraint.constant = -bottom
                
                voicePanelBottomConstraint.constant = -safeAreaBottom
                emotionPanelBottomConstraint.constant = -safeAreaBottom
                morePanelBottomConstraint.constant = -safeAreaBottom
                
                setNeedsLayout()
                
            }
        }
        
    }
}

//
// MARK: - 处理软键盘显示和隐藏
//

extension MessageInput {
    
    @objc func onKeyboardVisible(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            isKeyboardVisible = true
            
            viewMode = .keyboard
            
            // 内容面板高度改为键盘高度
            setContentPanelHeight(keyboardFrame.cgRectValue.height)

            // 直接点击输入框触发唤起键盘
            if voicePanel.isHidden && emotionPanel.isHidden && morePanel.isHidden {
                showContentPanel()
            }
            // 从语音、表情、更多切换过来的
            else {
                updateContentPanelHeight(force: true, completion: { finished in
                    self.resetPanels()
                })
            }
            
        }
        
    }
    
    @objc func onKeyboardHidden(notification: NSNotification) {
        
        isKeyboardVisible = false
        
        // 直接落下
        if voicePanel.isHidden && emotionPanel.isHidden && morePanel.isHidden {
            hideContentPanel()
        }
        // 切换到语音、表情、更多
        else {
            updateContentPanelHeight(force: false, completion: nil)
        }
        
    }
    
    private func setContentPanelHeight(_ height: CGFloat) {
        
        let oldHeight = contentPanelHeightConstraint.constant
        
        guard oldHeight != height else {
            return
        }
        
        contentPanelHeightConstraint.constant = height
        
        if contentPanelBottomConstraint.constant > 0 {
            contentPanelBottomConstraint.constant = height
        }
        
        isContentPanelHeightDirty = true
        
    }
    
    private func updateContentPanelHeight(force: Bool, completion: ((Bool) -> Void)?) {
        
        guard isContentPanelHeightDirty || force else {
            return
        }
        
        UIView.animate(
            withDuration: configuration.keyboardAnimationDuration,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.layoutIfNeeded()
            },
            completion: completion
        )
        
        isContentPanelHeightDirty = false
        
    }
    
}

//
// MARK: - VoiceInputDelegate 代理
//

extension MessageInput: VoiceInputDelegate {
    
    public func voiceInputDidPreviewingChange(_ voiceInput: VoiceInput, isPreviewing: Bool) {
        isVoicePreviewing = isPreviewing
        updateVoicePanelBackgroundColor()
    }
    
    public func voiceInputDidRecordButtonClick(_ voiceInput: VoiceInput) {
        delegate.messageInputWillUseAudio()
    }
    
    public func voiceInputDidPlayButtonClick(_ voiceInput: VoiceInput) {
        delegate.messageInputWillUseAudio()
    }
    
    public func voiceInputDidFinishRecord(_ voiceInput: VoiceInput, audioPath: String, audioDuration: Int) {
        delegate.messageInputDidSendAudio(audioPath: audioPath, audioDuration: audioDuration)
    }
    
    public func voiceInputWillRecordWithoutPermissions(_ voiceInput: VoiceInput) {
        delegate.messageInputWillRecordAudioWithoutPermissions()
    }
    
    public func voiceInputDidRecordDurationLessThanMinDuration(_ voiceInput: VoiceInput) {
        delegate.messageInputDidRecordAudioDurationLessThanMinDuration()
    }
    
    public func voiceInputDidPermissionsGranted(_ voiceInput: VoiceInput) {
        delegate.messageInputDidRecordAudioPermissionsGranted()
    }
    
    public func voiceInputDidPermissionsDenied(_ voiceInput: VoiceInput) {
        delegate.messageInputDidRecordAudioPermissionsDenied()
    }
    
    private func updateVoicePanelBackgroundColor() {
        if isVoicePreviewing {
            contentPanel.backgroundColor = voicePanelConfiguration.footerButtonBackgroundColorNormal
        }
        else {
            contentPanel.backgroundColor = configuration.contentPanelBackgroundColor
        }
    }
    
}

//
// MARK: - CameraViewDelegate 代理
//

extension MessageInput: CameraViewDelegate {
    
    public func cameraViewDidExit(_ cameraView: CameraView) {
        cameraViewController?.dismiss(animated: true, completion: nil)
    }
    
    public func cameraViewDidPickPhoto(_ cameraView: CameraView, photoPath: String, photoWidth: CGFloat, photoHeight: CGFloat) {
        cameraViewController?.dismiss(animated: true, completion: nil)
        let photo = ImageFile(path: photoPath, width: photoWidth, height: photoHeight)
        delegate.messageInputDidSendPhoto(photo: photo)
    }
    
    public func cameraViewDidPickVideo(_ cameraView: CameraView, videoPath: String, videoDuration: Int, photoPath: String, photoWidth: CGFloat, photoHeight: CGFloat) {
        cameraViewController?.dismiss(animated: true, completion: nil)
        let thumbnail = ImageFile(path: photoPath, width: photoWidth, height: photoHeight)
        delegate.messageInputDidSendVideo(videoPath: videoPath, videoDuration: videoDuration, thumbnail: thumbnail)
    }
    
    public func cameraViewWillCaptureWithoutPermissions(_ cameraView: CameraView) {
        delegate.messageInputWillUseCameraWithoutPermissions()
    }
    
    public func cameraViewDidRecordDurationLessThanMinDuration(_ cameraView: CameraView) {
        delegate.messageInputDidRecordVideoDurationLessThanMinDuration()
    }
    
    public func cameraViewDidPermissionsGranted(_ cameraView: CameraView) {
        delegate.messageInputDidRecordVideoPermissionsGranted()
    }
    
    public func cameraViewDidPermissionsDenied(_ cameraView: CameraView) {
        delegate.messageInputDidRecordVideoPermissionsDenied()
    }
    
}

//
// MARK: - 圆形按钮的事件响应
//

extension MessageInput: CircleViewDelegate {
    
    public func circleViewDidTouchDown(_ circleView: CircleView) {
        circleView.centerColor = configuration.circleButtonBackgroundColorPressed
        circleView.setNeedsDisplay()
    }
    
    public func circleViewDidTouchUp(_ circleView: CircleView, _ inside: Bool, _ isLongPress: Bool) {
        
        if inside {
            if circleView == voiceButton {
                if viewMode == .voice {
                    showKeyboard()
                }
                else {
                    viewMode = .voice
                }
            }
            else if circleView == emotionButton {
                if viewMode == .emotion {
                    showKeyboard()
                }
                else {
                    viewMode = .emotion
                }
            }
            else if circleView == moreButton {
                if viewMode == .more {
                    showKeyboard()
                }
                else {
                    viewMode = .more
                }
            }
        }
        
        circleView.centerColor = configuration.circleButtonBackgroundColorNormal
        circleView.setNeedsDisplay()
    }
    
    public func circleViewDidTouchEnter(_ circleView: CircleView) {
        circleView.centerColor = configuration.circleButtonBackgroundColorPressed
        circleView.setNeedsDisplay()
    }
    
    public func circleViewDidTouchLeave(_ circleView: CircleView) {
        circleView.centerColor = configuration.circleButtonBackgroundColorNormal
        circleView.setNeedsDisplay()
    }
    
}
