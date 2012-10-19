//
//  KeyboardState.h
//  Badminton
//
//  Created by gewara on 12-3-16.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardState : NSObject {
    BOOL _keyboardVisible;
}

@property(nonatomic, readonly)BOOL keyboardVisible;

+ (KeyboardState *)sharedInstance;

- (void)startListen;
- (void)stopListen;

@end
