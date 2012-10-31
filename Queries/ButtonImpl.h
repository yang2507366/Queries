//
//  ButtonImpl.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface ButtonImpl : UIButton

+ (NSString *)createWithScriptId:(NSString *)scriptId
                              si:(id<ScriptInteraction>)si
                           title:(NSString *)title
                           frame:(CGRect)frame
                   eventFuncName:(NSString *)eventFuncName;
+ (NSString *)createWithScriptId:(NSString *)scriptId si:(id<ScriptInteraction>)si type:(UIButtonType)type tappedFunc:(NSString *)tappedFunc;
@end
