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
#import "LuaAppManager.h"
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
#import "TableViewImpl.h"
#import "UIBarButtonItemImpl.h"
#import "LuaRuntimeUtils.h"
#import "LuaConstants.h"
#import "LuaObjectManager.h"
#import "RuntimeUtils.h"
#import "DialogTools.h"
#import "AnimationImpl.h"
#import "AppLoaderImpl.h"
#import "AppRunImpl.h"
#import "TextViewImpl.h"
#import "LuaCommonUtils.h"
#import "PickerViewImpl.h"

#pragma mark - common
NSString *luaStringParam(lua_State *L, int location)
{
    const char *paramValue = lua_tostring(L, location);
    NSString *paramString = @"";
    if(paramValue){
        paramString = [NSString stringWithFormat:@"%s", paramValue];
    }
    paramString = [CodeUtils decodeUnicode:paramString];
    if(paramString.length == 0){
        paramString = @"";
    }
    return paramString;
}

CGRect luaRect(NSString *frame)
{
    NSArray *attrs = [frame componentsSeparatedByString:@","];
    CGRect tmpRect = CGRectZero;
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
    returnValue = [CodeUtils encodeUnicode:returnValue];
    lua_pushstring(L, [returnValue UTF8String]);
}

id<ScriptInteraction>scriptInteractionForAppId(NSString *appId)
{
    id<ScriptInteraction> si = [LuaAppManager scriptInteractionWithAppId:appId];
    
    return si;
}

#pragma mark - app
int app_runApp(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *targetAppId = luaStringParam(L, 2);
    NSString *relatedViewControllerId = luaStringParam(L, 3);
    [AppRunImpl runWithAppId:appId targetAppId:targetAppId relatedViewControllerId:relatedViewControllerId];
    return 0;
}

int app_destoryApp(lua_State *L)
{
//    NSString *appId = luaStringParam(L, 1);
    NSString *targetAppId = luaStringParam(L, 2);
    [LuaAppManager destoryAppWithAppId:targetAppId];
    return 0;
}

int app_loadApp(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *loaderId = luaStringParam(L, 2);
    NSString *urlString = luaStringParam(L, 3);
    NSString *processFunc = luaStringParam(L, 4);
    NSString *completeFunc = luaStringParam(L, 5);
    [AppLoaderImpl loadWithAppId:appId
                              si:scriptInteractionForAppId(appId)
                        loaderId:loaderId
                       urlString:urlString
                     processFunc:processFunc
                    completeFunc:completeFunc];
    return 0;
}

int app_getAppBundle(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *targetAppId = luaStringParam(L, 2);
    if(targetAppId.length != 0){
        appId = targetAppId;
    }
    NSString *objId = @"";
    LuaApp *app = [LuaAppManager appForId:appId];
    if(app){
        id sb = [app scriptBundle];
        objId = [LuaObjectManager addObject:sb group:appId];
    }
    pushString(L, objId);
    return 1;
}

#pragma mark - math
int math_operator_or(lua_State *L)
{
    int numberOfParams = lua_gettop(L);
    
    int result = lua_tonumber(L, 1);
    for(int i = 2; i <= numberOfParams; ++i){
        result = result | lua_tointeger(L, i);
    }
    lua_pushinteger(L, result);
    
    return 1;
}

int math_random(lua_State *L)
{
    lua_pushnumber(L, [NSDate timeIntervalSinceReferenceDate]);
    return 1;
}

#pragma mark - network
int http_request(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *url = luaStringParam(L, 2);
    NSString *callbackFuncName = luaStringParam(L, 3);
    NSString *encoding = luaStringParam(L, 4);
    
    LuaScriptInteraction *si = scriptInteractionForAppId(scriptId);
    NSString *requestId = [HTTPRequestImpl requestWithLuaState:si urlString:url
                                       callbackLuaFunctionName:callbackFuncName
                                                      encoding:encoding];
    pushString(L, requestId);
    return 1;
}

