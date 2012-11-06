//
//  lua_http_request.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

#define kHTTPRequestEncodingDefault @"Default"
#define KHTTPRequestEncodingUTF8    @"UTF8"
#define kHTTPRequestEncodingGBK     @"GBK"

@interface HTTPRequestImpl : NSObject

+ (NSString *)requestWithLuaState:(id<ScriptInteraction>)script
                        urlString:(NSString *)urlString
          callbackLuaFunctionName:(NSString *)luaFunctionName
                         encoding:(NSString *)encoding;
+ (NSString *)postWithSi:(id<ScriptInteraction>)si
               urlString:(NSString *)urlString
              parameters:(NSMutableDictionary *)params
            callbackFunc:(NSString *)callbackFunc
                encoding:(NSString *)encoding;
+ (void)cancelRequestWithRequestId:(NSString *)requestId;

@end
