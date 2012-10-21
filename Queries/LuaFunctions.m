//
//  LuaFunctions.c
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#include "LuaFunctions.h"
#include <stdio.h>
#import "HTTPRequestImpl.h"
#import "LuaApplication.h"
#import "LuaScriptInteraction.h"
#import "UIRelatedImpl.h"
#import "CodeUtils.h"
#import "CallScriptImpl.h"
#import "RuntimeImpl.h"
#import "TextFieldImpl.h"
#import "ButtonImpl.h"

#pragma mark - common
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
    id<ScriptInteraction> si = [LuaApplication programWithScriptId:scriptId];
    
    return si;
}

CGRect readRect(NSString *frame)
{
    NSArray *attrs = [frame componentsSeparatedByString:@","];
    CGRect tmpRect = CGRectMake(0, 0, 80, 30);
    if(attrs.count == 4){
        tmpRect.origin.x = [attrs[0] floatValue];
        tmpRect.origin.y = [attrs[1] floatValue];
        tmpRect.size.width = [attrs[2] floatValue];
        tmpRect.size.height = [attrs[3] floatValue];
    }
    return tmpRect;
}

#pragma mark - network
int http_request(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *url = readParamValue(L, 2);
    NSString *callbackFuncName = readParamValue(L, 3);
    NSLog(@"http_request:%@, %@, %@", scriptId, url, callbackFuncName);
    LuaScriptInteraction *si = getScriptInteraction(scriptId);
    NSString *requestId = [HTTPRequestImpl requestWithLuaState:si urlString:url
                                      callbackLuaFunctionName:callbackFuncName];
    lua_pushstring(L, [requestId UTF8String]);
    return 1;
}

int http_request_cancel(lua_State *L)
{
    NSString *requestId = readParamValue(L, 1);
    NSLog(@"http_request_cancel:%@", requestId);
    [HTTPRequestImpl cancelRequestWithRequestId:requestId];
    
    return 0;
}

#pragma mark - UI
int ui_create_button(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *title = readParamValue(L, 2);
    NSString *frame = readParamValue(L, 3);
    NSString *callback = readParamValue(L, 4);
    NSLog(@"ui_create_button:%@", title);
    id<ScriptInteraction> si = getScriptInteraction(scriptId);
    NSString *buttonId = [ButtonImpl createWithScriptId:scriptId si:si title:title frame:readRect(frame) eventFuncName:callback];
    lua_pushstring(L, [buttonId UTF8String]);
    return 1;
}

int ui_add_subview_to_view_controller(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *viewId = readParamValue(L, 2);
    NSString *viewControllerId = readParamValue(L, 3);
    [UIRelatedImpl addSubViewWithViewId:viewId
                       viewControllerId:viewControllerId
                               scriptId:scriptId];
    return 0;
}

int ui_set_view_frame(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *viewId = readParamValue(L, 2);
    NSString *frame = readParamValue(L, 3);
    
    [UIRelatedImpl setViewFrameWithViewId:viewId
                                    frame:frame
                                 scriptId:scriptId];
    
    return 0;
}

int ui_get_view_frame(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *viewId = readParamValue(L, 2);
    CGRect frame = [UIRelatedImpl frameOfViewWithViewId:viewId scriptId:scriptId];
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
    [UIRelatedImpl alertWithTitle:title message:msg
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
    
    NSString *vcId = [UIRelatedImpl createViewControllerWithTitle:title
                                                scriptInteraction:getScriptInteraction(scriptId)
                                                  viewDidLoadFunc:viewDidLoadFunc
                                               viewWillAppearFunc:viewWillAppearFunc scriptId:scriptId];
    lua_pushstring(L, [vcId UTF8String]);
    return 1;
}

int ui_set_root_view_controller(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *viewControllerId = readParamValue(L, 2);
    [UIRelatedImpl setRootViewControllerWithId:viewControllerId scriptId:scriptId];
    return 0;
}

int ui_createTextField(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    NSString *frame = readParamValue(L, 2);
    NSString *objId = [TextFieldImpl createTextFieldWithScriptId:scriptId frame:readRect(frame)];
    lua_pushstring(L, [objId UTF8String]);
    return 1;
}

#pragma mark - script
int script_run_script_id(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    BOOL success = [CallScriptImpl callScriptWithScriptId:scriptId];
    lua_pushstring(L, success ? "1" : "0");
    return 1;
}

#pragma mark - runtime
int runtime_recycle(lua_State *L)
{
    NSString *scriptId = readParamValue(L, 1);
    [RuntimeImpl recycleObjectWithScriptId:scriptId];
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
    pushFunctionToLua(L, "script_run_script_id", script_run_script_id);
    pushFunctionToLua(L, "runtime_recycle", runtime_recycle);
    pushFunctionToLua(L, "ui_createTextField", ui_createTextField);
}






