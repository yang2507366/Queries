//
//  CallScriptImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "CallScriptImpl.h"
#import "LuaSystemContext.h"
#import "ScriptInteraction.h"
#import "LuaScriptInteraction.h"
#import "LuaConstants.h"

@implementation CallScriptImpl

+ (BOOL)callScriptWithScriptId:(NSString *)scriptId
{
    id<ScriptInteraction> si = [LuaSystemContext scriptInteractionWithAppId:scriptId];
    if(si){
        [si callFunction:lua_main_function callback:^(NSString *returnValue, NSString *error) {
            D_Log(@"call script with script id:%@, returnValue:%@, error:%@", scriptId, returnValue, error);
        } parameters:nil];
        return YES;
    }
    return NO;
}

@end
