package com.github.musicode.chatview

import android.app.Activity
import android.text.SpannableString
import android.view.Choreographer
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.facebook.react.bridge.*
import com.github.herokotlin.emotioninput.filter.EmojiFilter
import com.github.herokotlin.emotioninput.model.EmotionSet
import com.github.herokotlin.messageinput.MessageInput
import com.github.herokotlin.messageinput.MessageInputCallback
import com.github.herokotlin.messagelist.MessageList
import com.github.herokotlin.messagelist.MessageListCallback
import com.github.herokotlin.messagelist.MessageListConfiguration
import com.github.herokotlin.messagelist.model.*
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.github.herokotlin.emotioninput.model.Emotion
import com.github.herokotlin.messageinput.MessageInputConfiguration
import com.github.herokotlin.messagelist.enum.MessageStatus
import com.facebook.react.modules.core.PermissionAwareActivity
import com.facebook.react.ReactActivity
import com.facebook.react.uimanager.ThemedReactContext
import com.github.herokotlin.messageinput.enum.FeatureType
import com.github.herokotlin.messagelist.enum.FileIcon

class RNTChatView(context: ThemedReactContext, val appContext: ReactApplicationContext, loadImage: (ImageView, String, Int, Int) -> Unit): LinearLayout(context) {

    var currentUserId = ""

    var featureList = ArrayList<Any>()

        set(value) {
            field = value
            messageInputConfiguration.featureList = value.map {
                when (it as String) {
                    "photo" -> {
                        FeatureType.PHOTO
                    }
                    "camera" -> {
                        FeatureType.CAMERA
                    }
                    "file" -> {
                        FeatureType.FILE
                    }
                    "user" -> {
                        FeatureType.USER
                    }
                    "movie" -> {
                        FeatureType.MOVIE
                    }
                    "phone" -> {
                        FeatureType.PHONE
                    }
                    "favor" -> {
                        FeatureType.FAVOR
                    }
                    else -> {
                        FeatureType.LOCATION
                    }
                }
            }
        }

    var inputVisible = false

        set(value) {
            field = value
            if (value) {
                messageInput.visibility = View.VISIBLE
            }
            else {
                messageInput.visibility = View.GONE
            }
        }

    var leftUserNameVisible = false

        set(value) {
            field = value
            messageListConfiguration.leftUserNameVisible = value
        }

    var rightUserNameVisible = false

        set(value) {
            field = value
            messageListConfiguration.rightUserNameVisible = value
        }

    var userAvatarWidth = 0

        set(value) {
            field = value
            messageListConfiguration.userAvatarWidth = value
        }

    var userAvatarHeight = 0

        set(value) {
            field = value
            messageListConfiguration.userAvatarHeight = value
        }

    var userAvatarBorderRadius = 0

        set(value) {
            field = value
            messageListConfiguration.userAvatarBorderRadius = value.toFloat()
        }

    var activity: Activity = appContext.currentActivity!!

    private var messageListConfiguration: MessageListConfiguration
    private var messageInputConfiguration: MessageInputConfiguration

    var messageList: MessageList

    lateinit var messageInput: MessageInput

    private var permissionListener = { requestCode: Int, permissions: Array<out String>?, grantResults: IntArray? ->
        if (permissions != null && grantResults != null) {
            messageInput.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
        true
    }

    private val frameCallback = object : Choreographer.FrameCallback {
        override fun doFrame(frameTimeNanos: Long) {
            for (i in 0 until childCount) {
                val child = getChildAt(i)
                child.measure(MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY),
                        MeasureSpec.makeMeasureSpec(measuredHeight, MeasureSpec.EXACTLY))
                child.layout(0, 0, child.measuredWidth, child.measuredHeight)
            }
            viewTreeObserver.dispatchOnGlobalLayout()
            Choreographer.getInstance().postFrameCallback(this)
        }
    }

    fun destroy() {
        messageInput.activity = null
        Choreographer.getInstance().removeFrameCallback(frameCallback)
    }

