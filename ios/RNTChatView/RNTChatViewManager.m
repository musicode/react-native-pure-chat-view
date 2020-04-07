
#import "RNTChatViewManager.h"

#import <React/RCTUIManager.h>
#import "react_native_pure_chat_view-Swift.h"
#import "RNTChatView.h"

@implementation RNTChatViewManager

RCT_EXPORT_MODULE()

- (RNTChatView *)view {
    return [RNTChatView new];
}

RCT_CUSTOM_VIEW_PROPERTY(currentUserId, NSString, RNTChatView) {
    view.chatView.currentUserId = [RCTConvert NSString:json];
}

RCT_CUSTOM_VIEW_PROPERTY(featureList, NSArray, RNTChatView) {
    NSArray *array = [RCTConvert NSArray:json];
    view.chatView.featureList = array;
}

RCT_CUSTOM_VIEW_PROPERTY(leftUserNameVisible, BOOL, RNTChatView) {
    view.chatView.leftUserNameVisible = [RCTConvert BOOL:json];
}

RCT_CUSTOM_VIEW_PROPERTY(rightUserNameVisible, BOOL, RNTChatView) {
    view.chatView.rightUserNameVisible = [RCTConvert BOOL:json];
}

RCT_CUSTOM_VIEW_PROPERTY(userAvatarWidth, long, RNTChatView) {
    view.chatView.userAvatarWidth = [RCTConvert int:json];
}

RCT_CUSTOM_VIEW_PROPERTY(userAvatarHeight, long, RNTChatView) {
    view.chatView.userAvatarHeight = [RCTConvert int:json];
}

RCT_CUSTOM_VIEW_PROPERTY(userAvatarBorderRadius, long, RNTChatView) {
    view.chatView.userAvatarBorderRadius = [RCTConvert int:json];
}

RCT_EXPORT_VIEW_PROPERTY(onReady, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onListClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onUserNameClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onUserAvatarClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onContentClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onCopyClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onShareClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecallClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onDeleteClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onFailureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLinkClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLoadMore, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onRecordAudioDurationLessThanMinDuration, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordAudioPermissionsNotGranted, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordAudioPermissionsGranted, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordAudioPermissionsDenied, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onSendText, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onSendAudio, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onTextChange, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onPhotoFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onCameraFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onFileFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onUserFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onMovieFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onPhoneFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLocationFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onFavorFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLift, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onFall, RCTBubblingEventBlock);

RCT_EXPORT_METHOD(appendMessage:(nonnull NSNumber *)reactTag message:(NSDictionary *)message scrollToBottom:(BOOL)scrollToBottom) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView appendWithMessage:message];
        if (scrollToBottom) {
            [chatView.chatView scrollToBottomWithAnimated:false];
        }
    }];
}

RCT_EXPORT_METHOD(appendMessages:(nonnull NSNumber *)reactTag messages:(NSArray *)messages scrollToBottom:(BOOL)scrollToBottom) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView appendWithMessages:messages];
        if (scrollToBottom) {
            [chatView.chatView scrollToBottomWithAnimated:false];
        }
    }];
}

RCT_EXPORT_METHOD(prependMessage:(nonnull NSNumber *)reactTag message:(NSDictionary *)message scrollToBottom:(BOOL)scrollToBottom) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView prependWithMessage:message];
        if (scrollToBottom) {
            [chatView.chatView scrollToBottomWithAnimated:false];
        }
    }];
}

RCT_EXPORT_METHOD(prependMessages:(nonnull NSNumber *)reactTag messages:(NSArray *)messages scrollToBottom:(BOOL)scrollToBottom) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView prependWithMessages:messages];
        if (scrollToBottom) {
            [chatView.chatView scrollToBottomWithAnimated:false];
        }
    }];
}

RCT_EXPORT_METHOD(removeMessage:(nonnull NSNumber *)reactTag messageId:(NSString *)messageId scrollToBottom:(BOOL)scrollToBottom) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView removeWithMessageId:messageId];
        if (scrollToBottom) {
            [chatView.chatView scrollToBottomWithAnimated:false];
        }
    }];
}

RCT_EXPORT_METHOD(removeAllMessages:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView removeAll];
    }];
}

RCT_EXPORT_METHOD(updateMessage:(nonnull NSNumber *)reactTag messageId:(NSString *)messageId message:(NSDictionary *)message scrollToBottom:(BOOL)scrollToBottom) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView updateWithMessageId:messageId message:message];
        if (scrollToBottom) {
            [chatView.chatView scrollToBottomWithAnimated:false];
        }
    }];
}

RCT_EXPORT_METHOD(setAllMessages:(nonnull NSNumber *)reactTag messages:(NSArray *)messages scrollToBottom:(BOOL)scrollToBottom) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView setAllWithMessages:messages];
        if (scrollToBottom) {
            [chatView.chatView scrollToBottomWithAnimated:false];
        }
    }];
}

RCT_EXPORT_METHOD(stopAudio:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView stopAudio];
    }];
}

RCT_EXPORT_METHOD(loadMoreComplete:(nonnull NSNumber *)reactTag hasMoreMessage:(BOOL)hasMoreMessage) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView loadMoreCompleteWithHasMoreMessage:hasMoreMessage];
    }];
}

RCT_EXPORT_METHOD(scrollToBottom:(nonnull NSNumber *)reactTag animated:(BOOL)animated) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView scrollToBottomWithAnimated:animated];
    }];
}

RCT_EXPORT_METHOD(resetInput:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView resetInput];
    }];
}

RCT_EXPORT_METHOD(setText:(nonnull NSNumber *)reactTag text:(NSString *)text) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView setText:text];
    }];
}

@end
