
@class DelayController;

@protocol DelayControllerDelegate <NSObject>

@optional
- (void)delayControllerDidFinishDelay:(DelayController *)controller;
- (void)delayControllerDidCancelDelay:(DelayController *)controller;

@end

@interface DelayController : NSObject {
    NSTimeInterval delayTime;
    id<DelayControllerDelegate> _delegate;
}

@property(nonatomic, assign)id<DelayControllerDelegate> delegate;
@property(nonatomic, readonly)NSTimeInterval delayTime;

- (id)initWithInterval:(NSTimeInterval)interval;
- (void)cancel;
- (void)start;

@end