int http_post(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *url = luaStringParam(L, 2);
    NSString *paramId = luaStringParam(L, 3);
    NSString *callbackFunc = luaStringParam(L, 4);
    NSString *encoding = luaStringParam(L, 5);
    NSString *reqId = [HTTPRequestImpl postWithSi:scriptInteractionForAppId(appId)
                                        urlString:url
                                       parameters:[LuaObjectManager objectWithId:paramId group:appId]
                                     callbackFunc:callbackFunc
                                         encoding:encoding];
    pushString(L, reqId);
    return 1;
}

int http_cancel(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *requestId = luaStringParam(L, 2);
    
    [HTTPRequestImpl cancelRequestWithRequestId:requestId];
    
    return 0;
}

#pragma mark - UI
int ui_createButton(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSUInteger type = lua_tointeger(L, 2);
    NSString *tappedFunc = luaStringParam(L, 3);
    
    id<ScriptInteraction> si = scriptInteractionForAppId(scriptId);
    NSString *buttonId = [ButtonImpl createWithScriptId:scriptId si:si type:type tappedFunc:tappedFunc];
    pushString(L, buttonId);
    return 1;
}

int ui_alert(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *title = luaStringParam(L, 2);
    NSString *msg = luaStringParam(L, 3);
    NSString *funcName = luaStringParam(L, 4);
    
    [UIRelatedImpl alertWithTitle:title message:msg
                        scriptInteraction:scriptInteractionForAppId(scriptId)
                         callbackFuncName:funcName];
    return 0;
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

int ui_attachTextFieldDelegate(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *obejctId = luaStringParam(L, 2);
    NSString *shouldBeginEditFunc = luaStringParam(L, 3);
    NSString *didBeginEditFunc = luaStringParam(L, 4);
    NSString *shouldEndEditFunc = luaStringParam(L, 5);
    NSString *didEndEditFunc = luaStringParam(L, 6);
    NSString *shouldChangeCharFunc = luaStringParam(L, 7);
    [TextFieldImpl attachEventWithAppId:appId
                                     si:scriptInteractionForAppId(appId)
                               objectId:obejctId
                        shouldBeginFunc:shouldBeginEditFunc
                           didBeginFunc:didBeginEditFunc
                          shouldEndFunc:shouldEndEditFunc
                             didEndFunc:didEndEditFunc
                   shouldChangeCharFunc:shouldChangeCharFunc];
    return 0;
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
                                                          si:scriptInteractionForAppId(scriptId)
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

int ui_createBarButtonItem(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *title = luaStringParam(L, 2);
    NSString *tapFunc = luaStringParam(L, 3);
    
    pushString(L, [UIBarButtonItemImpl createBarButtonItemWithScriptId:scriptId
                                                                    si:scriptInteractionForAppId(scriptId)
                                                                 title:title
                                                          callbackFunc:tapFunc]);
    return 1;
}

int ui_dialog(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *title = luaStringParam(L, 2);
    NSString *message = luaStringParam(L, 3);
    NSString *cancelButtonTitle = luaStringParam(L, 4);
    NSString *callbackFunc = luaStringParam(L, 5);
    
    NSInteger numberOfArgs = lua_gettop(L);
    NSMutableArray *titleList = [NSMutableArray array];
    for(NSInteger i = 6; i <= numberOfArgs; ++i){
        [titleList addObject:luaStringParam(L, i)];
    }
    
    id<ScriptInteraction> si = scriptInteractionForAppId(scriptId);
    [DialogTools showWithTitle:title message:message completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        [si callFunction:callbackFunc parameters:[NSString stringWithFormat:@"%d", buttonIndex], buttonTitle, nil];
    } cancelButtonTitle:cancelButtonTitle otherButtonTitleList:titleList];
    
    return 0;
}

int ui_animate(lua_State *L)
{
    NSString *appid = luaStringParam(L, 1);
    NSString *animId = luaStringParam(L, 2);
    NSTimeInterval duration = lua_tonumber(L, 3);
    NSTimeInterval delay = lua_tonumber(L, 4);
    NSInteger options = lua_tonumber(L, 5);
    NSString *animationFunc = luaStringParam(L, 6);
    NSString *completeFunc = luaStringParam(L, 7);
    [AnimationImpl animateWithAppId:appid
                                 si:scriptInteractionForAppId(appid)
                             animId:animId
                  animationDuration:duration
                                delay:delay
                            options:options
                      animationFunc:animationFunc
                       completeFunc:completeFunc];
    return 0;
}

int ui_getRelatedViewController(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *vcId = [UIRelatedImpl relatedViewControllerForAppId:appId];
    pushString(L, vcId);
    return 1;
}

int ui_createTextView(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *textViewShouldBeginEditingFunc = luaStringParam(L, 2);
    NSString *textViewShouldEndEditingFunc = luaStringParam(L, 3);
    NSString *textViewDidBeginEditingFunc = luaStringParam(L, 4);
    NSString *textViewDidEndEditingFunc = luaStringParam(L, 5);
    NSString *shouldChangeTextInRangeFunc = luaStringParam(L, 6);
    NSString *textViewDidChangeFunc = luaStringParam(L, 7);
    NSString *textViewDidChangeSelectionFunc = luaStringParam(L, 8);
    
    NSString *tvId = [TextViewImpl createTextViewWithAppId:appId
                                                        si:scriptInteractionForAppId(appId)
                                       didBeginEditingFunc:textViewDidBeginEditingFunc
                                            didEndEditFunc:textViewDidEndEditingFunc
                                             didChangeFunc:textViewDidChangeFunc
                                    didChangeSelectionFunc:textViewDidChangeSelectionFunc
                                    shouldBeginEditingFunc:textViewShouldBeginEditingFunc
                                      shouldEndEditingFunc:textViewShouldEndEditingFunc
                               shouldChangeTextInRangeFunc:shouldChangeTextInRangeFunc];
    pushString(L, tvId);
    
    return 1;
}

#pragma mark - string
int ustring_substring(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *string = luaStringParam(L, 2);
    NSInteger beginIndex = [luaStringParam(L, 3) intValue];
    NSInteger endIndex = [luaStringParam(L, 4) intValue];
    
    NSString *resultString = @"";
    if(string.length != 0 && beginIndex < string.length && endIndex < string.length && beginIndex < endIndex){
        resultString = [string substringWithRange:NSMakeRange(beginIndex, endIndex - beginIndex)];
    }
    pushString(L, resultString);
    return 1;
}

int ustring_length(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *string = luaStringParam(L, 2);
    lua_pushnumber(L, [string length]);
    
    return 1;
}

int ustring_find(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *string = luaStringParam(L, 2);
    NSString *targetStr = luaStringParam(L, 3);
    NSInteger fromIndex = lua_tointeger(L, 4);
    NSInteger reverse = lua_toboolean(L, 5);
    
    NSInteger location = -1;
    if(string.length > 0 && targetStr.length > 0 && fromIndex > -1 && fromIndex < string.length){
        NSRange tmpRange = [string rangeOfString:targetStr
                                         options:reverse ? NSBackwardsSearch : NSCaseInsensitiveSearch
                                           range:reverse ? NSMakeRange(0, fromIndex) : NSMakeRange(fromIndex, string.length - fromIndex)];
        location = tmpRange.location == NSNotFound ? -1 : tmpRange.location;
    }
    lua_pushnumber(L, location);
    return 1;
}

int ustring_encodeURL(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *str = luaStringParam(L, 2);
    if(str.length != 0){
        str = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)str, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    }
    pushString(L, str);
    [str release];
    
    return 1;
}

