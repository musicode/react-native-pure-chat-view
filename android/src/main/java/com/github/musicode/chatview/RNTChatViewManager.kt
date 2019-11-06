package com.github.musicode.chatview

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

import java.util.HashMap

class RNTChatViewManager(private val reactContext: ReactApplicationContext) : SimpleViewManager<RNTChatView>() {

    override fun getName(): String {
        return "RNTChatView"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): RNTChatView {
        return RNTChatView(reactContext, this.reactContext, imageLoader)
    }

    @ReactProp(name = "currentUserId")
    fun setCurrentUserId(view: RNTChatView, currentUserId: String) {
        view.currentUserId = currentUserId
    }

    @ReactProp(name = "featureList")
    fun setFeatureList(view: RNTChatView, featureList: ReadableArray) {
        view.featureList = featureList.toArrayList()
    }

    @ReactProp(name = "leftUserNameVisible", defaultBoolean = false)
    fun setLeftUserNameVisible(view: RNTChatView, leftUserNameVisible: Boolean) {
        view.leftUserNameVisible = leftUserNameVisible
    }

    @ReactProp(name = "rightUserNameVisible", defaultBoolean = false)
    fun setRightUserNameVisible(view: RNTChatView, rightUserNameVisible: Boolean) {
        view.rightUserNameVisible = rightUserNameVisible
    }

    @ReactProp(name = "userAvatarWidth", defaultInt = 0)
    fun setUserAvatarWidth(view: RNTChatView, userAvatarWidth: Int) {
        view.userAvatarWidth = userAvatarWidth
    }

    @ReactProp(name = "userAvatarHeight", defaultInt = 0)
    fun setUserAvatarHeight(view: RNTChatView, userAvatarHeight: Int) {
        view.userAvatarHeight = userAvatarHeight
    }

    @ReactProp(name = "userAvatarBorderRadius", defaultInt = 0)
    fun setUserAvatarBorderRadius(view: RNTChatView, userAvatarBorderRadius: Int) {
        view.userAvatarBorderRadius = userAvatarBorderRadius
    }

