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
#import "ViewControllerImpl.h"
#import "NavigationControllerImpl.h"
#import "WebViewImpl.h"

#pragma mark - common
NSString *luaStringParam(lua_State *L, int location)
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
    NSString *scriptId = luaStringParam(L, 1);
    NSString *url = luaStringParam(L, 2);
    NSString *callbackFuncName = luaStringParam(L, 3);
    NSLog(@"http_request:%@, %@, %@", scriptId, url, callbackFuncName);
    LuaScriptInteraction *si = scriptInteractionForScriptId(scriptId);
    NSString *requestId = [HTTPRequestImpl requestWithLuaState:si urlString:url
                                       callbackLuaFunctionName:callbackFuncName];
    pushString(L, requestId);
    return 1;
}

int http_cancel(lua_State *L)
{
    NSString *requestId = luaStringParam(L, 1);
    NSLog(@"http_request_cancel:%@", requestId);
    [HTTPRequestImpl cancelRequestWithRequestId:requestId];
    
    return 0;
}

#pragma mark - UI
int ui_createButton(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *title = luaStringParam(L, 2);
    NSString *frame = luaStringParam(L, 3);
    NSString *callback = luaStringParam(L, 4);
    NSLog(@"ui_create_button:%@", title);
    id<ScriptInteraction> si = scriptInteractionForScriptId(scriptId);
    NSString *buttonId = [ButtonImpl createWithScriptId:scriptId si:si title:title frame:luaRect(frame) eventFuncName:callback];
    pushString(L, buttonId);
    return 1;
}

int ui_addSubviewToViewController(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *viewId = luaStringParam(L, 2);
    NSString *viewControllerId = luaStringParam(L, 3);
    [UIRelatedImpl addSubViewWithViewId:viewId
                       viewControllerId:viewControllerId
                               scriptId:scriptId];
    return 0;
}

int ui_setViewFrame(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *viewId = luaStringParam(L, 2);
    NSString *frame = luaStringParam(L, 3);
    
    [UIRelatedImpl setViewFrameWithViewId:viewId
                                    frame:frame
                                 scriptId:scriptId];
    
    return 0;
}

int ui_getViewFrame(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *viewId = luaStringParam(L, 2);
    CGRect frame = [UIRelatedImpl frameOfViewWithViewId:viewId scriptId:scriptId];
    lua_pushnumber(L, frame.origin.x);
    lua_pushnumber(L, frame.origin.y);
    lua_pushnumber(L, frame.size.width);
    lua_pushnumber(L, frame.size.height);
    return 4;
}

int ui_alert(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *title = luaStringParam(L, 2);
    NSString *msg = luaStringParam(L, 3);
    NSString *funcName = luaStringParam(L, 4);
    [UIRelatedImpl alertWithTitle:title message:msg
                        scriptInteraction:scriptInteractionForScriptId(scriptId)
                         callbackFuncName:funcName];
    return 0;
}

int ui_createViewController(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *title = luaStringParam(L, 2);
    NSString *viewDidLoadFunc = luaStringParam(L, 3);
    NSString *viewWillAppearFunc = luaStringParam(L, 4);
    
    NSString *vcId = [ViewControllerImpl createViewControllerWithScriptId:scriptId
                                                                       si:scriptInteractionForScriptId(scriptId)
                                                                    title:title
                                                          viewDidLoadFunc:viewDidLoadFunc
                                                       viewWillAppearFunc:viewWillAppearFunc];
    pushString(L, vcId);
    return 1;
}

int ui_createNavigationController(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *rootViewControllerId = luaStringParam(L, 2);
    
    NSString *vcId = [NavigationControllerImpl createNavigationControllerWithScriptId:scriptId
                                                                                   si:scriptInteractionForScriptId(scriptId)
                                                                 rootViewControllerId:rootViewControllerId];
    pushString(L, vcId);
    return 1;
}

int ui_setRootViewController(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *viewControllerId = luaStringParam(L, 2);
    [UIRelatedImpl setRootViewControllerWithId:viewControllerId scriptId:scriptId];
    return 0;
}

int ui_createTextField(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *frame = luaStringParam(L, 2);
    NSString *objId = [TextFieldImpl createTextFieldWithScriptId:scriptId frame:luaRect(frame)];
    lua_pushstring(L, [objId UTF8String]);
    return 1;
}

int ui_createLabel(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *text = luaStringParam(L, 2);
    CGRect frame = luaRect(luaStringParam(L, 3));
    pushString(L, [LabelImpl createLabelWithScriptId:scriptId text:text frame:frame]);
    return 1;
}

int ui_createWebView(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    CGRect frame = luaRect(luaStringParam(L, 2));
    NSString *shouldStartFunc = luaStringParam(L, 3);
    NSString *didLoadFunc = luaStringParam(L, 4);
    NSString *didErrorFunc = luaStringParam(L, 5);
    NSString *objId = [WebViewImpl createWebViewWithScriptId:scriptId
                                                          si:scriptInteractionForScriptId(scriptId)
                                                       frame:frame
                                             shouldStartFunc:shouldStartFunc
                                                 didLoadFunc:didLoadFunc
                                                didErrorFunc:didErrorFunc];
    pushString(L, objId);
    return 1;
}

int ui_webViewLoadURL(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *webViewId = luaStringParam(L, 2);
    NSString *urlString = luaStringParam(L, 3);
    [WebViewImpl loadRequestWithScriptId:scriptId webViewId:webViewId urlString:urlString];
    return 0;
}