    init {

        LayoutInflater.from(activity).inflate(R.layout.rnt_chatview, this)

        Choreographer.getInstance().postFrameCallback(frameCallback)

        messageInput = findViewById(R.id.messageInput)
        messageList = findViewById(R.id.messageList)

        val emotionList = listOf(
            Emotion("😄", localImage = R.drawable.emoji_1f604),
            Emotion("😷", localImage = R.drawable.emoji_1f637),
            Emotion("😂", localImage = R.drawable.emoji_1f602),
            Emotion("😝", localImage = R.drawable.emoji_1f61d),
            Emotion("😳", localImage = R.drawable.emoji_1f633),
            Emotion("😱", localImage = R.drawable.emoji_1f631),
            Emotion("😔", localImage = R.drawable.emoji_1f614),
            Emotion("😒", localImage = R.drawable.emoji_1f612),
            Emotion("🤗", localImage = R.drawable.emoji_1f917),
            Emotion("🙂", localImage = R.drawable.emoji_1f642),
            Emotion("😊", localImage = R.drawable.emoji_1f60a),
            Emotion("😋", localImage = R.drawable.emoji_1f60b),
            Emotion("😌", localImage = R.drawable.emoji_1f60c),
            Emotion("😍", localImage = R.drawable.emoji_1f60d),
            Emotion("😎", localImage = R.drawable.emoji_1f60e),
            Emotion("😪", localImage = R.drawable.emoji_1f62a),
            Emotion("😓", localImage = R.drawable.emoji_1f613),
            Emotion("😭", localImage = R.drawable.emoji_1f62d),
            Emotion("😘", localImage = R.drawable.emoji_1f618),
            Emotion("😏", localImage = R.drawable.emoji_1f60f),
            Emotion("😚", localImage = R.drawable.emoji_1f61a),
            Emotion("😛", localImage = R.drawable.emoji_1f61b),
            Emotion("😜", localImage = R.drawable.emoji_1f61c),


            Emotion("💪", localImage = R.drawable.emoji_1f4aa),
            Emotion("👊", localImage = R.drawable.emoji_1f44a),
            Emotion("👍", localImage = R.drawable.emoji_1f44d),
            Emotion("🤘", localImage = R.drawable.emoji_1f918),
            Emotion("👏", localImage = R.drawable.emoji_1f44f),
            Emotion("👋", localImage = R.drawable.emoji_1f44b),
            Emotion("🙌", localImage = R.drawable.emoji_1f64c),
            Emotion("🖐", localImage = R.drawable.emoji_1f590),
            Emotion("🖖", localImage = R.drawable.emoji_1f596),
            Emotion("👎", localImage = R.drawable.emoji_1f44e),
            Emotion("🙏", localImage = R.drawable.emoji_1f64f),
            Emotion("👌", localImage = R.drawable.emoji_1f44c),
            Emotion("👈", localImage = R.drawable.emoji_1f448),
            Emotion("👉", localImage = R.drawable.emoji_1f449),
            Emotion("👆", localImage = R.drawable.emoji_1f446),
            Emotion("👇", localImage = R.drawable.emoji_1f447),
            Emotion("🎃", localImage = R.drawable.emoji_1f383),
            Emotion("👀", localImage = R.drawable.emoji_1f440),
            Emotion("👃", localImage = R.drawable.emoji_1f443),
            Emotion("👄", localImage = R.drawable.emoji_1f444),
            Emotion("👂", localImage = R.drawable.emoji_1f442),
            Emotion("👻", localImage = R.drawable.emoji_1f47b),
            Emotion("💋", localImage = R.drawable.emoji_1f48b),



            Emotion("😞", localImage = R.drawable.emoji_1f61e),
            Emotion("😟", localImage = R.drawable.emoji_1f61f),
            Emotion("😫", localImage = R.drawable.emoji_1f62b),
            Emotion("😮", localImage = R.drawable.emoji_1f62e),
            Emotion("😯", localImage = R.drawable.emoji_1f62f),
            Emotion("😉", localImage = R.drawable.emoji_1f609),
            Emotion("😡", localImage = R.drawable.emoji_1f621),
            Emotion("😢", localImage = R.drawable.emoji_1f622),
            Emotion("😣", localImage = R.drawable.emoji_1f623),
            Emotion("😤", localImage = R.drawable.emoji_1f624),
            Emotion("😥", localImage = R.drawable.emoji_1f625),
            Emotion("😧", localImage = R.drawable.emoji_1f627),
            Emotion("😨", localImage = R.drawable.emoji_1f628),
            Emotion("😩", localImage = R.drawable.emoji_1f629),
            Emotion("😲", localImage = R.drawable.emoji_1f632),
            Emotion("😴", localImage = R.drawable.emoji_1f634),
            Emotion("😵", localImage = R.drawable.emoji_1f635),
            Emotion("🙄", localImage = R.drawable.emoji_1f644),
            Emotion("🤒", localImage = R.drawable.emoji_1f912),
            Emotion("🤓", localImage = R.drawable.emoji_1f913),
            Emotion("🤔", localImage = R.drawable.emoji_1f914)
        )

        val emojiFilter = EmojiFilter(emotionList)

        messageListConfiguration = object: MessageListConfiguration(messageList.context) {

            override fun formatText(textView: TextView, text: SpannableString) {
                emojiFilter.filter(textView, text, text.toString(), 1f)
            }

            override fun isRightMessage(message: Message): Boolean {
                return message.user.id == currentUserId
            }

            override fun loadImage(imageView: ImageView, url: String, width: Int, height: Int) {
                loadImage(imageView, url, width, height)
            }

        }

        messageInputConfiguration = object: MessageInputConfiguration(context) {

            override fun loadImage(imageView: ImageView, url: String) {
               loadImage(imageView, url, 40, 40)
            }

        }

        messageInputConfiguration.audioBitRate = 128000
        messageInputConfiguration.audioSampleRate = 44100
        messageInputConfiguration.emotionTextHeightRatio = 1f

        messageInput.init(

            messageInputConfiguration,

            object: MessageInputCallback {

                override fun onRequestPermissions(activity: Activity, permissions: Array<out String>, requestCode: Int) {
                    if (activity is ReactActivity) {
                        activity.requestPermissions(permissions, requestCode, permissionListener)
                    }
                    else if (activity is PermissionAwareActivity) {
                        (activity as PermissionAwareActivity).requestPermissions(permissions, requestCode, permissionListener)
                    }
                }

                override fun onRecordAudioDurationLessThanMinDuration() {
                    sendEvent("onRecordAudioDurationLessThanMinDuration")
                }

                override fun onRecordAudioExternalStorageNotWritable() {
                    sendEvent("onRecordAudioExternalStorageNotWritable")
                }

                override fun onRecordAudioPermissionsNotGranted() {
                    sendEvent("onRecordAudioPermissionsNotGranted")
                }

                override fun onRecordAudioPermissionsGranted() {
                    sendEvent("onRecordAudioPermissionsGranted")
                }

                override fun onRecordAudioPermissionsDenied() {
                    sendEvent("onRecordAudioPermissionsDenied")
                }

                override fun onUseAudio() {
                    messageList.ensureAudioAvailable()
                }

                override fun onSendAudio(audioPath: String, audioDuration: Int) {
                    val event = Arguments.createMap()
                    event.putString("audioPath", audioPath)
                    event.putInt("audioDuration", audioDuration)
                    sendEvent("onSendAudio", event)
                }

                override fun onSendText(text: String) {
                    val event = Arguments.createMap()
                    event.putString("text", text)
                    sendEvent("onSendText", event)
                }

                override fun onTextChange(text: String) {
                    val event = Arguments.createMap()
                    event.putString("text", text)
                    sendEvent("onTextChange", event)
                }

                override fun onClickPhotoFeature() {
                    sendEvent("onClickPhotoFeature")
                }

                override fun onClickCameraFeature() {
                    sendEvent("onClickCameraFeature")
                }

                override fun onClickFileFeature() {
                    sendEvent("onClickFileFeature")
                }

                override fun onClickUserFeature() {
                    sendEvent("onClickUserFeature")
                }

                override fun onClickMovieFeature() {
                    sendEvent("onClickMovieFeature")
                }

                override fun onClickPhoneFeature() {
                    sendEvent("onClickPhoneFeature")
                }

                override fun onClickLocationFeature() {
                    sendEvent("onClickLocationFeature")
                }

                override fun onClickFavorFeature() {
                    sendEvent("onClickFavorFeature")
                }

                override fun onLift() {
                    sendEvent("onLift")
                }

                override fun onFall() {
                    sendEvent("onFall")
                }

            }
        )

        messageInput.activity = activity

        messageList.init(
            messageListConfiguration,
            object: MessageListCallback {
                override fun onListClick() {
                    sendEvent("onListClick")
                }

                override fun onUserNameClick(message: Message) {
                    val event = Arguments.createMap()
                    event.putString("messageId", message.id)
                    sendEvent("onUserNameClick", event)
                }

                override fun onUserAvatarClick(message: Message) {
                    val event = Arguments.createMap()
                    event.putString("messageId", message.id)
                    sendEvent("onUserAvatarClick", event)
                }

                override fun onContentClick(message: Message) {
                    val event = Arguments.createMap()
                    event.putString("messageId", message.id)
                    sendEvent("onContentClick", event)
                }

                override fun onCopyClick(message: Message) {
                    val event = Arguments.createMap()
                    event.putString("messageId", message.id)
                    sendEvent("onCopyClick", event)
                }

                override fun onShareClick(message: Message) {
                    val event = Arguments.createMap()
                    event.putString("messageId", message.id)
                    sendEvent("onShareClick", event)
                }

                override fun onRecallClick(message: Message) {
                    val event = Arguments.createMap()
                    event.putString("messageId", message.id)
                    sendEvent("onRecallClick", event)
                }

                override fun onDeleteClick(message: Message) {
                    val event = Arguments.createMap()
                    event.putString("messageId", message.id)
                    sendEvent("onDeleteClick", event)
                }

                override fun onFailureClick(message: Message) {
                    val event = Arguments.createMap()
                    event.putString("messageId", message.id)
                    sendEvent("onFailureClick", event)
                }

                override fun onLinkClick(link: String) {
                    val event = Arguments.createMap()
                    event.putString("link", link)
                    sendEvent("onLinkClick", event)
                }

                override fun onLoadMore() {
                    sendEvent("onLoadMore")
                }

                override fun onUseAudio() {
                    messageInput.ensureAudioAvailable()
                }

            }
        )

        messageInput.setEmotionSetList(listOf(
            EmotionSet.build(
                R.drawable.emoji_icon,
                emotionList,
                7,
                3,
                90,
                90,
                true,
                true
            )
        ))

        messageInput.addEmotionFilter(emojiFilter)

        post {
            sendEvent("onReady")
        }

    }

