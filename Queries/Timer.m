//
//  Timer.m
//  imyvoa
//
//  Created by gewara on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Timer.h"

@implementation Timer

@synthesize delegate = _delegate;

- (void)dealloc
{
//    NSLog(@"Timer:%@ dealloc", self);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    _timeInterval = 0.0f;
    _running = NO;
    
    return self;
}

- (void)run
{
    @autoreleasepool{
//        NSLog(@"timer start, %@", [NSThread currentThread]);
        while(_running){
            [self performSelectorOnMainThread:@selector(notifyRunning) withObject:nil waitUntilDone:YES];
            [NSThread sleepForTimeInterval:_timeInterval];
        }
//        NSLog(@"timer stop, %@", [NSThread currentThread]);
    }
}

- (void)notifyRunning
{
    if([self.delegate respondsToSelector:@selector(timer:timerRunningWithInterval:)]){
        [self.delegate timer:self timerRunningWithInterval:_timeInterval];
    }
}

- (void)startWithTimeInterval:(NSTimeInterval)timeInterval
{
    _running = NO;
    [self performSelector:@selector(delayStart) withObject:nil afterDelay:_timeInterval + 0.1];
    _timeInterval = timeInterval;
}

- (void)delayStart
{
    _running = YES;
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    if([self.delegate respondsToSelector:@selector(timerDidStart:)]){
        [self.delegate timerDidStart:self];
    }
}

- (void)stop
{
    _running = NO;
    if([self.delegate respondsToSelector:@selector(timerDidStop:)]){
        [self.delegate timerDidStop:self];
    }
}

- (void)cancel
{
    [self stop];
    self.delegate = nil;
}

@end
