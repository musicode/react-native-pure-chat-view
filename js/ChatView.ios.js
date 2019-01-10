

import React, {
  Component,
} from 'react'

import ReactNative, {
  UIManager,
  requireNativeComponent,
  NativeModules,
} from 'react-native'

import PropTypes from 'prop-types'

const { RNTChatViewManager } = NativeModules

class ChatView extends Component {

  static propTypes = {
    currentUserId: PropTypes.string.isRequired,
    leftUserNameVisible: PropTypes.bool.isRequired,
    rightUserNameVisible: PropTypes.bool.isRequired,
    userAvatarWidth: PropTypes.number.isRequired,
    userAvatarHeight: PropTypes.number.isRequired,
    userAvatarBorderRadius: PropTypes.number.isRequired,

    onReady: PropTypes.func,
    onListClick: PropTypes.func,
    onUserNameClick: PropTypes.func,
    onUserAvatarClick: PropTypes.func,
    onContentClick: PropTypes.func,
    onFailureClick: PropTypes.func,
    onLinkClick: PropTypes.func,
    onCopyClick: PropTypes.func,
    onShareClick: PropTypes.func,
    onRecallClick: PropTypes.func,
    onDeleteClick: PropTypes.func,
    onLoadMore: PropTypes.func,

    onRecordAudioWithoutPermissions: PropTypes.func,
    onRecordAudioDurationLessThanMinDuration: PropTypes.func,
    onRecordAudioPermissionsGranted: PropTypes.func,
    onRecordAudioPermissionsDenied: PropTypes.func,
    onUseCameraWithoutPermissions: PropTypes.func,
    onRecordVideoDurationLessThanMinDuration: PropTypes.func,
    onRecordVideoPermissionsGranted: PropTypes.func,
    onRecordVideoPermissionsDenied: PropTypes.func,

    onSendAudio: PropTypes.func,
    onSendVideo: PropTypes.func,
    onSendPhoto: PropTypes.func,
    onSendText: PropTypes.func,

    onTextChange: PropTypes.func,
    onPhotoFeatureClick: PropTypes.func,
    onLift: PropTypes.func,
    onFall: PropTypes.func,
  }

  appendMessage(message, scrollToBottom) {
    RNTChatViewManager.appendMessage(this.getNativeNode(), message, scrollToBottom ? true : false)
  }

  appendMessages(messages, scrollToBottom) {
    RNTChatViewManager.appendMessages(this.getNativeNode(), messages, scrollToBottom ? true : false)
  }

  prependMessage(message, scrollToBottom) {
    RNTChatViewManager.prependMessage(this.getNativeNode(), message, scrollToBottom ? true : false)
  }

  prependMessages(messages, scrollToBottom) {
    RNTChatViewManager.prependMessages(this.getNativeNode(), messages, scrollToBottom ? true : false)
  }

  removeMessage(messageId, scrollToBottom) {
    RNTChatViewManager.removeMessage(this.getNativeNode(), messageId, scrollToBottom ? true : false)
  }

  removeAllMessages() {
    RNTChatViewManager.removeAllMessages(this.getNativeNode())
  }

  updateMessage(messageId, message, scrollToBottom) {
    RNTChatViewManager.updateMessage(this.getNativeNode(), messageId, message, scrollToBottom ? true : false)
  }

  setAllMessages(messages, scrollToBottom) {
    RNTChatViewManager.setAllMessages(this.getNativeNode(), messages, scrollToBottom ? true : false)
  }

  stopAudio() {
    RNTChatViewManager.stopAudio(this.getNativeNode())
  }

  loadMoreComplete(hasMoreMessage) {
    RNTChatViewManager.loadMoreComplete(this.getNativeNode(), hasMoreMessage ? true : false)
  }

  scrollToBottom(animated) {
    RNTChatViewManager.scrollToBottom(this.getNativeNode(), animated ? true : false)
  }

  setText(text) {
    RNTChatViewManager.setText(this.getNativeNode(), text)
  }

  resetInput() {
    RNTChatViewManager.resetInput(this.getNativeNode())
  }

  handleReady = () => {
    let { onReady } = this.props
    if (onReady) {
      onReady()
    }
  }

  handleListClick = () => {
    let { onListClick } = this.props
    if (onListClick) {
      onListClick()
    }
  }

  handleUserNameClick = (event) => {
    let { onUserNameClick } = this.props
    if (onUserNameClick) {
      onUserNameClick(event.nativeEvent)
    }
  }

  handleUserAvatarClick = (event) => {
    let { onUserAvatarClick } = this.props
    if (onUserAvatarClick) {
      onUserAvatarClick(event.nativeEvent)
    }
  }

  handleContentClick = (event) => {
    let { onContentClick } = this.props
    if (onContentClick) {
      onContentClick(event.nativeEvent)
    }
  }

  handleFailureClick = (event) => {
    let { onFailureClick } = this.props
    if (onFailureClick) {
      onFailureClick(event.nativeEvent)
    }
  }

  handleLinkClick = (event) => {
    let { onLinkClick } = this.props
    if (onLinkClick) {
      onLinkClick(event.nativeEvent)
    }
  }

  handleCopyClick = (event) => {
    let { onCopyClick } = this.props
    if (onCopyClick) {
      onCopyClick(event.nativeEvent)
    }
  }

  handleShareClick = (event) => {
    let { onShareClick } = this.props
    if (onShareClick) {
      onShareClick(event.nativeEvent)
    }
  }