    fun appendMessage(data: ReadableMap) {
        messageList.append(formatMessage(data))
    }

    fun appendMessages(data: ReadableArray) {
        val list = mutableListOf<Message>()
        for (i in 0 until data.size()) {
            list.add(formatMessage(data.getMap(i)!!))
        }
        messageList.append(list)
    }

    fun prependMessage(data: ReadableMap) {
        messageList.prepend(formatMessage(data))
    }

    fun prependMessages(data: ReadableArray) {
        val list = mutableListOf<Message>()
        for (i in 0 until data.size()) {
            list.add(formatMessage(data.getMap(i)!!))
        }
        messageList.prepend(list)
    }

    fun removeMessage(messageId: String) {
        messageList.remove(messageId)
    }

    fun removeAllMessages() {
        messageList.removeAll()
    }

    fun updateMessage(messageId: String, data: ReadableMap) {
        messageList.update(messageId, formatMessage(data))
    }

    fun setAllMessages(data: ReadableArray) {
        messageList.removeAll()
        appendMessages(data)
    }

    fun scrollToBottom(animated: Boolean) {
        messageList.scrollToBottom(animated)
    }

    fun loadMoreComplete(hasMoreMessage: Boolean) {
        messageList.loadMoreComplete(hasMoreMessage)
    }

