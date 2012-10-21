//
//  CallScriptImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "CallScriptImpl.h"
#import "LuaApplication.h"
#import "ScriptInteraction.h"
#import "LuaScriptInteraction.h"
#import "LuaConstants.h"

@implementation CallScriptImpl

+ (BOOL)callScriptWithScriptId:(NSString *)scriptId
{
    NSString *script = [LuaApplication scriptWithScriptId:scriptId];
    if(script.length != 0){
        id<ScriptInteraction> si = [[[LuaScriptInteraction alloc] initWithScript:script] autorelease];
        [si callFunction:lua_main_function callback:^(NSString *returnValue, NSString *error) {
            NSLog(@"call script with script id:%@, returnValue:%@, error:%@", scriptId, returnValue, error);
        } parameters:nil];
        return YES;
    }else{
        NSLog(@"call script with script id:%@ error, script not found", scriptId);
    }
    return NO;
}

@end