    override fun getExportedCustomBubblingEventTypeConstants(): MutableMap<String, Any> {
        return MapBuilder.builder<String, Any>()
                .put("onReady", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onReady")))
                .put("onListClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onListClick")))
                .put("onUserNameClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onUserNameClick")))
                .put("onUserAvatarClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onUserAvatarClick")))
                .put("onContentClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onContentClick")))
                .put("onCopyClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onCopyClick")))
                .put("onShareClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onShareClick")))
                .put("onRecallClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecallClick")))
                .put("onDeleteClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onDeleteClick")))
                .put("onFailureClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onFailureClick")))
                .put("onLinkClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLinkClick")))
                .put("onLoadMore", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLoadMore")))


                .put("onRecordAudioDurationLessThanMinDuration", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioDurationLessThanMinDuration")))
                .put("onRecordAudioExternalStorageNotWritable", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioExternalStorageNotWritable")))
                .put("onRecordAudioPermissionsNotGranted", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioPermissionsNotGranted")))
                .put("onRecordAudioPermissionsGranted", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioPermissionsGranted")))
                .put("onRecordAudioPermissionsDenied", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioPermissionsDenied")))

                .put("onRecordVideoExternalStorageNotWritable", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordVideoExternalStorageNotWritable")))
                .put("onRecordVideoPermissionsNotGranted", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordVideoPermissionsNotGranted")))
                .put("onRecordVideoPermissionsGranted", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordVideoPermissionsGranted")))
                .put("onRecordVideoPermissionsDenied", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordVideoPermissionsDenied")))

                .put("onSendAudio", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSendAudio")))
                .put("onSendVideo", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSendVideo")))
                .put("onSendPhoto", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSendPhoto")))
                .put("onSendText", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSendText")))

                .put("onTextChange", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onTextChange")))
                .put("onClickPhotoFeature", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onPhotoFeatureClick")))
                .put("onClickFileFeature", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onFileFeatureClick")))
                .put("onClickUserFeature", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onUserFeatureClick")))
                .put("onClickMovieFeature", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onMovieFeatureClick")))
                .put("onClickPhoneFeature", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onPhoneFeatureClick")))
                .put("onClickLocationFeature", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLocationFeatureClick")))
                .put("onClickFavorFeature", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onFavorFeatureClick")))
                .put("onLift", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLift")))
                .put("onFall", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onFall")))
                .build()
    }

    override fun getCommandsMap(): MutableMap<String, Int> {
        val commands = HashMap<String, Int>()
        commands["appendMessage"] = COMMAND_APPEND_MESSAGE
        commands["appendMessages"] = COMMAND_APPEND_MESSAGES
        commands["prependMessage"] = COMMAND_PREPEND_MESSAGE
        commands["prependMessages"] = COMMAND_PREPEND_MESSAGES
        commands["removeMessage"] = COMMAND_REMOVE_MESSAGE
        commands["removeAllMessages"] = COMMAND_REMOVE_ALL_MESSAGES
        commands["updateMessage"] = COMMAND_UPDATE_MESSAGE
        commands["setAllMessages"] = COMMAND_SET_ALL_MESSAGES
        commands["loadMoreComplete"] = COMMAND_LOAD_MORE_COMPLETE
        commands["scrollToBottom"] = COMMAND_SCROLL_TO_BOTTOM
        commands["stopAudio"] = COMMAND_STOP_AUDIO
        commands["setText"] = COMMAND_SET_TEXT
        commands["resetInput"] = COMMAND_RESET_INPUT
        return commands
    }

    override fun receiveCommand(root: RNTChatView, commandId: Int, args: ReadableArray?) {

        when (commandId) {
            COMMAND_APPEND_MESSAGE -> {
                root.appendMessage(args!!.getMap(0)!!)
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false)
                }
            }
            COMMAND_APPEND_MESSAGES -> {
                root.appendMessages(args!!.getArray(0)!!)
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false)
                }
            }
            COMMAND_PREPEND_MESSAGE -> {
                root.prependMessage(args!!.getMap(0)!!)
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false)
                }
            }
            COMMAND_PREPEND_MESSAGES -> {
                root.prependMessages(args!!.getArray(0)!!)
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false)
                }
            }

            COMMAND_REMOVE_MESSAGE -> {
                root.removeMessage(args!!.getString(0)!!)
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false)
                }
            }
            COMMAND_REMOVE_ALL_MESSAGES -> root.removeAllMessages()
            COMMAND_UPDATE_MESSAGE -> {
                root.updateMessage(args!!.getString(0)!!, args.getMap(1)!!)
                if (args.getBoolean(2)) {
                    root.scrollToBottom(false)
                }
            }
            COMMAND_SET_ALL_MESSAGES -> {
                root.setAllMessages(args!!.getArray(0)!!)
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false)
                }
            }

            COMMAND_LOAD_MORE_COMPLETE -> root.loadMoreComplete(args!!.getBoolean(0))
            COMMAND_SCROLL_TO_BOTTOM -> root.scrollToBottom(args!!.getBoolean(0))
            COMMAND_STOP_AUDIO -> root.stopAudio()
            COMMAND_SET_TEXT -> root.setText(args!!.getString(0)!!)
            COMMAND_RESET_INPUT -> root.resetInput()
        }

    }

    override fun onDropViewInstance(view: RNTChatView) {
        super.onDropViewInstance(view)
        view.destroy()
    }

    companion object {

        private const val COMMAND_APPEND_MESSAGE = 1
        private const val COMMAND_APPEND_MESSAGES = 2
        private const val COMMAND_PREPEND_MESSAGE = 3
        private const val COMMAND_PREPEND_MESSAGES = 4
        private const val COMMAND_REMOVE_MESSAGE = 5
        private const val COMMAND_REMOVE_ALL_MESSAGES = 6
        private const val COMMAND_UPDATE_MESSAGE = 7
        private const val COMMAND_SET_ALL_MESSAGES = 8

        private const val COMMAND_LOAD_MORE_COMPLETE = 9
        private const val COMMAND_SCROLL_TO_BOTTOM = 10
        private const val COMMAND_STOP_AUDIO = 11
        private const val COMMAND_SET_TEXT = 12
        private const val COMMAND_RESET_INPUT = 13

        // 主工程实现图片加载
        lateinit var imageLoader: RNTChatViewLoader

    }

}