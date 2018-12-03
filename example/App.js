/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, NativeModules, requireNativeComponent} from 'react-native';

import ChatView from 'react-native-pure-chat-view'

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};

const currentUserId = '1'

export default class App extends Component<Props> {

  handleListClick = () => {
    this.refs.chatView.resetInput()
  }

  handleUserNameClick = data => {
    console.log('handleUserNameClick', data)
  }

  handleUserAvatarClick = data => {
    console.log('handleUserAvatarClick', data)
  }

  handleFailureClick = data => {
    console.log('handleFailureClick', data)
  }

  handleLinkClick = data => {
    console.log('handleLinkClick', data)
  }

  handleLoadMore = () => {
    console.log('load more')
    this.refs.chatView.loadMoreComplete(true)
    this.refs.chatView.prependMessages([
      this.getTextMessage('历史消息1'),
      this.getTextMessage('历史消息2'),
      this.getTextMessage('历史消息3'),
    ])
  }

  handleSendText = data => {
    let message
    let random = Math.random()
    if (random > 0.7) {
      message = this.getEventMessage(data.text)
    }
    else if (random > 0.5) {
      message = this.getPostMessage(data.text)
    }
    else if (random > 0.3) {
      message = this.getCardMessage(data.text)
    }
    else {
      message = this.getTextMessage(data.text)
    }

    this.refs.chatView.appendMessages([message])
    this.refs.chatView.scrollToBottom(true)
  }

  handleSendPhoto = data => {
    this.refs.chatView.appendMessage({
      type: 2,
      id: '123',
      user: this.getUser(),
      status: this.getStatus(),
      time: '12:12',
      url: data.photoPath,
      width: data.photoWidth,
      height: data.photoHeight
    })
    this.refs.chatView.scrollToBottom(true)
  }

  handleSendAudio = data => {
    this.refs.chatView.appendMessage({
      type: 3,
      id: '123',
      user: this.getUser(),
      status: this.getStatus(),
      time: '12:12',
      url: data.audioPath,
      duration: Math.floor(data.audioDuration / 1000)
    })
    this.refs.chatView.scrollToBottom(true)
  }

  handleSendVideo = data => {
    this.refs.chatView.appendMessage({
      type: 4,
      id: '123',
      user: this.getUser(),
      status: this.getStatus(),
      time: '12:12',
      url: data.videoPath,
      duration: Math.floor(data.videoDuration / 1000),
      thumbnail: data.thumbnailPath,
      width: data.thumbnailWidth,
      height: data.thumbnailHeight
    })
    this.refs.chatView.scrollToBottom(true)
  }

  getTextMessage(text) {
    return {
      type: 1,
      id: '123',
      user: this.getUser(),
      status: this.getStatus(),
      time: '12:12',
      text: text
    }
  }

  getCardMessage(title) {
    return {
      type: 5,
      id: '123',
      user: this.getUser(),
      status: this.getStatus(),
      time: '12:12',
      thumbnail: 'http://img.zcool.cn/community/0441e45674d7dd00000138c47483e2.jpg',
      title: title,
      desc: '哈哈哈哈哈哈哈哈哈',
      label: '分享',
      link: '随便写一个',
    }
  }

  getPostMessage(title) {
    return {
      type: 6,
      id: '123',
      user: this.getUser(),
      status: this.getStatus(),
      time: '12:12',
      thumbnail: 'http://img.zcool.cn/community/0441e45674d7dd00000138c47483e2.jpg',
      title: title,
      desc: '哈哈哈哈哈哈哈哈哈',
      label: '分享',
      link: '随便写一个',
    }
  }

  getEventMessage(event) {
    return {
      type: 7,
      id: '123',
      user: this.getUser(),
      status: this.getStatus(),
      time: '12:12',
      event: event,
    }
  }

  getStatus() {
    const random = Math.random()
    if (random > 0.66) {
      return 3
    }
    else if (random > 0.33) {
      return 2
    }
    else {
      return 1
    }
  }

  getUser() {
    return {
      id: Math.random() > 0.5 ? currentUserId : '123',
      name: 'musicode',
      avatar: 'http://img.zcool.cn/community/0441e45674d7dd00000138c47483e2.jpg'
    }
  }

  handleLift = () => {
    this.refs.chatView.scrollToBottom(true)
  }

  render() {
    return (
      <ChatView
        ref="chatView"
        style={{flex: 1}}
        currentUserId={currentUserId}
        leftUserNameVisible={false}
        rightUserNameVisible={false}
        userAvatarWidth={40}
        userAvatarHeight={40}
        userAvatarBorderRadius={20}
        onListClick={this.handleListClick}
        onUserNameClick={this.handleUserNameClick}
        onUserAvatarClick={this.handleUserAvatarClick}
        onFailureClick={this.handleFailureClick}
        onLinkClick={this.handleLinkClick}
        onLoadMore={this.handleLoadMore}
        onSendText={this.handleSendText}
        onSendPhoto={this.handleSendPhoto}
        onSendAudio={this.handleSendAudio}
        onSendVideo={this.handleSendVideo}
        onRecordAudioWithoutPermissions={() => {
          console.log('onRecordAudioWithoutPermissions')
        }}
        onRecordAudioDurationLessThanMinDuration={() => {
          console.log('onRecordAudioDurationLessThanMinDuration')
        }}
        onRecordAudioPermissionsGranted={() => {
          console.log('onRecordAudioPermissionsGranted')
        }}
        onRecordAudioPermissionsDenied={() => {
          console.log('onRecordAudioPermissionsDenied')
        }}
        onUseCameraWithoutPermissions={() => {
          console.log('onUseCameraWithoutPermissions')
        }}
        onRecordVideoDurationLessThanMinDuration={() => {
          console.log('onRecordVideoDurationLessThanMinDuration')
        }}
        onRecordVideoPermissionsGranted={() => {
          console.log('onRecordVideoPermissionsGranted')
        }}
        onRecordVideoPermissionsDenied={() => {
          console.log('onRecordVideoPermissionsDenied')
        }}
        onLift={this.handleLift}
      />
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
