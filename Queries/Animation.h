//
//  AnimationImpl.h
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface AnimationImpl : NSObject

+ (NSString *)animateWithAppId:(NSString *)appId
                            si:(id<ScriptInteraction>)si
                        animId:(NSString *)animId
             animationDuration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                       options:(UIViewAnimationOptions)options
                 animationFunc:(NSString *)animationFuc
                  completeFunc:(NSString *)completeFunc;

@end
