//
//  RNTChatView.m
//  RNTChatView
//
//  Created by zhujl on 2018/12/1.
//  Copyright © 2018年 finstao. All rights reserved.
//

#import "RNTChatView.h"
#import "RNTChatView-Swift.h"

@interface RNTChatView()<MessageListDelegate, MessageInputDelegate>

@end

@implementation RNTChatView

+ (void)setLoadImage:(void (^ _Null_unspecified)(UIImageView * _Nonnull, NSString * _Nonnull))value
{
    ChatView.loadImage = value;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        ChatView *chatView = [ChatView new];
        [chatView setupWithMessageListDelegate:self messageInputDelegate:self];
        [self addSubview:chatView];
        chatView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _chatView = chatView;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.onReady(@{});
        });
    }
    return self;
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

- (void)messageInputWillRecordAudioWithoutPermissions {
    self.onRecordAudioWithoutPermissions(@{});
}

- (void)messageInputDidRecordAudioDurationLessThanMinDuration {
    self.onRecordAudioDurationLessThanMinDuration(@{});
}

- (void)messageInputDidRecordAudioPermissionsGranted {
    self.onRecordAudioPermissionsGranted(@{});
}

- (void)messageInputDidRecordAudioPermissionsDenied {
    self.onRecordAudioPermissionsDenied(@{});
}

- (void)messageInputWillUseCameraWithoutPermissions {
    self.onUseCameraWithoutPermissions(@{});
}

- (void)messageInputDidRecordVideoDurationLessThanMinDuration {
    self.onRecordVideoDurationLessThanMinDuration(@{});
}

- (void)messageInputDidRecordVideoPermissionsGranted {
    self.onRecordVideoPermissionsGranted(@{});
}

- (void)messageInputDidRecordVideoPermissionsDenied {
    self.onRecordVideoPermissionsDenied(@{});
}

- (void)messageInputDidSendTextWithText:(NSString *)text {
    self.onSendText(@{
                      @"text": text
                      });
}

- (void)messageInputDidSendPhotoWithPhoto:(ImageFile *)photo {
    self.onSendPhoto(@{
                       @"photoPath": photo.path,
                       @"photoWidth": [NSNumber numberWithFloat:photo.width],
                       @"photoHeight": [NSNumber numberWithFloat:photo.height]
                       });
}

- (void)messageInputDidSendEmotionWithEmotion:(Emotion *)emotion {
    NSLog(@"send emotion");
}

- (void)messageInputDidSendAudioWithAudioPath:(NSString *)audioPath audioDuration:(NSInteger)audioDuration {
    self.onSendAudio(@{
                       @"audioPath": audioPath,
                       @"audioDuration": [NSNumber numberWithInt:audioDuration]
                       });
}

- (void)messageInputDidSendVideoWithVideoPath:(NSString *)videoPath videoDuration:(NSInteger)videoDuration thumbnail:(ImageFile *)thumbnail {
    self.onSendVideo(@{
                       @"videoPath": videoPath,
                       @"videoDuration": [NSNumber numberWithInt:videoDuration],
                       @"thumbnailPath": thumbnail.path,
                       @"thumbnailWidth": [NSNumber numberWithFloat:thumbnail.width],
                       @"thumbnailHeight": [NSNumber numberWithFloat:thumbnail.height],
                       });
}

- (void)messageInputDidClickPhotoFeature {
    self.onPhotoFeatureClick(@{});
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