int ustring_replace(lua_State *L)
{
    NSString *str = luaStringParam(L, 2);
    NSString *occurrences = luaStringParam(L, 3);
    NSString *replacement = luaStringParam(L, 4);
    str = [str stringByReplacingOccurrencesOfString:occurrences withString:replacement];
    pushString(L, str);
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

int runtime_recycleObjectById(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    
    [RuntimeImpl recycleObjectWithScriptId:scriptId objectId:objectId];
    return 0;
}

int runtime_invokeMethod(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    
    int numOfArgs = lua_gettop(L);
    NSMutableArray *params = [NSMutableArray array];
    for(int i = 4; i <= numOfArgs; ++i){
        [params addObject:luaStringParam(L, i)];
    }
    
    NSString *returnValue = [LuaRuntimeUtils invokeWithGroup:scriptId objectId:objectId methodName:methodName parameters:params];
    pushString(L, returnValue);
    return 1;
}

int runtime_createObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *className = luaStringParam(L, 2);
    NSString *initMethodName = luaStringParam(L, 3);
    
    int numOfArgs = lua_gettop(L);
    NSMutableArray *params = [NSMutableArray array];
    for(int i = 4; i <= numOfArgs; ++i){
        [params addObject:luaStringParam(L, i)];
    }
    
    NSString *returnValue = [LuaRuntimeUtils createObjectWithGroup:scriptId
                                                             className:className
                                                        initMethodName:initMethodName
                                                            parameters:params];
    pushString(L, returnValue);
    return 1;
}

