package com.github.musicode;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nullable;

public class RNTChatViewManager extends SimpleViewManager<RNTChatView> {

    private static final int COMMAND_APPEND_MESSAGE = 1;
    private static final int COMMAND_APPEND_MESSAGES = 2;
    private static final int COMMAND_PREPEND_MESSAGE = 3;
    private static final int COMMAND_PREPEND_MESSAGES = 4;
    private static final int COMMAND_REMOVE_MESSAGE = 5;
    private static final int COMMAND_REMOVE_ALL_MESSAGES = 6;
    private static final int COMMAND_UPDATE_MESSAGE = 7;
    private static final int COMMAND_SET_ALL_MESSAGES = 8;

    private static final int COMMAND_LOAD_MORE_COMPLETE = 9;
    private static final int COMMAND_SCROLL_TO_BOTTOM = 10;
    private static final int COMMAND_STOP_AUDIO = 11;
    private static final int COMMAND_SET_TEXT = 12;
    private static final int COMMAND_RESET_INPUT = 13;

    private final ReactApplicationContext reactContext;

    // 主工程实现图片加载
    public static ImageLoader imageLoader;

    public RNTChatViewManager(ReactApplicationContext reactContext) {
        super();
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNTChatView";
    }

    @Override
    protected RNTChatView createViewInstance(ThemedReactContext reactContext) {
        return new RNTChatView(reactContext, this.reactContext, imageLoader);
    }

    @ReactProp(name = "currentUserId")
    public void setCurrentUserId(RNTChatView view, String currentUserId) {
        view.setCurrentUserId(currentUserId);
    }

    @ReactProp(name = "leftUserNameVisible", defaultBoolean = false)
    public void setLeftUserNameVisible(RNTChatView view, boolean leftUserNameVisible) {
        view.setLeftUserNameVisible(leftUserNameVisible);
    }

    @ReactProp(name = "rightUserNameVisible", defaultBoolean = false)
    public void setRightUserNameVisible(RNTChatView view, boolean rightUserNameVisible) {
        view.setRightUserNameVisible(rightUserNameVisible);
    }

    @ReactProp(name = "userAvatarWidth", defaultInt = 0)
    public void setUserAvatarWidth(RNTChatView view, int userAvatarWidth) {
        view.setUserAvatarWidth(userAvatarWidth);
    }

    @ReactProp(name = "userAvatarHeight", defaultInt = 0)
    public void setUserAvatarHeight(RNTChatView view, int userAvatarHeight) {
        view.setUserAvatarHeight(userAvatarHeight);
    }

    @ReactProp(name = "userAvatarBorderRadius", defaultInt = 0)
    public void setUserAvatarBorderRadius(RNTChatView view, int userAvatarBorderRadius) {
        view.setUserAvatarBorderRadius(userAvatarBorderRadius);
    }


    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {

        return MapBuilder.builder()
                .put("onReady", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onReady")))
                .put("onListClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onListClick")))
                .put("onUserNameClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onUserNameClick")))
                .put("onUserAvatarClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onUserAvatarClick")))
                .put("onContentClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onContentClick")))
                .put("onFailureClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onFailureClick")))
                .put("onLinkClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLinkClick")))
                .put("onLoadMore", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLoadMore")))

                .put("onRecordAudioWithoutPermissions", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioWithoutPermissions")))
                .put("onRecordAudioDurationLessThanMinDuration", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioDurationLessThanMinDuration")))
                .put("onRecordAudioWithoutExternalStorage", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioWithoutExternalStorage")))
                .put("onRecordAudioPermissionsGranted", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioPermissionsGranted")))
                .put("onRecordAudioPermissionsDenied", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordAudioPermissionsDenied")))
                .put("onRecordVideoPermissionsGranted", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordVideoPermissionsGranted")))
                .put("onRecordVideoPermissionsDenied", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onRecordVideoPermissionsDenied")))

                .put("onSendAudio", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSendAudio")))
                .put("onSendVideo", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSendVideo")))
                .put("onSendPhoto", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSendPhoto")))
                .put("onSendText", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSendText")))

                .put("onTextChange", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onTextChange")))
                .put("onClickPhotoFeature", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onPhotoFeatureClick")))
                .put("onLift", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLift")))
                .put("onFall", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onFall")))
                .build();
    }

    @Override
    public @Nullable Map<String, Integer> getCommandsMap() {
        Map<String, Integer> commands = new HashMap<>();
        commands.put("appendMessage", COMMAND_APPEND_MESSAGE);
        commands.put("appendMessages", COMMAND_APPEND_MESSAGES);
        commands.put("prependMessage", COMMAND_PREPEND_MESSAGE);
        commands.put("prependMessages", COMMAND_PREPEND_MESSAGES);
        commands.put("removeMessage", COMMAND_REMOVE_MESSAGE);
        commands.put("removeAllMessages", COMMAND_REMOVE_ALL_MESSAGES);
        commands.put("updateMessage", COMMAND_UPDATE_MESSAGE);
        commands.put("setAllMessages", COMMAND_SET_ALL_MESSAGES);
        commands.put("loadMoreComplete", COMMAND_LOAD_MORE_COMPLETE);
        commands.put("scrollToBottom", COMMAND_SCROLL_TO_BOTTOM);
        commands.put("stopAudio", COMMAND_STOP_AUDIO);
        commands.put("setText", COMMAND_SET_TEXT);
        commands.put("resetInput", COMMAND_RESET_INPUT);
        return commands;
    }

    @Override
    public void receiveCommand(RNTChatView root, int commandId, @Nullable ReadableArray args) {

        switch (commandId) {
            case COMMAND_APPEND_MESSAGE:
                root.appendMessage(args.getMap(0));
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false);
                }
                break;
            case COMMAND_APPEND_MESSAGES:
                root.appendMessages(args.getArray(0));
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false);
                }
                break;
            case COMMAND_PREPEND_MESSAGE:
                root.prependMessage(args.getMap(0));
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false);
                }
                break;
            case COMMAND_PREPEND_MESSAGES:
                root.prependMessages(args.getArray(0));
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false);
                }
                break;

            case COMMAND_REMOVE_MESSAGE:
                root.removeMessage(args.getString(0));
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false);
                }
                break;
            case COMMAND_REMOVE_ALL_MESSAGES:
                root.removeAllMessages();
                break;
            case COMMAND_UPDATE_MESSAGE:
                root.updateMessage(args.getString(0), args.getMap(1));
                if (args.getBoolean(2)) {
                    root.scrollToBottom(false);
                }
                break;
            case COMMAND_SET_ALL_MESSAGES:
                root.setAllMessages(args.getArray(0));
                if (args.getBoolean(1)) {
                    root.scrollToBottom(false);
                }
                break;

            case COMMAND_LOAD_MORE_COMPLETE:
                root.loadMoreComplete(args.getBoolean(0));
                break;
            case COMMAND_SCROLL_TO_BOTTOM:
                root.scrollToBottom(args.getBoolean(0));
                break;
            case COMMAND_STOP_AUDIO:
                root.stopAudio();
                break;
            case COMMAND_SET_TEXT:
                root.setText(args.getString(0));
                break;
            case COMMAND_RESET_INPUT:
                root.resetInput();
                break;
        }

    }

}