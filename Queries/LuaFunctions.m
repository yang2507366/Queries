//
//  LuaFunctions.c
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#include "LuaFunctions.h"
#include <stdio.h>
#import "LuaHTTPRequest.h"
#import "LuaScriptManager.h"
#import "LuaScriptInteraction.h"

int http_request(lua_State *L)
{
    const char *scriptId = lua_tostring(L, 1);
    const char *url = lua_tostring(L, 2);
    const char *callbackFuncName = lua_tostring(L, 3);
    NSLog(@"http_request:%s, %s, %s", scriptId, url, callbackFuncName);
    LuaScriptInteraction *si = [[LuaScriptInteraction alloc] initWithScript:[[LuaScriptManager sharedManager] scriptForIdentifier:[NSString stringWithFormat:@"%s", scriptId]]];
    NSString *requestId = [LuaHTTPRequest requestWithLuaState:si urlString:[NSString stringWithFormat:@"%s", url]
                                      callbackLuaFunctionName:[NSString stringWithFormat:@"%s", callbackFuncName]];
    lua_pushstring(L, [requestId UTF8String]);
    return 1;
}

int http_request_cancel(lua_State *L)
{
    const char *requestId = lua_tostring(L, 1);
    NSLog(@"http_request_cancel:%s", requestId);
    [LuaHTTPRequest cancelRequestWithRequestId:[NSString stringWithFormat:@"%s", requestId]];
    lua_pushstring(L, "true");
    return 1;
}

void pushFunctionToLua(lua_State *L, char *functionName, int (*func)(lua_State *L))
{
    lua_pushstring(L, functionName);
    lua_pushcfunction(L, func);
    lua_settable(L, LUA_GLOBALSINDEX);
}

void initFuntions(lua_State *L)
{
    pushFunctionToLua(L, "http_request", http_request);
    pushFunctionToLua(L, "http_request_cancel", http_request_cancel);
}