int runtime_invokeClassMethod(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *className = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    
    int numOfArgs = lua_gettop(L);
    NSMutableArray *params = [NSMutableArray array];
    for(int i = 4; i <= numOfArgs; ++i){
        [params addObject:luaStringParam(L, i)];
    }
    
    NSString *returnValue = [LuaRuntimeUtils invokeClassMethodWithGroup:scriptId className:className methodName:methodName parameters:params];
    pushString(L, returnValue);
    return 1;
}

int runtime_retainObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    
    [LuaObjectManager retainObjectWithId:objectId group:scriptId];
    return 0;
}

int runtime_releaseObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    
    BOOL recycled = [LuaObjectManager releaseObjectWithId:objectId group:scriptId];
    lua_pushboolean(L, recycled ? 1 : 0);
    return 1;
}

int runtime_objectRetainCount(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *objId = luaStringParam(L, 2);
    lua_pushnumber(L, [LuaObjectManager objectRetainCountForId:objId group:appId]);
    return 1;
}

#pragma mark - system
int nslog(lua_State *L)
{
    NSString *log = luaStringParam(L, 1);
    
    NSLog(@"%@", log);
    return 0;
}

int utils_printObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *log = luaStringParam(L, 2);
    
    id targetObject = log;
    if([log hasPrefix:lua_obj_prefix]){
        id tmpObject = [LuaObjectManager objectWithId:log group:scriptId];
        if(tmpObject){
            targetObject = tmpObject;
        }
    }
    
    NSLog(@"%@", targetObject);
    
    return 0;
}

int utils_printObjectDescription(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *log = luaStringParam(L, 2);
    
    id targetObject = log;
    if([log hasPrefix:lua_obj_prefix]){
        id tmpObject = [LuaObjectManager objectWithId:log group:scriptId];
        if(tmpObject){
            targetObject = tmpObject;
        }
    }
    
    NSLog(@"%@", [RuntimeUtils descriptionOfObject:targetObject]);
    return 0;
}

