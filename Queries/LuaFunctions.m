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
    
    LuaScriptInteraction *si = scriptInteractionForScriptId(scriptId);
    NSString *requestId = [HTTPRequestImpl requestWithLuaState:si urlString:url
                                       callbackLuaFunctionName:callbackFuncName];
    pushString(L, requestId);
    return 1;
}

int http_cancel(lua_State *L)
{
    NSString *requestId = luaStringParam(L, 1);
    
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

#pragma mark - obj
int obj_invokeInstanceMethod(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    
    [RuntimeImpl invokeObjectMethodWithScriptId:scriptId objectId:objectId methodName:methodName];
    return 0;
}

int obj_invokeInstanceMethodSetValue(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    NSString *value = luaStringParam(L, 4);
    
    [RuntimeImpl invokeObjectMethodSetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:value];
    return 0;
}

int obj_invokeInstanceMethodGetValue(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    
    NSString *returnValue = [RuntimeImpl invokeObjectMethodGetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:nil];
    pushString(L, returnValue);
    return 1;
}

int obj_invokeInstanceMethodSetValueAndGetValue(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    NSString *value = luaStringParam(L, 4);
    
    NSString *returnValue = [RuntimeImpl invokeObjectMethodGetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:value];
    pushString(L, returnValue);
    return 1;
}

int obj_invokePropertySet(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *propertyName = luaStringParam(L, 3);
    NSString *value = luaStringParam(L, 4);
    
    [RuntimeImpl invokeObjectPropertySetWithScriptId:scriptId objectId:objectId propertyName:propertyName value:value];
    return 0;
}

int obj_invokePropertyGet(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *propertyName = luaStringParam(L, 3);
    
    NSString *returnValue = [RuntimeImpl invokeObjectPropertyGetWithScriptId:scriptId objectId:objectId propertyName:propertyName];
    pushString(L, returnValue);
    return 1;
}

int obj_propertyOfObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *propertyName = luaStringParam(L, 3);
    
    NSString *propertyId = [RuntimeImpl propertyIdOfObjectWithScriptId:scriptId objectId:objectId propertyName:propertyName];
    pushString(L, propertyId);
    return 1;
}

#pragma mark - system
int nslog(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *log = luaStringParam(L, 2);
    
    NSLog(@"*[%@] %@", scriptId, log);
    return 0;
}

void pushFunctionToLua(lua_State *L, char *functionName, int (*func)(lua_State *L))
{
    lua_pushstring(L, functionName);
    lua_pushcfunction(L, func);
    lua_settable(L, LUA_GLOBALSINDEX);
}

