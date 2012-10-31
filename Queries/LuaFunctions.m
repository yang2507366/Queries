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
#import "TableViewImpl.h"
#import "UIBarButtonItemImpl.h"
#import "MethodInvokerForLua.h"
#import "LuaConstants.h"
#import "LuaGroupedObjectManager.h"
#import "RuntimeUtils.h"

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
    
    NSUInteger type = lua_tointeger(L, 2);
    NSString *tappedFunc = luaStringParam(L, 3);
    
    id<ScriptInteraction> si = scriptInteractionForScriptId(scriptId);
    NSString *buttonId = [ButtonImpl createWithScriptId:scriptId si:si type:type tappedFunc:tappedFunc];
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

int ui_addSubviewToView(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *toViewId = luaStringParam(L, 2);
    NSString *viewId = luaStringParam(L, 3);
    
    [UIRelatedImpl addSubviewToViewWithScriptId:scriptId viewId:viewId toViewId:toViewId];
    
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
    pushString(L, [NSString stringWithFormat:@"%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height]);
    return 1;
}

int ui_getViewBounds(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *viewId = luaStringParam(L, 2);
    
    CGRect frame = [UIRelatedImpl boundsOfViewWithViewId:viewId scriptId:scriptId];
    lua_pushnumber(L, frame.origin.x);
    lua_pushnumber(L, frame.origin.y);
    lua_pushnumber(L, frame.size.width);
    lua_pushnumber(L, frame.size.height);
    return 4;
}

int ui_viewForTag(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *viewId = luaStringParam(L, 2);
    NSInteger tag = lua_tonumber(L, 3);
    
    pushString(L, [UIRelatedImpl viewForTagWithScriptId:scriptId viewId:viewId tag:tag]);
    return 1;
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
    NSString *viewDidPopedFunc = luaStringParam(L, 5);
    
    NSString *vcId = [ViewControllerImpl createViewControllerWithScriptId:scriptId
                                                                       si:scriptInteractionForScriptId(scriptId)
                                                                    title:title
                                                          viewDidLoadFunc:viewDidLoadFunc
                                                       viewWillAppearFunc:viewWillAppearFunc
                                                         viewDidPopedFunc:viewDidPopedFunc];
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

int ui_pushViewControllerToNavigationController(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *vcId = luaStringParam(L, 2);
    NSString *ncId = luaStringParam(L, 3);
    BOOL animated = lua_toboolean(L, 4);
    
    [UIRelatedImpl pushViewControlerToNaviationControllerWithScriptId:scriptId
                                                     viewControllerId:vcId
                                               navigationControllerId:ncId
                                                             animated:animated];
    
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

int ui_createTableView(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    CGRect frame = luaRect(luaStringParam(L, 2));
    NSString *numOfRowsFunc = luaStringParam(L, 3);
    NSString *wrapCellFunc = luaStringParam(L, 4);
    NSString *didSelectFunc = luaStringParam(L, 5);
    NSString *heightForRowFunc = luaStringParam(L, 6);
    
    NSString *tableViewId = [TableViewImpl createTableViewWithScriptId:scriptId
                                                                    si:scriptInteractionForScriptId(scriptId)
                                                                 frame:frame
                                                      numberOfRowsFunc:numOfRowsFunc
                                                          wrapCellFunc:wrapCellFunc
                                                         didSelectFunc:didSelectFunc
                                                      heightForRowFunc:heightForRowFunc];
    pushString(L, tableViewId);
    
    return 1;
}

int ui_createBarButtonItem(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *title = luaStringParam(L, 2);
    NSString *tapFunc = luaStringParam(L, 3);
    
    pushString(L, [UIBarButtonItemImpl createBarButtonItemWithScriptId:scriptId
                                                                    si:scriptInteractionForScriptId(scriptId)
                                                                 title:title
                                                          callbackFunc:tapFunc]);
    return 1;
}

int ui_heightOfLabelText(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    CGFloat width = lua_tonumber(L, 3);
    
    UILabel *label = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(width, 100000)];
    
    lua_pushnumber(L, size.height);
    return 1;
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
    
    NSString *returnValue = [MethodInvokerForLua invokeWithGroup:scriptId objectId:objectId methodName:methodName parameters:params];
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
    
    NSString *returnValue = [MethodInvokerForLua createObjectWithGroup:scriptId
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
    
    NSString *returnValue = [MethodInvokerForLua invokeClassMethodWithGroup:scriptId className:className methodName:methodName parameters:params];
    pushString(L, returnValue);
    return 1;
}

int runtime_retainObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    
    [LuaGroupedObjectManager retainObjectWithId:objectId group:scriptId];
    return 0;
}

int runtime_releaseObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    NSString *objectId = luaStringParam(L, 2);
    
    BOOL recycled = [LuaGroupedObjectManager releaseObjectWithId:objectId group:scriptId];
    lua_pushboolean(L, recycled ? 1 : 0);
    return 1;
}

#pragma mark - obj
int obj_invokeMethod(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    
    [RuntimeImpl invokeObjectMethodWithScriptId:scriptId objectId:objectId methodName:methodName];
    return 0;
}

int obj_invokeMethodSetValue(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    NSString *value = luaStringParam(L, 4);
    
    [RuntimeImpl invokeObjectMethodSetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:value];
    return 0;
}

int obj_invokeMethodGetValue(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    
    NSString *returnValue = [RuntimeImpl invokeObjectMethodGetStringWithScriptId:scriptId objectId:objectId methodName:methodName value:nil];
    pushString(L, returnValue);
    return 1;
}

int obj_invokeMethodSetObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    NSString *valueObjectId = luaStringParam(L, 4);
    
    [RuntimeImpl invokeObjectMethodSetObjectIdWithScriptId:scriptId objectId:objectId methodName:methodName valueObjectId:valueObjectId];
    
    return 0;
}

int obj_invokeMethodGetObject(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *objectId = luaStringParam(L, 2);
    NSString *methodName = luaStringParam(L, 3);
    
    NSString *targetObjectId = [RuntimeImpl invokeObjectMethodGetObjectIdWithScriptId:scriptId objectId:objectId methodName:methodName];
    pushString(L, targetObjectId);
    return 1;
}

int obj_invokeMethodSetValueAndGetValue(lua_State *L)
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

int obj_createObjectWithClassName(lua_State *L)
{
    NSString *scriptId = luaStringParam(L, 1);
    
    NSString *className = luaStringParam(L, 2);
    pushString(L, [RuntimeImpl createObjectWithScriptId:scriptId objectClassName:className]);
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
        id tmpObject = [LuaGroupedObjectManager objectWithId:log group:scriptId];
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
        id tmpObject = [LuaGroupedObjectManager objectWithId:log group:scriptId];
        if(tmpObject){
            targetObject = tmpObject;
        }
    }
    
    NSLog(@"%@", [RuntimeUtils descriptionOfObject:targetObject]);
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
#pragma mark - http::request
    pushFunctionToLua(L, "http_request", http_request);
#pragma mark - http::cancel
    pushFunctionToLua(L, "http_cancel", http_cancel);
#pragma mark - math::operator_or
    pushFunctionToLua(L, "math_operator_or", math_operator_or);
#pragma mark - NSLog
    pushFunctionToLua(L, "NSLog", nslog);
#pragma mark - obj::invokeMethod
    /**
     调用无参数和返回值的实例方法，
     调用实例：obj::invokeMethod(objId, methodName);
     */
    pushFunctionToLua(L, "obj_invokeMethod", obj_invokeMethod);
#pragma mark - obj::invokeMethodSetValue
    /**
     调用一个字符串参数，无返回值的实例方法(该方法的类型可以是除结构体之外的任意类型，系统会自动将lua传入的字符串转换成目标类型)，
     调用实例：obj::invokeMethodSetValue(objId, methodName, value);
     */
    pushFunctionToLua(L, "obj_invokeMethodSetValue", obj_invokeMethodSetValue);
#pragma mark - obj::invokeMethodGetValue
    /**
     调用无参数，一个字符串返回值的实例方法（该方法的返回值是除结构体之外的任意类型，系统会自动将目标类型转换成一个字符串类型），
     调用实例：value = obj::invokeMethodGetValue(objId, methodName)
     */
    pushFunctionToLua(L, "obj_invokeMethodGetValue", obj_invokeMethodGetValue);
#pragma mark - obj::invokeMethodSetObject
    /**
     调用对象实例指定方法名的方法，该方法有一个id类型的参数，无返回值
     调用示例：obj::invokeMethodSetObject(obj, "setObject", valueObj);
     */
    pushFunctionToLua(L, "obj_invokeMethodSetObject", obj_invokeMethodSetObject);
#pragma mark - obj::invokeMethodGetObject
    /**
     调用对象的实例方法，并且返回一个对象的id，
     调用示例：objId = obj::obj_invokeMethodGetObject(objId, methodName);
     */
    pushFunctionToLua(L, "obj_invokeMethodGetObject", obj_invokeMethodGetObject);
#pragma mark - obj::invokeInstanceMethodSetValueAndGetValue
    /**
     调用有一个字符串参数，一个字符串返回值的实例方法（方法返回值和参数描述参考上述两个函数），
     调用实例：value = obj::invokeMethodSetValueAndGetValue(objId, methodName, value);
     */
    pushFunctionToLua(L, "obj_invokeMethodSetValueAndGetValue", obj_invokeMethodSetValueAndGetValue);    
#pragma mark - obj::invokePropertySet
    /**
     调用对象的property set方法，参数为一个字符串，系统会自动转化成目标类型
     调用实例：obj::invokePropertySet(objId, propertyName, value);
     */
    pushFunctionToLua(L, "obj_invokePropertySet", obj_invokePropertySet);
#pragma mark - obj::invokePropertyGet
    /**
     调用对象的property get方法，不管返回值为什么类型，系统都会自动转换并且返回一个字符串
     调用实例：value = obj::invokePropertyGet(objId, propertyName);
     */
    pushFunctionToLua(L, "obj_invokePropertyGet", obj_invokePropertyGet);
#pragma mark - obj::propertyOfObject
    /**
     获取对象的property对应的对象id，该property的数据类型必须是id类型
     调用实例：propertyId = obj::propertyOfObject(objId, propertyName);
     */
    pushFunctionToLua(L, "obj_propertyOfObject", obj_propertyOfObject);
#pragma mark - obj::createOjectWithClassName
    /**
     创建指定className的对象
     调用示例：objectId = obj::createObjectWithClassName(className);
     */
    pushFunctionToLua(L, "obj_createObjectWithClassName", obj_createObjectWithClassName);
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
#pragma amrk - runtime::invokeMethod
    pushFunctionToLua(L, "runtime_invokeMethod", runtime_invokeMethod);
#pragma mark - script::runScriptWithId
    pushFunctionToLua(L, "script_runScriptWithId", script_runScriptWithId);
#pragma mark - ui::createButton
    pushFunctionToLua(L, "ui_createButton", ui_createButton);
#pragma mark - ui::addSubviewToViewController
    pushFunctionToLua(L, "ui_addSubviewToViewController", ui_addSubviewToViewController);
#pragma mark - ui::addSubview
    /**
     调用示例：ui::addSubview(viewId, subViewId);
     */
    pushFunctionToLua(L, "ui_addSubview", ui_addSubviewToView);
#pragma mark - ui::setViewFrame
    pushFunctionToLua(L, "ui_setViewFrame", ui_setViewFrame);
#pragma mark - ui::getViewFrame
    pushFunctionToLua(L, "ui_getViewFrame", ui_getViewFrame);
#pragma mark - ui::getViewBounds
    pushFunctionToLua(L, "ui_getViewBounds", ui_getViewBounds);
#pragma mark - ui::viewForTag
    /**
     调用示例：ui::viewForTag(viewId, 1001);
     */
    pushFunctionToLua(L, "ui_viewForTag", ui_viewForTag);
#pragma mark - ui::alert
    pushFunctionToLua(L, "ui_alert", ui_alert);
#pragma mark - ui::createViewController
    pushFunctionToLua(L, "ui_createViewController", ui_createViewController);
#pragma mark - ui::setRootViewController
    pushFunctionToLua(L, "ui_setRootViewController", ui_setRootViewController);
#pragma mark - ui::pushViewControllerToNavigationController
    pushFunctionToLua(L, "ui_pushViewControllerToNavigationController", ui_pushViewControllerToNavigationController);
#pragma mark - ui::createNavigationController
    pushFunctionToLua(L, "ui_createNavigationController", ui_createNavigationController);
#pragma mark - ui::createNavigationController
    pushFunctionToLua(L, "ui_createTextField", ui_createTextField);
#pragma mark - ui::createLabel
    pushFunctionToLua(L, "ui_createLabel", ui_createLabel);
#pragma mark - ui::createWebView
    pushFunctionToLua(L, "ui_createWebView", ui_createWebView);
#pragma mark - ui::webViewLoadURL
    pushFunctionToLua(L, "ui_webViewLoadURL", ui_webViewLoadURL);
#pragma mark - ui::createTableView
    /**
     创建tableView
     调用实例：ui::createTableView("0, 0, 320, 480", "numberOfRowsFunc", "wrapCellFunc");
     */
    pushFunctionToLua(L, "ui_createTableView", ui_createTableView);
#pragma mark - ui::createBarButtonItem
    /**
     调用示例：ui::createBarButtonItem("title", "callbackFunc");
     */
    pushFunctionToLua(L, "ui_createBarButtonItem", ui_createBarButtonItem);
#pragma mark - ui::heightOfLabelText
    pushFunctionToLua(L, "ui_heightOfLabelText", ui_heightOfLabelText);
#pragma mark - ustring::find
    pushFunctionToLua(L, "ustring_find", ustring_find);
#pragma mark - ustring::length
    pushFunctionToLua(L, "ustring_length", ustring_length);
#pragma mark - ustring::substring
    pushFunctionToLua(L, "ustring_substring", ustring_substring);
#pragma mark - utils::printObject
    pushFunctionToLua(L, "utils_printObject", utils_printObject);
#pragma mark - utils::printObjectDescription
    pushFunctionToLua(L, "utils_printObjectDescription", utils_printObjectDescription);
}






