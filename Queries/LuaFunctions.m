//
//  LuaFunctions.c
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#include "LuaFunctions.h"
#include <stdio.h>
#import "LuaHTTPRequestImpl.h"
#import "LuaApplication.h"
#import "LuaScriptInteraction.h"
#import "LuaUIRelatedImpl.h"
#import "CodeUtils.h"

NSString *readParamValue(lua_State *L, int location)
{
    const char *paramValue = lua_tostring(L, location);
    NSString *paramString = @"";
    if(paramValue){
        paramString = [NSString stringWithFormat:@"%s", paramValue];
    }
    paramString = [CodeUtils decodeAllChinese:paramString];
    if(paramString.length == 0){
        paramString = @"";
    }
    return paramString;
}

id<ScriptInteraction>getScriptInteraction(NSString *scriptId)
{
    NSString *script = [LuaApplication scriptWithScriptId:scriptId];
    id<ScriptInteraction> si = [[[LuaScriptInteraction alloc] initWithScript:script]  autorelease];
    
    return si;
}

#pragma mark - network
int http_request(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *url = readParamValue(L, 2);
    NSString *callbackFuncName = readParamValue(L, 3);
    NSLog(@"http_request:%@, %@, %@", scriptId, url, callbackFuncName);
    LuaScriptInteraction *si = getScriptInteraction(scriptId);
    NSString *requestId = [LuaHTTPRequestImpl requestWithLuaState:si urlString:url
                                      callbackLuaFunctionName:callbackFuncName];
    lua_pushstring(L, [requestId UTF8String]);
    return 1;
}

int http_request_cancel(lua_State *L)
{
    NSString *requestId = readParamValue(L, 1);
    NSLog(@"http_request_cancel:%@", requestId);
    [LuaHTTPRequestImpl cancelRequestWithRequestId:requestId];
    
    return 0;
}

#pragma mark - UI
int ui_create_button(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *title = readParamValue(L, 2);
    NSString *callback = readParamValue(L, 3);
    NSLog(@"ui_create_button:%@", title);
    id<ScriptInteraction> si = getScriptInteraction(scriptId);
    NSString *buttonId = [LuaUIRelatedImpl createButtonWithTitle:title
                                                    scriptInteraction:si
                                                     callbackFuncName:callback];
    lua_pushstring(L, [buttonId UTF8String]);
    return 1;
}

int ui_add_subview_to_view_controller(lua_State *L)
{
    NSString *viewId = readParamValue(L, 1);
    NSString *viewControllerId = readParamValue(L, 2);
    [LuaUIRelatedImpl addSubViewWithViewId:viewId
                                viewControllerId:viewControllerId];
    return 0;
}

int ui_set_view_frame(lua_State *L)
{
    NSString *viewId = readParamValue(L, 1);
    NSString *frame = readParamValue(L, 2);
    
    [LuaUIRelatedImpl setViewFrameWithViewId:viewId
                                            frame:frame];
    
    return 0;
}

int ui_get_view_frame(lua_State *L)
{
    NSString *viewId = readParamValue(L, 1);
    CGRect frame = [LuaUIRelatedImpl frameOfViewWithViewId:viewId];
    lua_pushnumber(L, frame.origin.x);
    lua_pushnumber(L, frame.origin.y);
    lua_pushnumber(L, frame.size.width);
    lua_pushnumber(L, frame.size.height);
    return 4;
}

int ui_alert(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *title = readParamValue(L, 2);
    NSString *msg = readParamValue(L, 3);
    NSString *funcName = readParamValue(L, 4);
    [LuaUIRelatedImpl alertWithTitle:title message:msg
                        scriptInteraction:getScriptInteraction(scriptId)
                         callbackFuncName:funcName];
    return 0;
}

int ui_create_view_controller(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *title = readParamValue(L, 2);
    NSString *viewDidLoadFunc = readParamValue(L, 3);
    NSString *viewWillAppearFunc = readParamValue(L, 4);
    
    NSString *vcId = [LuaUIRelatedImpl createViewControllerWithTitle:title
                                                   scriptInteraction:getScriptInteraction(scriptId)
                                                     viewDidLoadFunc:viewDidLoadFunc
                                                  viewWillAppearFunc:viewWillAppearFunc];
    lua_pushstring(L, [vcId UTF8String]);
    return 1;
}

int ui_set_root_view_controller(lua_State *L)
{
    NSString *viewControllerId = readParamValue(L, 1);
    [LuaUIRelatedImpl setRootViewControllerWithId:viewControllerId];
    return 0;
}

#pragma mark - system
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
    pushFunctionToLua(L, "ui_create_button", ui_create_button);
    pushFunctionToLua(L, "ui_add_subview_to_view_controller", ui_add_subview_to_view_controller);
    pushFunctionToLua(L, "ui_set_view_frame", ui_set_view_frame);
    pushFunctionToLua(L, "ui_get_view_frame", ui_get_view_frame);
    pushFunctionToLua(L, "ui_alert", ui_alert);
    pushFunctionToLua(L, "ui_create_view_controller", ui_create_view_controller);
    pushFunctionToLua(L, "ui_set_root_view_controller", ui_set_root_view_controller);
}






