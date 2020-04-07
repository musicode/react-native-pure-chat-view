import React, {
  PureComponent,
} from 'react'

import ReactNative, {
  requireNativeComponent,
  NativeModules,
} from 'react-native'

import PropTypes from 'prop-types'

const { RNTChatViewManager } = NativeModules

class ChatView extends PureComponent {

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

    onRecordAudioDurationLessThanMinDuration: PropTypes.func,
    onRecordAudioExternalStorageNotWritable: PropTypes.func,
    onRecordAudioPermissionsNotGranted: PropTypes.func,
    onRecordAudioPermissionsGranted: PropTypes.func,
    onRecordAudioPermissionsDenied: PropTypes.func,

    onSendAudio: PropTypes.func,
    onSendText: PropTypes.func,

    onTextChange: PropTypes.func,
    onPhotoFeatureClick: PropTypes.func,
    onCameraFeatureClick: PropTypes.func,
    onFileFeatureClick: PropTypes.func,
    onUserFeatureClick: PropTypes.func,
    onMovieFeatureClick: PropTypes.func,
    onPhoneFeatureClick: PropTypes.func,
    onLocationFeatureClick: PropTypes.func,
    onFavorFeatureClick: PropTypes.func,
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

  handleRecordAudioDurationLessThanMinDuration = () => {
    let { onRecordAudioDurationLessThanMinDuration } = this.props
    if (onRecordAudioDurationLessThanMinDuration) {
      onRecordAudioDurationLessThanMinDuration()
    }
  }

  handleRecordAudioExternalStorageNotWritable = () => {
    let { onRecordAudioExternalStorageNotWritable } = this.props
    if (onRecordAudioExternalStorageNotWritable) {
      onRecordAudioExternalStorageNotWritable()
    }
  }

  handleRecordAudioPermissionsNotGranted = () => {
    let { onRecordAudioPermissionsNotGranted } = this.props
    if (onRecordAudioPermissionsNotGranted) {
      onRecordAudioPermissionsNotGranted()
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

  handleSendAudio = (event) => {
    let { onSendAudio } = this.props
    if (onSendAudio) {
      onSendAudio(event.nativeEvent)
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

  handleCameraFeatureClick = () => {
    let { onCameraFeatureClick } = this.props
    if (onCameraFeatureClick) {
      onCameraFeatureClick()
    }
  }

  handleFileFeatureClick = () => {
    let { onFileFeatureClick } = this.props
    if (onFileFeatureClick) {
      onFileFeatureClick()
    }
  }

  handleUserFeatureClick = () => {
    let { onUserFeatureClick } = this.props
    if (onUserFeatureClick) {
      onUserFeatureClick()
    }
  }

  handleMovieFeatureClick = () => {
    let { onMovieFeatureClick } = this.props
    if (onMovieFeatureClick) {
      onMovieFeatureClick()
    }
  }

  handlePhoneFeatureClick = () => {
    let { onPhoneFeatureClick } = this.props
    if (onPhoneFeatureClick) {
      onPhoneFeatureClick()
    }
  }

  handleLocationFeatureClick = () => {
    let { onLocationFeatureClick } = this.props
    if (onLocationFeatureClick) {
      onLocationFeatureClick()
    }
  }

  handleFavorFeatureClick = () => {
    let { onFavorFeatureClick } = this.props
    if (onFavorFeatureClick) {
      onFavorFeatureClick()
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

        onRecordAudioDurationLessThanMinDuration={this.handleRecordAudioDurationLessThanMinDuration}
        onRecordAudioExternalStorageNotWritable={this.handleRecordAudioExternalStorageNotWritable}
        onRecordAudioPermissionsNotGranted={this.handleRecordAudioPermissionsNotGranted}
        onRecordAudioPermissionsGranted={this.handleRecordAudioPermissionsGranted}
        onRecordAudioPermissionsDenied={this.handleRecordAudioPermissionsDenied}

        onSendAudio={this.handleSendAudio}
        onSendText={this.handleSendText}

        onTextChange={this.handleTextChange}
        onPhotoFeatureClick={this.handlePhotoFeatureClick}
        onCameraFeatureClick={this.handleCameraFeatureClick}
        onFileFeatureClick={this.handleFileFeatureClick}
        onUserFeatureClick={this.handleUserFeatureClick}
        onMovieFeatureClick={this.handleMovieFeatureClick}
        onPhoneFeatureClick={this.handlePhoneFeatureClick}
        onLocationFeatureClick={this.handleLocationFeatureClick}
        onFavorFeatureClick={this.handleFavorFeatureClick}
        onLift={this.handleLift}
        onFall={this.handleFall}
      />
    )
  }
}

const RNTChatView = requireNativeComponent('RNTChatView', ChatView)

export default ChatView