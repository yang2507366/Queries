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
#import "LabelImpl.h"

#pragma mark - common
NSString *luaParam(lua_State *L, int location)
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

CGRect luaRect(NSString *frame)
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

void pushString(lua_State *L, NSString *returnValue)
{
    returnValue = [CodeUtils encodeAllChinese:returnValue];
    lua_pushstring(L, [returnValue UTF8String]);
}

id<ScriptInteraction>scriptInteractionForScriptId(NSString *scriptId)
{
    id<ScriptInteraction> si = [LuaApplication programWithScriptId:scriptId];
    
    return si;
}

#pragma mark - network
int http_request(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *url = luaParam(L, 2);
    NSString *callbackFuncName = luaParam(L, 3);
    NSLog(@"http_request:%@, %@, %@", scriptId, url, callbackFuncName);
    LuaScriptInteraction *si = scriptInteractionForScriptId(scriptId);
    NSString *requestId = [HTTPRequestImpl requestWithLuaState:si urlString:url
                                       callbackLuaFunctionName:callbackFuncName];
    pushString(L, requestId);
    return 1;
}

int http_request_cancel(lua_State *L)
{
    NSString *requestId = luaParam(L, 1);
    NSLog(@"http_request_cancel:%@", requestId);
    [HTTPRequestImpl cancelRequestWithRequestId:requestId];
    
    return 0;
}

#pragma mark - UI
int ui_create_button(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *title = luaParam(L, 2);
    NSString *frame = luaParam(L, 3);
    NSString *callback = luaParam(L, 4);
    NSLog(@"ui_create_button:%@", title);
    id<ScriptInteraction> si = scriptInteractionForScriptId(scriptId);
    NSString *buttonId = [ButtonImpl createWithScriptId:scriptId si:si title:title frame:luaRect(frame) eventFuncName:callback];
    pushString(L, buttonId);
    return 1;
}

int ui_add_subview_to_view_controller(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *viewId = luaParam(L, 2);
    NSString *viewControllerId = luaParam(L, 3);
    [UIRelatedImpl addSubViewWithViewId:viewId
                       viewControllerId:viewControllerId
                               scriptId:scriptId];
    return 0;
}

int ui_set_view_frame(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *viewId = luaParam(L, 2);
    NSString *frame = luaParam(L, 3);
    
    [UIRelatedImpl setViewFrameWithViewId:viewId
                                    frame:frame
                                 scriptId:scriptId];
    
    return 0;
}

int ui_get_view_frame(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *viewId = luaParam(L, 2);
    CGRect frame = [UIRelatedImpl frameOfViewWithViewId:viewId scriptId:scriptId];
    lua_pushnumber(L, frame.origin.x);
    lua_pushnumber(L, frame.origin.y);
    lua_pushnumber(L, frame.size.width);
    lua_pushnumber(L, frame.size.height);
    return 4;
}

int ui_alert(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *title = luaParam(L, 2);
    NSString *msg = luaParam(L, 3);
    NSString *funcName = luaParam(L, 4);
    [UIRelatedImpl alertWithTitle:title message:msg
                        scriptInteraction:scriptInteractionForScriptId(scriptId)
                         callbackFuncName:funcName];
    return 0;
}

int ui_create_view_controller(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *title = luaParam(L, 2);
    NSString *viewDidLoadFunc = luaParam(L, 3);
    NSString *viewWillAppearFunc = luaParam(L, 4);
    
    NSString *vcId = [UIRelatedImpl createViewControllerWithTitle:title
                                                scriptInteraction:scriptInteractionForScriptId(scriptId)
                                                  viewDidLoadFunc:viewDidLoadFunc
                                               viewWillAppearFunc:viewWillAppearFunc scriptId:scriptId];
    pushString(L, vcId);
    return 1;
}

int ui_set_root_view_controller(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *viewControllerId = luaParam(L, 2);
    [UIRelatedImpl setRootViewControllerWithId:viewControllerId scriptId:scriptId];
    return 0;
}

