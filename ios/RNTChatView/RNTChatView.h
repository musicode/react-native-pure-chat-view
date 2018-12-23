
#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>

@class ChatView;

@interface RNTChatView : UIView

@property (nonatomic, weak) ChatView *chatView;

@property (nonatomic, copy) RCTBubblingEventBlock onReady;

@property (nonatomic, copy) RCTBubblingEventBlock onListClick;
@property (nonatomic, copy) RCTBubblingEventBlock onUserNameClick;
@property (nonatomic, copy) RCTBubblingEventBlock onUserAvatarClick;
@property (nonatomic, copy) RCTBubblingEventBlock onContentClick;
@property (nonatomic, copy) RCTBubblingEventBlock onCopyClick;
@property (nonatomic, copy) RCTBubblingEventBlock onFailureClick;
@property (nonatomic, copy) RCTBubblingEventBlock onLinkClick;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadMore;

@property (nonatomic, copy) RCTBubblingEventBlock onRecordAudioWithoutPermissions;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordAudioDurationLessThanMinDuration;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordAudioPermissionsGranted;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordAudioPermissionsDenied;
@property (nonatomic, copy) RCTBubblingEventBlock onUseCameraWithoutPermissions;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordVideoDurationLessThanMinDuration;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordVideoPermissionsGranted;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordVideoPermissionsDenied;

@property (nonatomic, copy) RCTBubblingEventBlock onSendText;
@property (nonatomic, copy) RCTBubblingEventBlock onSendPhoto;
@property (nonatomic, copy) RCTBubblingEventBlock onSendAudio;
@property (nonatomic, copy) RCTBubblingEventBlock onSendVideo;
@property (nonatomic, copy) RCTBubblingEventBlock onTextChange;
@property (nonatomic, copy) RCTBubblingEventBlock onPhotoFeatureClick;

@property (nonatomic, copy) RCTBubblingEventBlock onLift;
@property (nonatomic, copy) RCTBubblingEventBlock onFall;

+ (void)setImageLoader:(void (^ _Null_unspecified)(UIImageView * imageView, NSString * url))value;

@end
