//
//  lua_http_request.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface HTTPRequestImpl : NSObject

+ (NSString *)requestWithLuaState:(id<ScriptInteraction>)script urlString:(NSString *)urlString callbackLuaFunctionName:(NSString *)luaFunctionName;
+ (NSString *)postWithSi:(id<ScriptInteraction>)si urlString:(NSString *)urlString parameters:(NSMutableDictionary *)params callbackFunc:(NSString *)callbackFunc;
+ (void)cancelRequestWithRequestId:(NSString *)requestId;

@end
