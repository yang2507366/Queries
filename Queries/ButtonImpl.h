//
//  ButtonImpl.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface ButtonImpl : NSObject

+ (NSString *)createButtonWithTitle:(NSString *)title
                  scriptInteraction:(id<ScriptInteraction>)si
                   callbackFuncName:(NSString *)funcName
                           scriptId:(NSString *)scriptId;
+ (NSString *)createWithScriptId:(NSString *)scriptId
                              si:(id<ScriptInteraction>)si
                           title:(NSString *)title
                           frame:(CGRect)frame
                   eventFuncName:(NSString *)eventFuncName;
@end
