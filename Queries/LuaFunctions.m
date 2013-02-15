//
//  LuaFunctions.c
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#include "LuaFunctions.h"
#include <stdio.h>
#import "LIHTTPRequest.h"
#import "LuaAppManager.h"
#import "LuaScriptInteraction.h"
#import "LIUIRelated.h"
#import "CodeUtils.h"
#import "LuaRuntimeUtils.h"
#import "LuaConstants.h"
#import "LuaObjectManager.h"
#import "RuntimeUtils.h"
#import "DialogTools.h"
#import "LIAnimation.h"
#import "LIAppLoader.h"
#import "LIAppRunner.h"
#import "LuaCommonUtils.h"

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
    NSString *params = luaStringParam(L, 3);
    NSString *relatedViewControllerId = luaStringParam(L, 4);
    [LIAppRunner runWithAppId:appId targetAppId:targetAppId params:params relatedViewControllerId:relatedViewControllerId];
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
    [LIAppLoader loadWithAppId:appId
                              si:scriptInteractionForAppId(appId)
                        loaderId:loaderId
                       urlString:urlString
                     processFunc:processFunc
                    completeFunc:completeFunc];
    return 0;
}

int app_cancelLoadApp(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *loaderId = luaStringParam(L, 2);
    [LIAppLoader cancelLoadWithAppId:appId loaderId:loaderId];
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
int math_byte_operator_or(lua_State *L)
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
int http_get(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *url = luaStringParam(L, 2);
    NSString *callbackFuncName = luaStringParam(L, 3);
    NSString *encoding = luaStringParam(L, 4);
    
    LuaScriptInteraction *si = scriptInteractionForAppId(scriptId);
    NSString *requestId = [LIHTTPRequest requestWithLuaState:si urlString:url
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
    NSString *reqId = [LIHTTPRequest postWithSi:scriptInteractionForAppId(appId)
                                        urlString:url
                                       parameters:[LuaObjectManager objectWithId:paramId group:appId]
                                     callbackFunc:callbackFunc
                                         encoding:encoding];
    pushString(L, reqId);
    return 1;
}

int http_download(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *url = luaStringParam(L, 2);
    NSString *progressFuncName = luaStringParam(L, 3);
    NSString *completionFuncName = luaStringParam(L, 4);
    
    NSString *reqId = [LIHTTPRequest downloadWithSi:scriptInteractionForAppId(appId)
                                          URLString:url
                                   progressFuncName:progressFuncName
                                 completionFuncName:completionFuncName];
    pushString(L, reqId);
    return 1;
}

int http_cancel(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *requestId = luaStringParam(L, 2);
    
    [LIHTTPRequest cancelRequestWithRequestId:requestId];
    
    return 0;
}

#pragma mark - UI
int ui_alert(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *title = luaStringParam(L, 2);
    NSString *msg = luaStringParam(L, 3);
    NSString *funcName = luaStringParam(L, 4);
    
    [LIUIRelated alertWithTitle:title message:msg
                        scriptInteraction:scriptInteractionForAppId(scriptId)
                         callbackFuncName:funcName];
    return 0;
}

int ui_setRootViewController(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *viewControllerId = luaStringParam(L, 2);
    
    [LIUIRelated setRootViewControllerWithId:viewControllerId scriptId:scriptId];
    return 0;
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
        if(callbackFunc.length != 0){
            [si callFunction:callbackFunc parameters:[NSString stringWithFormat:@"%d", buttonIndex], buttonTitle, nil];
        }
    } cancelButtonTitle:cancelButtonTitle otherButtonTitleList:titleList];
    
    return 0;
}