#pragma mark - string
int ustring_substring(lua_State *L)
{
    NSString *string = luaStringParam(L, 1);
    NSString *beginIndex = luaStringParam(L, 2);
    NSString *length = luaStringParam(L, 3);
    
    NSString *resultString = @"";
    if(string.length != 0 && beginIndex.length != 0 && length > 0){
        NSInteger begin = [beginIndex intValue];
        NSInteger legnth = [length intValue];
        if(begin > 0 && length > 0){
            resultString = [string substringWithRange:NSMakeRange(begin, legnth)];
        }
    }
    pushString(L, resultString);
    return 1;
}

int ustring_length(lua_State *L)
{
    NSString *string = luaStringParam(L, 1);
    lua_pushnumber(L, [string length]);
    return 1;
}

int ustring_find(lua_State *L)
{
    NSString *string = luaStringParam(L, 1);
    NSString *targetStr = luaStringParam(L, 2);
    NSInteger fromIndex = lua_tointeger(L, 3);
    NSInteger reverse = lua_toboolean(L, 4);
    
    NSInteger location = -1;
    if(string.length > 0 && targetStr.length > 0 && fromIndex > -1 && fromIndex < string.length){
        NSRange tmpRange = [string rangeOfString:targetStr
                                         options:reverse ? NSBackwardsSearch : NSCaseInsensitiveSearch
                                           range:NSMakeRange(fromIndex, string.length - fromIndex)];
        location = tmpRange.location == NSNotFound ? -1 : tmpRange.location;
    }
    lua_pushnumber(L, location);
    return 1;
}

#pragma mark - script
int script_runScriptWithId(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    BOOL success = [CallScriptImpl callScriptWithScriptId:scriptId];
    pushString(L, success ? @"1" : @"0");
    return 1;
}

#pragma mark - runtime
int runtime_recycleCurrentScript(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    [RuntimeImpl recycleObjectWithScriptId:scriptId];
    return 0;
}

int runtime_invokeObjectMethod(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    [RuntimeImpl invokeObjectMethodWithScriptId:scriptId objectId:objectId methodName:methodName];
    return 0;
}

int runtime_invokeOjectMethod_setValue(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    NSString *value = luaStringParam(L, 4);
    [RuntimeImpl invokeObjectMethodSetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:value];
    return 0;
}

int runtime_invokeObjectMethod_getValue(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    NSString *returnValue = [RuntimeImpl invokeObjectMethodGetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:nil];
    pushString(L, returnValue);
    return 1;
}

int runtime_invokeObjectMethod_setValueAndGetValue(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    NSString *value = luaStringParam(L, 4);
    NSString *returnValue = [RuntimeImpl invokeObjectMethodGetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:value];
    pushString(L, returnValue);
    return 1;
}

int runtime_invokeObjectProperty_set(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    NSString *propertyName = luaStringParam(L, 3);
    NSString *value = luaStringParam(L, 4);
    [RuntimeImpl invokeObjectPropertySetWithScriptId:scriptId objectId:objectId propertyName:propertyName value:value];
    return 0;
}

int runtime_invokeObjectProperty_get(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    NSString *propertyName = luaStringParam(L, 3);
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
    pushFunctionToLua(L, "http_cancel", http_cancel);
    
    pushFunctionToLua(L, "ui_createButton", ui_createButton);
    pushFunctionToLua(L, "ui_addSubviewToViewController", ui_addSubviewToViewController);
    pushFunctionToLua(L, "ui_setViewFrame", ui_setViewFrame);
    pushFunctionToLua(L, "ui_getViewFrame", ui_getViewFrame);
    pushFunctionToLua(L, "ui_alert", ui_alert);
    pushFunctionToLua(L, "ui_createViewController", ui_createViewController);
    pushFunctionToLua(L, "ui_setRootViewController", ui_setRootViewController);
    pushFunctionToLua(L, "ui_createNavigationController", ui_createNavigationController);
    pushFunctionToLua(L, "ui_createTextField", ui_createTextField);
    pushFunctionToLua(L, "ui_createLabel", ui_createLabel);
    pushFunctionToLua(L, "ui_createWebView", ui_createWebView);
    pushFunctionToLua(L, "ui_webViewLoadURL", ui_webViewLoadURL);
    
    pushFunctionToLua(L, "ustring_find", ustring_find);
    pushFunctionToLua(L, "ustring_length", ustring_length);
    pushFunctionToLua(L, "ustring_substring", ustring_substring);
    
    pushFunctionToLua(L, "script_runScriptWithId", script_runScriptWithId);
    
    pushFunctionToLua(L, "runtime_recycleCurrentScript", runtime_recycleCurrentScript);
    pushFunctionToLua(L, "runtime_invokeObjectMethod", runtime_invokeObjectMethod);
    pushFunctionToLua(L, "runtime_invokeOjectMethod_setValue", runtime_invokeOjectMethod_setValue);
    pushFunctionToLua(L, "runtime_invokeObjectMethod_getValue", runtime_invokeObjectMethod_getValue);
    pushFunctionToLua(L, "runtime_invokeObjectMethod_setValueAndGetValue", runtime_invokeObjectMethod_setValueAndGetValue);
    pushFunctionToLua(L, "runtime_invokeObjectProperty_set", runtime_invokeObjectProperty_set);
    pushFunctionToLua(L, "runtime_invokeObjectProperty_get", runtime_invokeObjectProperty_get);
}