int ui_createTextField(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *frame = luaParam(L, 2);
    NSString *objId = [TextFieldImpl createTextFieldWithScriptId:scriptId frame:luaRect(frame)];
    lua_pushstring(L, [objId UTF8String]);
    return 1;
}

int ui_createLabel(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *text = luaParam(L, 2);
    CGRect frame = luaRect(luaParam(L, 3));
    pushString(L, [LabelImpl createLabelWithScriptId:scriptId text:text frame:frame]);
    return 1;
}

#pragma mark - script
int script_run_script_id(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    BOOL success = [CallScriptImpl callScriptWithScriptId:scriptId];
    pushString(L, success ? @"1" : @"0");
    return 1;
}

#pragma mark - runtime
int runtime_recycle(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    [RuntimeImpl recycleObjectWithScriptId:scriptId];
    return 0;
}

int runtime_invokeObjectMethod(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *objectId = luaParam(L, 2);
    NSString *methodName = luaParam(L, 3);
    [RuntimeImpl invokeObjectMethodWithScriptId:scriptId objectId:objectId methodName:methodName];
    return 0;
}

int runtime_invokeOjectMethod_setValue(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *objectId = luaParam(L, 2);
    NSString *methodName = luaParam(L, 3);
    NSString *value = luaParam(L, 4);
    [RuntimeImpl invokeObjectMethodSetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:value];
    return 0;
}

int runtime_invokeObjectMethod_getValue(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *objectId = luaParam(L, 2);
    NSString *methodName = luaParam(L, 3);
    NSString *returnValue = [RuntimeImpl invokeObjectMethodGetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:nil];
    pushString(L, returnValue);
    return 1;
}

int runtime_invokeObjectMethod_setValueAndGetValue(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *objectId = luaParam(L, 2);
    NSString *methodName = luaParam(L, 3);
    NSString *value = luaParam(L, 4);
    NSString *returnValue = [RuntimeImpl invokeObjectMethodGetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:value];
    pushString(L, returnValue);
    return 1;
}

int runtime_invokeObjectProperty_set(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *objectId = luaParam(L, 2);
    NSString *propertyName = luaParam(L, 3);
    NSString *value = luaParam(L, 4);
    [RuntimeImpl invokeObjectPropertySetWithScriptId:scriptId objectId:objectId propertyName:propertyName value:value];
    return 0;
}

int runtime_invokeObjectProperty_get(lua_State *L)
{
    NSString *scriptId = luaParam(L, 1);
    NSString *objectId = luaParam(L, 2);
    NSString *propertyName = luaParam(L, 3);
    NSString *returnValue = [RuntimeImpl invokeObjectPropertyGetWithScriptId:scriptId objectId:objectId propertyName:propertyName];
    pushString(L, returnValue);
    return 1;
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
    pushFunctionToLua(L, "ui_createTextField", ui_createTextField);
    pushFunctionToLua(L, "ui_createLabel", ui_createLabel);
    
    pushFunctionToLua(L, "script_run_script_id", script_run_script_id);
    
    pushFunctionToLua(L, "runtime_recycle", runtime_recycle);
    pushFunctionToLua(L, "runtime_invokeObjectMethod", runtime_invokeObjectMethod);
    pushFunctionToLua(L, "runtime_invokeOjectMethod_setValue", runtime_invokeOjectMethod_setValue);
    pushFunctionToLua(L, "runtime_invokeObjectMethod_getValue", runtime_invokeObjectMethod_getValue);
    pushFunctionToLua(L, "runtime_invokeObjectMethod_setValueAndGetValue", runtime_invokeObjectMethod_setValueAndGetValue);
    pushFunctionToLua(L, "runtime_invokeObjectProperty_set", runtime_invokeObjectProperty_set);
    pushFunctionToLua(L, "runtime_invokeObjectProperty_get", runtime_invokeObjectProperty_get);
}