int ui_dialog_c(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *title = luaStringParam(L, 2);
    NSString *message = luaStringParam(L, 3);
    NSString *cancelButtonTitle = luaStringParam(L, 4);
    NSString *callbackFunc = luaStringParam(L, 5);
    NSString *dialogId = luaStringParam(L, 6);
    
    NSInteger numberOfArgs = lua_gettop(L);
    NSMutableArray *titleList = [NSMutableArray array];
    for(NSInteger i = 7; i <= numberOfArgs; ++i){
        [titleList addObject:luaStringParam(L, i)];
    }
    id<ScriptInteraction> si = scriptInteractionForAppId(scriptId);
    [DialogTools showWithTitle:title message:message completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        if(callbackFunc.length != 0){
            [si callFunction:callbackFunc parameters:dialogId, [NSString stringWithFormat:@"%d", buttonIndex], buttonTitle, nil];
        }
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
    [LIAnimation animateWithAppId:appid
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
    NSString *vcId = [LIUIRelated relatedViewControllerForAppId:appId];
    pushString(L, vcId);
    return 1;
}

int ui_stringSize(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *string = luaStringParam(L, 2);
    NSString *fontId = luaStringParam(L, 3);
    CGFloat width = lua_tonumber(L, 4);
    CGFloat height = lua_tonumber(L, 5);
    UIFont *font = [LuaObjectManager objectWithId:fontId group:appId];
    if(font){
        CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, height)];
        lua_pushnumber(L, size.width);
        lua_pushnumber(L, size.height);
        return 2;
    }
    return 0;
}

#pragma mark - string
int ustring_substring(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *string = luaStringParam(L, 2);
    if([LuaCommonUtils isObjCObject:string]){
        NSString *appId = luaStringParam(L, 1);
        string = [LuaObjectManager objectWithId:string group:appId];
    }
    NSInteger beginIndex = [luaStringParam(L, 3) intValue];
    NSInteger endIndex = [luaStringParam(L, 4) intValue];
    
    NSString *resultString = @"";
    if(string.length != 0 && beginIndex <= string.length && endIndex <= string.length && beginIndex < endIndex){
        resultString = [string substringWithRange:NSMakeRange(beginIndex, endIndex - beginIndex)];
    }
    pushString(L, resultString);
    return 1;
}

int ustring_length(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *string = luaStringParam(L, 2);
    if([LuaCommonUtils isObjCObject:string]){
        NSString *appId = luaStringParam(L, 1);
        string = [LuaObjectManager objectWithId:string group:appId];
    }
    lua_pushnumber(L, [string length]);
    
    return 1;
}

