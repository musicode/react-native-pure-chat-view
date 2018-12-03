
#import "RNTChatViewManager.h"

#import <React/RCTView.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import "RNTChatView-Swift.h"
#import <MapKit/MapKit.h>
#import "RNTChatView.h"

@implementation RNTChatViewManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [RNTChatView new];
}

RCT_CUSTOM_VIEW_PROPERTY(currentUserId, NSString, RNTChatView) {
    view.chatView.currentUserId = [RCTConvert NSString:json];
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
RCT_EXPORT_VIEW_PROPERTY(onFailureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLinkClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLoadMore, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onRecordAudioWithoutPermissions, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordAudioDurationLessThanMinDuration, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordAudioPermissionsGranted, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordAudioPermissionsDenied, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onUseCameraWithoutPermissions, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordVideoDurationLessThanMinDuration, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordVideoPermissionsGranted, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRecordVideoPermissionsDenied, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onSendText, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onSendPhoto, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onSendAudio, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onSendVideo, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onPhotoFeatureClick, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLift, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onFall, RCTBubblingEventBlock);

RCT_EXPORT_METHOD(appendMessage:(nonnull NSNumber *)reactTag message:(NSDictionary *)message) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView appendWithMessage:message];
    }];
}

RCT_EXPORT_METHOD(appendMessages:(nonnull NSNumber *)reactTag messages:(NSArray *)messages) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView appendWithMessages:messages];
    }];
}

RCT_EXPORT_METHOD(prependMessage:(nonnull NSNumber *)reactTag message:(NSDictionary *)message) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView prependWithMessage:message];
    }];
}

RCT_EXPORT_METHOD(prependMessages:(nonnull NSNumber *)reactTag messages:(NSArray *)messages) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView prependWithMessages:messages];
    }];
}

RCT_EXPORT_METHOD(removeMessage:(nonnull NSNumber *)reactTag messageId:(NSString *)messageId) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView removeWithMessageId:messageId];
    }];
}

RCT_EXPORT_METHOD(removeAllMessages:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView removeAll];
    }];
}

RCT_EXPORT_METHOD(updateMessage:(nonnull NSNumber *)reactTag messageId:(NSString *)messageId message:(NSDictionary *)message) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView updateWithMessageId:messageId message:message];
    }];
}

RCT_EXPORT_METHOD(setAllMessages:(nonnull NSNumber *)reactTag messages:(NSArray *)messages) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNTChatView *chatView = (RNTChatView *)viewRegistry[reactTag];
        [chatView.chatView setAllWithMessages:messages];
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

@end