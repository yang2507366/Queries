//
//  lua_http_request.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaHTTPRequestImpl.h"
#import "HTTPRequest.h"

@implementation LuaHTTPRequestImpl

+ (NSMutableArray *)sharedRequestList
{
    static NSMutableArray *sharedRequestList = nil;
    @synchronized(self.class){
        if(sharedRequestList == nil){
            sharedRequestList = [[NSMutableArray array] retain];
        }
    }
    return sharedRequestList;
}

+ (BOOL)requestExists:(NSString *)requestId
{
    NSMutableArray *requestList = [self.class sharedRequestList];
    for(NSInteger i = 0; i < requestList.count; ++i){
        NSString *tmpRequest = [requestList objectAtIndex:i];
        if([tmpRequest isEqualToString:requestId]){
            return YES;
        }
    }
    return NO;
}

+ (NSString *)requestWithLuaState:(id<ScriptInteraction>)script urlString:(NSString *)urlString callbackLuaFunctionName:(NSString *)luaFunctionName
{
    NSString *requestId = [NSString stringWithFormat:@"%d", (NSInteger)urlString];
    [[self.class sharedRequestList] addObject:requestId];
    
    [HTTPRequest requestWithURLString:urlString identifier:requestId completion:^(NSString *responseStr, NSError *error) {
        if(error){
            if([self.class requestExists:requestId]){
                [script callFunction:luaFunctionName callback:nil parameters:@"", error.localizedDescription, nil];
            }
        }else{
            if(responseStr.length == 0){
                responseStr = @"";
            }
            if([self.class requestExists:requestId]){
                [script callFunction:luaFunctionName callback:nil parameters:responseStr, @"", nil];
            }
        }
    }];
    
    return requestId;
}

+ (void)cancelRequestWithRequestId:(NSString *)requestId
{
    NSMutableArray *requestList = [self.class sharedRequestList];
    for(NSInteger i = 0; i < requestList.count; ++i){
        NSString *tmpRequest = [requestList objectAtIndex:i];
        if([tmpRequest isEqualToString:requestId]){
            [requestList removeObjectAtIndex:i];
            break;
        }
    }
}

@end
