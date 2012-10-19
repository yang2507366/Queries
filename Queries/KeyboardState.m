//
//  KeyboardState.m
//  Badminton
//
//  Created by gewara on 12-3-16.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "KeyboardState.h"

@implementation KeyboardState

@synthesize keyboardVisible = _keyboardVisible;

+ (KeyboardState *)sharedInstance
{
    static KeyboardState *instance = nil;
    if(!instance){
        instance = [[KeyboardState alloc] init];
    }
    return instance;
}
- (void)dealloc
{
    [self stopListen];
    
    [super dealloc];
}
- (id)init
{
    self = [super init];
    
    return self;
}

#pragma mark - instance methods
- (void)startListen
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onKeyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onKeyboardDidHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
}
- (void)stopListen
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notifications
- (void)onKeyboardDidShow:(NSNotification *)n
{
    _keyboardVisible = YES;
}
- (void)onKeyboardDidHide:(NSNotification *)n
{
    _keyboardVisible = NO;
}

#pragma mark - override
- (oneway void)release
{
    
}
- (id)retain
{
    return self;
}
- (id)autorelease
{
    return self;
}

@end
