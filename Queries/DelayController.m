
#import "DelayController.h"


@implementation DelayController

@synthesize delayTime;
@synthesize delegate = _delegate;

- (id)initWithInterval:(NSTimeInterval)interval
{
    self = [super init];
    
    delayTime = interval;
    
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    [super dealloc];
}

- (void)notifyFinished
{
    if(_delegate && [_delegate respondsToSelector:@selector(delayControllerDidFinishDelay:)]){
        [_delegate delayControllerDidFinishDelay:self];
    }
}

- (void)run
{
    @autoreleasepool {
        [NSThread sleepForTimeInterval:delayTime];
        [self performSelectorOnMainThread:@selector(notifyFinished) withObject:nil waitUntilDone:YES];
    }
}

- (void)start
{
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

- (void)cancel
{
    if([_delegate respondsToSelector:@selector(delayControllerDidCancelDelay:)]){
        [_delegate delayControllerDidCancelDelay:self];
    }
    _delegate = nil;
}

@end