    fun stopAudio() {
        messageList.stopAudio()
    }

    fun setText(text: String) {
        messageInput.setText(text)
    }

    fun resetInput() {
        messageInput.reset()
    }

    private fun formatMessage(message: ReadableMap): Message {

        val userMap = message.getMap("user")!!
        val user = User(userMap.getString("id")!!, userMap.getString("name")!!, userMap.getString("avatar")!!)

        val status = when (message.getInt("status")) {
            1 -> {
                MessageStatus.SEND_ING
            }
            2 -> {
                MessageStatus.SEND_SUCCESS
            }
            else -> {
                MessageStatus.SEND_FAILURE
            }
        }


        val canCopy = if (message.hasKey("canCopy")) message.getBoolean("canCopy") else false
        val canShare = if (message.hasKey("canShare")) message.getBoolean("canShare") else false
        val canRecall = if (message.hasKey("canRecall")) message.getBoolean("canRecall") else false
        val canDelete = if (message.hasKey("canDelete")) message.getBoolean("canDelete") else false

        return when (message.getInt("type")) {
            1 -> {
                TextMessage(
                    message.getString("id")!!,
                    user,
                    status,
                    message.getString("time")!!,
                    canCopy,
                    canShare,
                    canRecall,
                    canDelete,
                    message.getString("text")!!
                )
            }
            2 -> {
                ImageMessage(
                    message.getString("id")!!,
                    user,
                    status,
                    message.getString("time")!!,
                    canCopy,
                    canShare,
                    canRecall,
                    canDelete,
                    message.getString("url")!!,
                    message.getInt("width"),
                    message.getInt("height")
                )
            }
            3 -> {
                AudioMessage(
                    message.getString("id")!!,
                    user,
                    status,
                    message.getString("time")!!,
                    canCopy,
                    canShare,
                    canRecall,
                    canDelete,
                    message.getString("url")!!,
                    message.getInt("duration")
                )
            }
            4 -> {
                VideoMessage(
                    message.getString("id")!!,
                    user,
                    status,
                    message.getString("time")!!,
                    canCopy,
                    canShare,
                    canRecall,
                    canDelete,
                    message.getString("url")!!,
                    message.getInt("duration"),
                    message.getString("thumbnail")!!,
                    message.getInt("width"),
                    message.getInt("height")
                )
            }
            5 -> {
                CardMessage(
                    message.getString("id")!!,
                    user,
                    status,
                    message.getString("time")!!,
                    canCopy,
                    canShare,
                    canRecall,
                    canDelete,
                    message.getString("thumbnail")!!,
                    message.getString("title")!!,
                    message.getString("desc")!!,
                    message.getString("label")!!,
                    message.getString("link")!!
                )
            }
            6 -> {
                PostMessage(
                    message.getString("id")!!,
                    user,
                    status,
                    message.getString("time")!!,
                    canCopy,
                    canShare,
                    canRecall,
                    canDelete,
                    message.getString("thumbnail")!!,
                    message.getString("title")!!,
                    message.getString("desc")!!,
                    message.getString("label")!!,
                    message.getString("link")!!
                )
            }
            7 -> {
                FileMessage(
                    message.getString("id")!!,
                    user,
                    status,
                    message.getString("time")!!,
                    canCopy,
                    canShare,
                    canRecall,
                    canDelete,
                    when (message.getInt("icon")) {
                        1 -> {
                            FileIcon.WORD
                        }
                        2 -> {
                            FileIcon.EXCEL
                        }
                        3 -> {
                            FileIcon.PPT
                        }
                        4 -> {
                            FileIcon.PDF
                        }
                        else -> {
                            FileIcon.TXT
                        }
                    },
                    message.getString("title")!!,
                    message.getString("desc")!!,
                    message.getString("link")!!
                )
            }
            else -> {
                EventMessage(
                    message.getString("id")!!,
                    user,
                    status,
                    message.getString("time")!!,
                    canCopy,
                    canShare,
                    canRecall,
                    canDelete,
                    message.getString("event")!!
                )
            }
        }

    }

    private fun sendEvent(name: String, event: WritableMap) {
        val reactContext = context as ReactContext
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(id, name, event)
    }

    private fun sendEvent(name: String) {
        val reactContext = context as ReactContext
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(id, name, null)
    }

}
