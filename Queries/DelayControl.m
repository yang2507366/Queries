//
//  DelayControl.m
//  GewaraSport
//
//  Created by yangzexin on 12-11-28.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "DelayControl.h"

@interface DelayControl ()

@property(nonatomic, copy)void(^completion)();
@property(nonatomic, assign)NSInteger timeInterval;
@property(nonatomic, assign)BOOL performed;

@end

@implementation DelayControl

@synthesize completion;
@synthesize timeInterval;
@synthesize performed;

- (void)dealloc
{
    self.completion = nil;
    [super dealloc];
}

- (id)initWithInterval:(NSTimeInterval)pTimeInterval completion:(void(^)())pCompletion
{
    self = [super init];
    
    self.timeInterval = pTimeInterval;
    self.completion = pCompletion;
    
    return self;
}

- (void)cancel
{
    self.completion = nil;
}

- (void)delayDidFinish
{
    self.performed = YES;
    if(self.completion){
        self.completion();
    }
}

- (void)run
{
    @autoreleasepool {
        [NSThread sleepForTimeInterval:self.timeInterval];
        [self performSelectorOnMainThread:@selector(delayDidFinish) withObject:nil waitUntilDone:YES];
    }
}

- (id)start
{
    self.performed = NO;
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    return self;
}

- (BOOL)providerShouldBeRemoveFromPool
{
    return self.performed;
}

- (void)providerWillRemoveFromPool
{
    [self cancel];
}

@end