int utils_isObjCObject(lua_State *L)
{
//    NSString *appId = luaStringParam(L, 1);
    NSString *objId = luaStringParam(L, 2);
    lua_pushboolean(L, [LuaCommonUtils isObjCObject:objId] ? 1 : 0);
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
#pragma mark - app
#pragma mark - app::loadApp
    pushFunctionToLua(L, "app_loadApp", app_loadApp);
#pragma mark - app::runApp
    pushFunctionToLua(L, "app_runApp", app_runApp);
#pragma mark - app::getAppBundle
    pushFunctionToLua(L, "app_getAppBundle", app_getAppBundle);
#pragma mark - http::request
    pushFunctionToLua(L, "http_request", http_request);
#pragma mark - http::post
    pushFunctionToLua(L, "http_post", http_post);
#pragma mark - http::cancel
    pushFunctionToLua(L, "http_cancel", http_cancel);
#pragma mark - math::operator_or
    pushFunctionToLua(L, "math_operator_or", math_operator_or);
#pragma mark - math::random
    pushFunctionToLua(L, "math_random", math_random);
#pragma mark - NSLog
    pushFunctionToLua(L, "NSLog", nslog);
#pragma mark - runtime::recycleCurrentScript
    pushFunctionToLua(L, "runtime_recycleCurrentScript", runtime_recycleCurrentScript);
#pragma mark - runtime::recycleObjectById
    pushFunctionToLua(L, "runtime_recycleObjectById", runtime_recycleObjectById);
#pragma mark - runtime::createObject
    pushFunctionToLua(L, "runtime_createObject", runtime_createObject);
#pragma mark - runtime::invokeClassMethod
    pushFunctionToLua(L, "runtime_invokeClassMethod", runtime_invokeClassMethod);
#pragma mark - runtime::retainObject
    pushFunctionToLua(L, "runtime_retainObject", runtime_retainObject);
#pragma mark - runtime_releaseObject
    pushFunctionToLua(L, "runtime_releaseObject", runtime_releaseObject);
#pragma mark - runtime::invokeMethod
    pushFunctionToLua(L, "runtime_invokeMethod", runtime_invokeMethod);
#pragma mark - runtime::objectRetainCount
    pushFunctionToLua(L, "runtime_objectRetainCount", runtime_objectRetainCount);
#pragma mark - script::runScriptWithId
    pushFunctionToLua(L, "script_runScriptWithId", script_runScriptWithId);
#pragma mark - ui::createButton
    pushFunctionToLua(L, "ui_createButton", ui_createButton);
#pragma mark - ui::alert
    pushFunctionToLua(L, "ui_alert", ui_alert);
#pragma mark - ui::setRootViewController
    pushFunctionToLua(L, "ui_setRootViewController", ui_setRootViewController);
#pragma mark - ui::createTextField
    pushFunctionToLua(L, "ui_createTextField", ui_createTextField);
#pragma mark - ui::attachTextFieldDelegate
    pushFunctionToLua(L, "ui_attachTextFieldDelegate", ui_attachTextFieldDelegate);
#pragma mark - ui::createLabel
    pushFunctionToLua(L, "ui_createLabel", ui_createLabel);
#pragma mark - ui::createWebView
    pushFunctionToLua(L, "ui_createWebView", ui_createWebView);
#pragma mark - ui::webViewLoadURL
    pushFunctionToLua(L, "ui_webViewLoadURL", ui_webViewLoadURL);
#pragma mark - ui::createBarButtonItem
    /**
     调用示例：ui::createBarButtonItem("title", "callbackFunc");
     */
    pushFunctionToLua(L, "ui_createBarButtonItem", ui_createBarButtonItem);
#pragma mark - ui::dialog
    pushFunctionToLua(L, "ui_dialog", ui_dialog);
#pragma mark - ui::animate
    pushFunctionToLua(L, "ui_animate", ui_animate);
#pragma mark - ui::getRelatedViewController
    pushFunctionToLua(L, "ui_getRelatedViewController", ui_getRelatedViewController);
#pragma mark - ui::createTextView
    pushFunctionToLua(L, "ui_createTextView", ui_createTextView);
#pragma mark - ustring::find
    pushFunctionToLua(L, "ustring_find", ustring_find);
#pragma mark - ustring::length
    pushFunctionToLua(L, "ustring_length", ustring_length);
#pragma mark - ustring::substring
    pushFunctionToLua(L, "ustring_substring", ustring_substring);
#pragma mark - ustring::encodeURL
    pushFunctionToLua(L, "ustring_encodeURL", ustring_encodeURL);
#pragma mark - ustring::replace
    pushFunctionToLua(L, "ustring_replace", ustring_replace);
#pragma mark - utils::printObject
    pushFunctionToLua(L, "utils_printObject", utils_printObject);
#pragma mark - utils::printObjectDescription
    pushFunctionToLua(L, "utils_printObjectDescription", utils_printObjectDescription);
#pragma mark - utils::isObjCObject
    pushFunctionToLua(L, "utils_isObjCObject", utils_isObjCObject);
}






