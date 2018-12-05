
import React, {
  Component,
} from 'react'

import ReactNative, {
  UIManager,
  requireNativeComponent
} from 'react-native'

import PropTypes from 'prop-types'

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
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.appendMessage,
      [message, scrollToBottom ? true : false],
    )
  }

  appendMessages(messages, scrollToBottom) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.appendMessages,
      [messages, scrollToBottom ? true : false],
    )
  }

  prependMessage(message, scrollToBottom) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.prependMessage,
      [message, scrollToBottom ? true : false],
    )
  }

  prependMessages(messages, scrollToBottom) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.prependMessages,
      [messages, scrollToBottom ? true : false],
    )
  }

  removeMessage(messageId, scrollToBottom) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.removeMessage,
      [messageId, scrollToBottom ? true : false],
    )
  }

  removeAllMessages() {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.removeAllMessages,
      null,
    )
  }

  updateMessage(messageId, message, scrollToBottom) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.updateMessage,
      [messageId, message, scrollToBottom ? true : false],
    )
  }

  setAllMessages(messages, scrollToBottom) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.setAllMessages,
      [messages, scrollToBottom ? true : false],
    )
  }

  stopAudio() {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.stopAudio,
      null,
    )
  }

  loadMoreComplete(hasMoreMessage) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.loadMoreComplete,
      [hasMoreMessage ? true : false],
    )
  }

  scrollToBottom(animated) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.scrollToBottom,
      [animated ? true : false],
    )
  }

  setText(text) {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.setText,
      [text]
    )
  }

  resetInput() {
    UIManager.dispatchViewManagerCommand(
      this.getNativeNode(),
      UIManager.RNTChatView.Commands.resetInput,
      null
    )
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