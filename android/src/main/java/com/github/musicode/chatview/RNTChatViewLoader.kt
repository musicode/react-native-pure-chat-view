package com.github.musicode.chatview

import android.widget.ImageView

interface RNTChatViewLoader {
    fun loadImage(imageView: ImageView, url: String, width: Int, height: Int)
}
