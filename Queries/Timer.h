//
//  Timer.h
//  imyvoa
//
//  Created by gewara on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Timer;

@protocol TimerDelegate <NSObject>

@optional
- (void)timer:(Timer *)timer timerRunningWithInterval:(CGFloat)interval;
- (void)timerDidStart:(Timer *)timer;
- (void)timerDidStop:(Timer *)timer;

@end

@interface Timer : NSObject {
    id<TimerDelegate> _delegate;
    
    NSTimeInterval _timeInterval;
    BOOL _running;
}

@property(nonatomic, assign)id<TimerDelegate> delegate;

- (void)startWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)stop;
- (void)cancel;

@end