int ustring_find(lua_State *L)
{
//    NSString *scriptId = luaStringParam(L, 1);
    NSString *string = luaStringParam(L, 2);
    if([LuaCommonUtils isObjCObject:string]){
        NSString *appId = luaStringParam(L, 1);
        string = [LuaObjectManager objectWithId:string group:appId];
    }
    NSString *targetStr = luaStringParam(L, 3);
    NSInteger fromIndex = lua_tointeger(L, 4);
    NSInteger reverse = lua_toboolean(L, 5);
    
    NSInteger location = -1;
    if(string.length > 0 && targetStr.length > 0 && fromIndex > -1 && fromIndex < string.length){
        NSRange tmpRange = [string rangeOfString:targetStr
                                         options:reverse == 1 ? NSBackwardsSearch : NSCaseInsensitiveSearch
                                           range:reverse == 1 ? NSMakeRange(0, fromIndex) : NSMakeRange(fromIndex, string.length - fromIndex)];
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
    NSString *string = luaStringParam(L, 2);
    if([LuaCommonUtils isObjCObject:string]){
        NSString *appId = luaStringParam(L, 1);
        string = [LuaObjectManager objectWithId:string group:appId];
    }
    NSString *occurrences = luaStringParam(L, 3);
    NSString *replacement = luaStringParam(L, 4);
    string = [string stringByReplacingOccurrencesOfString:occurrences withString:replacement];
    pushString(L, string);
    return 1;
}

#pragma mark - runtime
int runtime_recycleCurrentApp(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    [LuaObjectManager removeGroup:scriptId];
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

int runtime_objectClassName(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *objId = luaStringParam(L, 2);
    if([LuaCommonUtils isObjCObject:objId]){
        id object = [LuaObjectManager objectWithId:objId group:appId];
        if(object){
            pushString(L, NSStringFromClass([object class]));
        }else{
            pushString(L, @"nil");
        }
    }else{
        pushString(L, NSStringFromClass([NSString class]));
    }
    return 1;
}

int runtime_objectDescription(lua_State *L)
{
    NSString *appId = luaStringParam(L, 1);
    NSString *objId = luaStringParam(L, 2);
    if([LuaCommonUtils isObjCObject:objId]){
        id object = [LuaObjectManager objectWithId:objId group:appId];
        if(object){
            pushString(L, [NSString stringWithFormat:@"%@", object]);
        }else{
            pushString(L, @"nil");
        }
    }else{
        pushString(L, objId);
    }
    return 1;
}

#pragma mark - system
int nslog(lua_State *L)
{
    NSString *log = luaStringParam(L, 1);
    
    NSLog(@"%@", log);
    return 0;
}

int utils_log(lua_State *L)
{
    NSString *bundleId = luaStringParam(L, 1);
    NSString *log = luaStringParam(L, 2);
    
    LuaApp *app = [LuaAppManager appForId:bundleId];
    [app consoleOutput:[NSString stringWithFormat:@"%@", log]];
    NSLog(@"%@", log);
    
    return 0;
}

int utils_printObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *log = luaStringParam(L, 2);
    
    id targetObject = log;
    if([LuaCommonUtils isObjCObject:log]){
        id tmpObject = [LuaObjectManager objectWithId:log group:scriptId];
        if(tmpObject){
            targetObject = tmpObject;
        }
    }
    LuaApp *app = [LuaAppManager appForId:scriptId];
    [app consoleOutput:[NSString stringWithFormat:@"%@", targetObject]];
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
    LuaApp *app = [LuaAppManager appForId:scriptId];
    [app consoleOutput:[NSString stringWithFormat:@"%@", [RuntimeUtils descriptionOfObject:targetObject]]];
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
    pushFunctionToLua(L, "app_loadApp", app_loadApp);
    pushFunctionToLua(L, "app_cancelLoadApp", app_cancelLoadApp);
    pushFunctionToLua(L, "app_runApp", app_runApp);
    pushFunctionToLua(L, "app_getAppBundle", app_getAppBundle);
    pushFunctionToLua(L, "http_get", http_get);
    pushFunctionToLua(L, "http_post", http_post);
    pushFunctionToLua(L, "http_cancel", http_cancel);
    pushFunctionToLua(L, "http_download", http_download);
    pushFunctionToLua(L, "math_bor", math_byte_operator_or);
    pushFunctionToLua(L, "math_random", math_random);
    pushFunctionToLua(L, "NSLog", nslog);
    pushFunctionToLua(L, "runtime_recycle", runtime_recycleCurrentApp);
    pushFunctionToLua(L, "runtime_createObject", runtime_createObject);
    pushFunctionToLua(L, "runtime_invokeClassMethod", runtime_invokeClassMethod);
    pushFunctionToLua(L, "runtime_retainObject", runtime_retainObject);
    pushFunctionToLua(L, "runtime_releaseObject", runtime_releaseObject);
    pushFunctionToLua(L, "runtime_invokeMethod", runtime_invokeMethod);
    pushFunctionToLua(L, "runtime_objectRetainCount", runtime_objectRetainCount);
    pushFunctionToLua(L, "runtime_objectClassName", runtime_objectClassName);
    pushFunctionToLua(L, "runtime_objectDescription", runtime_objectDescription);
    pushFunctionToLua(L, "ui_alert", ui_alert);
    pushFunctionToLua(L, "ui_setRootViewController", ui_setRootViewController);
    pushFunctionToLua(L, "ui_dialog", ui_dialog);
    pushFunctionToLua(L, "ui_dialog_c", ui_dialog_c);
    pushFunctionToLua(L, "ui_animate", ui_animate);
    pushFunctionToLua(L, "ui_getRelatedViewController", ui_getRelatedViewController);
    pushFunctionToLua(L, "ui_stringSize", ui_stringSize);
    pushFunctionToLua(L, "ustring_find", ustring_find);
    pushFunctionToLua(L, "ustring_length", ustring_length);
    pushFunctionToLua(L, "ustring_substring", ustring_substring);
    pushFunctionToLua(L, "ustring_encodeURL", ustring_encodeURL);
    pushFunctionToLua(L, "ustring_replace", ustring_replace);
    pushFunctionToLua(L, "utils_log", utils_log);
    pushFunctionToLua(L, "utils_printObject", utils_printObject);
    pushFunctionToLua(L, "utils_printObjectDescription", utils_printObjectDescription);
    pushFunctionToLua(L, "utils_isObjCObject", utils_isObjCObject);
}