  handleRecallClick = (event) => {
    let { onRecallClick } = this.props
    if (onRecallClick) {
      onRecallClick(event.nativeEvent)
    }
  }

  handleDeleteClick = (event) => {
    let { onDeleteClick } = this.props
    if (onDeleteClick) {
      onDeleteClick(event.nativeEvent)
    }
  }

  handleLoadMore = () => {
    let { onLoadMore } = this.props
    if (onLoadMore) {
      onLoadMore()
    }
  }

  handleRecordAudioWithoutPermissions = () => {
    let { onRecordAudioWithoutPermissions } = this.props
    if (onRecordAudioWithoutPermissions) {
      onRecordAudioWithoutPermissions()
    }
  }

  handleRecordAudioDurationLessThanMinDuration = () => {
    let { onRecordAudioDurationLessThanMinDuration } = this.props
    if (onRecordAudioDurationLessThanMinDuration) {
      onRecordAudioDurationLessThanMinDuration()
    }
  }

  handleRecordAudioPermissionsGranted = () => {
    let { onRecordAudioPermissionsGranted } = this.props
    if (onRecordAudioPermissionsGranted) {
      onRecordAudioPermissionsGranted()
    }
  }

  handleRecordAudioPermissionsDenied = () => {
    let { onRecordAudioPermissionsDenied } = this.props
    if (onRecordAudioPermissionsDenied) {
      onRecordAudioPermissionsDenied()
    }
  }

  handleUseCameraWithoutPermissions = () => {
    let { onUseCameraWithoutPermissions } = this.props
    if (onUseCameraWithoutPermissions) {
      onUseCameraWithoutPermissions()
    }
  }

  handleRecordVideoDurationLessThanMinDuration = () => {
    let { onRecordVideoDurationLessThanMinDuration } = this.props
    if (onRecordVideoDurationLessThanMinDuration) {
      onRecordVideoDurationLessThanMinDuration()
    }
  }

  handleRecordVideoPermissionsGranted = () => {
    let { onRecordVideoPermissionsGranted } = this.props
    if (onRecordVideoPermissionsGranted) {
      onRecordVideoPermissionsGranted()
    }
  }

  handleRecordVideoPermissionsDenied = () => {
    let { onRecordVideoPermissionsDenied } = this.props
    if (onRecordVideoPermissionsDenied) {
      onRecordVideoPermissionsDenied()
    }
  }

  handleSendAudio = (event) => {
    let { onSendAudio } = this.props
    if (onSendAudio) {
      onSendAudio(event.nativeEvent)
    }
  }

  handleSendVideo = (event) => {
    let { onSendVideo } = this.props
    if (onSendVideo) {
      onSendVideo(event.nativeEvent)
    }
  }

  handleSendPhoto = (event) => {
    let { onSendPhoto } = this.props
    if (onSendPhoto) {
      onSendPhoto(event.nativeEvent)
    }
  }

  handleSendText = (event) => {
    let { onSendText } = this.props
    if (onSendText) {
      onSendText(event.nativeEvent)
    }
  }

  handleTextChange = (event) => {
    let { onTextChange } = this.props
    if (onTextChange) {
      onTextChange(event.nativeEvent)
    }
  }

  handlePhotoFeatureClick = () => {
    let { onPhotoFeatureClick } = this.props
    if (onPhotoFeatureClick) {
      onPhotoFeatureClick()
    }
  }

  handleLift = () => {
    let { onLift } = this.props
    if (onLift) {
      onLift()
    }
  }

  handleFall = () => {
    let { onFall } = this.props
    if (onFall) {
      onFall()
    }
  }

  getNativeNode() {
    return ReactNative.findNodeHandle(this.refs.chatView);
  }

  render() {
    return (
      <RNTChatView
        {...this.props}
        ref="chatView"
        onReady={this.handleReady}
        onListClick={this.handleListClick}
        onUserNameClick={this.handleUserNameClick}
        onUserAvatarClick={this.handleUserAvatarClick}
        onContentClick={this.handleContentClick}
        onFailureClick={this.handleFailureClick}
        onLinkClick={this.handleLinkClick}
        onCopyClick={this.handleCopyClick}
        onShareClick={this.handleShareClick}
        onRecallClick={this.handleRecallClick}
        onDeleteClick={this.handleDeleteClick}
        onLoadMore={this.handleLoadMore}

        onRecordAudioWithoutPermissions={this.handleRecordAudioWithoutPermissions}
        onRecordAudioDurationLessThanMinDuration={this.handleRecordAudioDurationLessThanMinDuration}
        onRecordAudioPermissionsGranted={this.handleRecordAudioPermissionsGranted}
        onRecordAudioPermissionsDenied={this.handleRecordAudioPermissionsDenied}
        onUseCameraWithoutPermissions={this.handleUseCameraWithoutPermissions}
        onRecordVideoDurationLessThanMinDuration={this.handleRecordVideoDurationLessThanMinDuration}
        onRecordVideoPermissionsGranted={this.handleRecordVideoPermissionsGranted}
        onRecordVideoPermissionsDenied={this.handleRecordVideoPermissionsDenied}

        onSendAudio={this.handleSendAudio}
        onSendVideo={this.handleSendVideo}
        onSendPhoto={this.handleSendPhoto}
        onSendText={this.handleSendText}

        onTextChange={this.handleTextChange}
        onPhotoFeatureClick={this.handlePhotoFeatureClick}
        onLift={this.handleLift}
        onFall={this.handleFall}
      />
    )
  }
}

const RNTChatView = requireNativeComponent('RNTChatView', ChatView)

export default ChatView