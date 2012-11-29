//
//  AnimationImpl.m
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIAnimation.h"

@implementation LIAnimation

+ (NSString *)animateWithAppId:(NSString *)appId
                            si:(id<ScriptInteraction>)si
                        animId:(NSString *)animId
             animationDuration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                       options:(UIViewAnimationOptions)options
                 animationFunc:(NSString *)animationFuc
                  completeFunc:(NSString *)completeFunc
{
    [UIView animateWithDuration:duration delay:delay options:options animations:^{
        [si callFunction:animationFuc parameters:animId, nil];
    } completion:^(BOOL finished) {
        [si callFunction:completeFunc parameters:animId, nil];
    }];
    return animId;
}

@end
