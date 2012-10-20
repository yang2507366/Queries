//
//  lua_http_request.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface LuaHTTPRequest : NSObject

+ (NSString *)requestWithLuaState:(id<ScriptInteraction>)script urlString:(NSString *)urlString callbackLuaFunctionName:(NSString *)luaFunctionName;
+ (void)cancelRequestWithRequestId:(NSString *)requestId;

@end