void initFuntions(lua_State *L)
{
#pragma mark -
#pragma mark - -NSLog
#pragma mark - ios::NSLog
    pushFunctionToLua(L, "NSLog", nslog);
#pragma mark -
#pragma mark - -http
#pragma mark - ios::http::request
    pushFunctionToLua(L, "http_request", http_request);
#pragma mark - ios::http::cancel
    pushFunctionToLua(L, "http_cancel", http_cancel);
#pragma mark -
#pragma mark - -ui
#pragma mark - ios::ui::createButton
    pushFunctionToLua(L, "ui_createButton", ui_createButton);
#pragma mark - ios::ui::addSubviewToViewController
    pushFunctionToLua(L, "ui_addSubviewToViewController", ui_addSubviewToViewController);
#pragma mark - ios::ui::setViewFrame
    pushFunctionToLua(L, "ui_setViewFrame", ui_setViewFrame);
#pragma mark - ios::ui::getViewFrame
    pushFunctionToLua(L, "ui_getViewFrame", ui_getViewFrame);
#pragma mark - ios::ui::alert
    pushFunctionToLua(L, "ui_alert", ui_alert);
#pragma mark - ios::ui::createViewController
    pushFunctionToLua(L, "ui_createViewController", ui_createViewController);
#pragma mark - ios::ui::setRootViewController
    pushFunctionToLua(L, "ui_setRootViewController", ui_setRootViewController);
#pragma mark - ios::ui::createNavigationController
    pushFunctionToLua(L, "ui_createNavigationController", ui_createNavigationController);
#pragma mark - ios::ui::createNavigationController
    pushFunctionToLua(L, "ui_createNavigationController", ui_createTextField);
#pragma mark - ios::ui::createLabel
    pushFunctionToLua(L, "ui_createLabel", ui_createLabel);
#pragma mark - ios::ui::createWebView
    pushFunctionToLua(L, "ui_createWebView", ui_createWebView);
#pragma mark - ios::ui::webViewLoadURL
    pushFunctionToLua(L, "ui_webViewLoadURL", ui_webViewLoadURL);
#pragma mark -
#pragma mark - -ustring
#pragma mark - ios::ustring::find
    pushFunctionToLua(L, "ustring_find", ustring_find);
#pragma mark - ios::ustring::length
    pushFunctionToLua(L, "ustring_length", ustring_length);
#pragma mark - ios::ustring::substring
    pushFunctionToLua(L, "ustring_substring", ustring_substring);
#pragma mark -
#pragma mark - -script
#pragma mark - ios::script::runScriptWithId
    pushFunctionToLua(L, "script_runScriptWithId", script_runScriptWithId);
#pragma mark -
#pragma mark - -runtime
#pragma mark - ios::runtime::recycleCurrentScript
    pushFunctionToLua(L, "runtime_recycleCurrentScript", runtime_recycleCurrentScript);
#pragma mark -
#pragma mark - -obj
#pragma mark - ios::obj::invokeInstanceMethod
    /**
     调用无参数和返回值的实例方法，
     调用实例：ios::obj::invokeInstanceMethod(objId, methodName);
     */
    pushFunctionToLua(L, "obj_invokeInstanceMethod", obj_invokeInstanceMethod);
#pragma mark - ios::obj::invokeInstanceMethodSetValue
    /**
     调用一个字符串参数，无返回值的实例方法(该方法的类型可以是除结构体之外的任意类型，系统会自动将lua传入的字符串转换成目标类型)，
     调用实例：ios::obj::invokeInstanceMethodSetValue(objId, methodName, value);
     */
    pushFunctionToLua(L, "obj_invokeInstanceMethodSetValue", obj_invokeInstanceMethodSetValue);
#pragma mark - ios::obj::obj_invokeInstanceMethodGetValue
    /**
     调用无参数，一个字符串返回值的实例方法（该方法的返回值是除结构体之外的任意类型，系统会自动将目标类型转换成一个字符串类型），
     调用实例：value = ios::obj::invokeInstanceMethodGetValue(objId, methodName)
     */
    pushFunctionToLua(L, "obj_invokeInstanceMethodGetValue", obj_invokeInstanceMethodGetValue);
#pragma mark - ios::obj::invokeInstanceMethodSetValueAndGetValue
    /**
     调用有一个字符串参数，一个字符串返回值的实例方法（方法返回值和参数描述参考上述两个函数），
     调用实例：value = ios::obj::invokeInstanceMethodSetValueAndGetValue(objId, methodName, value);
     */
    pushFunctionToLua(L, "obj_invokeInstanceMethodSetValueAndGetValue", obj_invokeInstanceMethodSetValueAndGetValue);    
#pragma mark - ios::obj::invokePropertySet
    /**
     调用对象的property set方法，参数为一个字符串，系统会自动转化成目标类型
     调用实例：ios::obj::invokePropertySet(objId, propertyName, value);
     */
    pushFunctionToLua(L, "obj_invokePropertySet", obj_invokePropertySet);
#pragma mark - ios::obj::invokePropertyGet
    /**
     调用对象的property get方法，不管返回值为什么类型，系统都会自动转换并且返回一个字符串
     调用实例：value = ios::obj::invokePropertyGet(objId, propertyName);
     */
    pushFunctionToLua(L, "obj_invokePropertyGet", obj_invokePropertyGet);
#pragma mark - ios::obj::propertyOfObject
    /**
     获取对象的property对应的对象id，该property的数据类型必须是id类型
     调用实例：propertyId = ios::obj::propertyOfObject(objId, propertyName);
     */
    pushFunctionToLua(L, "obj_propertyOfObject", obj_propertyOfObject);
}






