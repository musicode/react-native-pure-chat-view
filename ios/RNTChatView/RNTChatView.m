
@import AVFoundation;

#import "RNTChatView.h"
#import "react_native_pure_chat_view-Swift.h"

@interface RNTChatView()<MessageListDelegate, MessageInputDelegate>

@end

@implementation RNTChatView

+ (void)init:(void (^)(UIImageView *, NSString *, NSInteger, NSInteger))value {
    ChatView.loadImage = value;
    ChatView.setAudioCategory = ^(AVAudioSessionCategory category) {
        [[AVAudioSession sharedInstance] setCategory:category error:nil];
    };
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        ChatView *chatView = [ChatView new];
        [chatView setupWithMessageListDelegate:self messageInputDelegate:self];
        [self addSubview:chatView];
        chatView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.chatView = chatView;
    }
    return self;
}

- (void)didMoveToSuperview {
    self.onReady(@{});
}

- (void)messageListDidClickList {
    self.onListClick(@{});
}

- (void)messageListDidClickUserNameWithMessage:(Message *)message {
    self.onUserNameClick(@{
                           @"messageId": message.id
                           });
}

- (void)messageListDidClickUserAvatarWithMessage:(Message *)message {
    self.onUserAvatarClick(@{
                             @"messageId": message.id
                             });
}

- (void)messageListDidClickContentWithMessage:(Message *)message {
    self.onContentClick(@{
                           @"messageId": message.id
                           });
}

- (void)messageListDidClickCopyWithMessage:(Message *)message {
    self.onCopyClick(@{
                          @"messageId": message.id
                          });
}

- (void)messageListDidClickShareWithMessage:(Message *)message {
    self.onShareClick(@{
                        @"messageId": message.id
                        });
}

- (void)messageListDidClickRecallWithMessage:(Message *)message {
    self.onRecallClick(@{
                        @"messageId": message.id
                        });
}

- (void)messageListDidClickDeleteWithMessage:(Message *)message {
    self.onDeleteClick(@{
                        @"messageId": message.id
                        });
}

- (void)messageListDidClickFailureWithMessage:(Message *)message {
    self.onFailureClick(@{
                           @"messageId": message.id
                           });
}

- (void)messageListDidClickLinkWithLink:(NSString *)link {
    self.onLinkClick(@{
                          @"link": link
                          });
}

- (void)messageListDidLoadMore {
    self.onLoadMore(@{});
}

- (void)messageListWillUseAudio {
    [self.chatView ensureInputAudioAvailable];
}

- (void)messageInputWillUseAudio {
    [self.chatView ensureListAudioAvailable];
}

- (void)messageInputDidRecordAudioDurationLessThanMinDuration {
    self.onRecordAudioDurationLessThanMinDuration(@{});
}

- (void)messageInputDidRecordAudioPermissionsNotGranted {
    self.onRecordAudioPermissionsNotGranted(@{});
}

- (void)messageInputDidRecordAudioPermissionsGranted {
    self.onRecordAudioPermissionsGranted(@{});
}

- (void)messageInputDidRecordAudioPermissionsDenied {
    self.onRecordAudioPermissionsDenied(@{});
}

- (void)messageInputDidSendTextWithText:(NSString *)text {
    self.onSendText(@{
                      @"text": text
                      });
}

- (void)messageInputDidSendEmotionWithEmotion:(Emotion *)emotion {

}

- (void)messageInputDidSendAudioWithAudioPath:(NSString *)audioPath audioDuration:(NSInteger)audioDuration {
    self.onSendAudio(@{
                       @"audioPath": audioPath,
                       @"audioDuration": @(audioDuration)
                       });
}

- (void)messageInputDidClickPhotoFeature {
    self.onPhotoFeatureClick(@{});
}

- (void)messageInputDidClickCameraFeature {
    self.onCameraFeatureClick(@{});
}

- (void)messageInputDidClickFileFeature {
    self.onFileFeatureClick(@{});
}

- (void)messageInputDidClickUserFeature {
    self.onUserFeatureClick(@{});
}

- (void)messageInputDidClickMovieFeature {
    self.onMovieFeatureClick(@{});
}

- (void)messageInputDidClickPhoneFeature {
    self.onPhoneFeatureClick(@{});
}

- (void)messageInputDidClickLocationFeature {
    self.onLocationFeatureClick(@{});
}

- (void)messageInputDidClickFavorFeature {
    self.onFavorFeatureClick(@{});
}

- (void)messageInputDidTextChangeWithText:(NSString *)text {
    self.onTextChange(@{
                        @"text": text
                        });
}

- (void)messageInputDidLift {
    self.onLift(@{});
}

- (void)messageInputDidFall {
    self.onFall(@{});
}

@end
