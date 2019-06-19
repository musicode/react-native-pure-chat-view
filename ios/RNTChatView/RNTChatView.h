
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
@property (nonatomic, copy) RCTBubblingEventBlock onShareClick;
@property (nonatomic, copy) RCTBubblingEventBlock onRecallClick;
@property (nonatomic, copy) RCTBubblingEventBlock onDeleteClick;
@property (nonatomic, copy) RCTBubblingEventBlock onFailureClick;
@property (nonatomic, copy) RCTBubblingEventBlock onLinkClick;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadMore;

@property (nonatomic, copy) RCTBubblingEventBlock onRecordAudioDurationLessThanMinDuration;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordAudioPermissionsNotGranted;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordAudioPermissionsGranted;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordAudioPermissionsDenied;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordVideoDurationLessThanMinDuration;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordVideoPermissionsNotGranted;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordVideoPermissionsGranted;
@property (nonatomic, copy) RCTBubblingEventBlock onRecordVideoPermissionsDenied;

@property (nonatomic, copy) RCTBubblingEventBlock onSendText;
@property (nonatomic, copy) RCTBubblingEventBlock onSendPhoto;
@property (nonatomic, copy) RCTBubblingEventBlock onSendAudio;
@property (nonatomic, copy) RCTBubblingEventBlock onSendVideo;
@property (nonatomic, copy) RCTBubblingEventBlock onTextChange;
@property (nonatomic, copy) RCTBubblingEventBlock onPhotoFeatureClick;
@property (nonatomic, copy) RCTBubblingEventBlock onFileFeatureClick;
@property (nonatomic, copy) RCTBubblingEventBlock onUserFeatureClick;
@property (nonatomic, copy) RCTBubblingEventBlock onMovieFeatureClick;
@property (nonatomic, copy) RCTBubblingEventBlock onPhoneFeatureClick;
@property (nonatomic, copy) RCTBubblingEventBlock onLocationFeatureClick;
@property (nonatomic, copy) RCTBubblingEventBlock onFavorFeatureClick;

@property (nonatomic, copy) RCTBubblingEventBlock onLift;
@property (nonatomic, copy) RCTBubblingEventBlock onFall;

+ (void)setImageLoader:(void (^ _Null_unspecified)(UIImageView*, NSString*, NSInteger, NSInteger))value;


@end
