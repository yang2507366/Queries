//
//  lua_http_request.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "HTTPRequestImpl.h"
#import "HTTPRequest.h"

@implementation HTTPRequestImpl

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

+ (NSMutableDictionary *)sharedRequestDictionary
{
    static NSMutableDictionary *requestDictionary = nil;
    @synchronized(self.class){
        if(requestDictionary == nil){
            requestDictionary = [[NSMutableDictionary dictionary] retain];
        }
    }
    return requestDictionary;
}

+ (BOOL)requestExists:(NSString *)requestId
{
    return [[self sharedRequestDictionary] objectForKey:requestId] != nil;
}

+ (NSString *)requestWithLuaState:(id<ScriptInteraction>)script urlString:(NSString *)urlString callbackLuaFunctionName:(NSString *)luaFunctionName
{
    NSString *requestId = [NSString stringWithFormat:@"%d", (NSInteger)urlString];
    
    id req = [HTTPRequest requestWithURLString:urlString identifier:requestId completion:^(NSString *responseStr, NSError *error) {
        if(error){
            if([self.class requestExists:requestId]){
                [script callFunction:luaFunctionName callback:nil parameters:requestId, @"", error.localizedDescription, nil];
            }
        }else{
            if(responseStr.length == 0){
                responseStr = @"";
            }
            if([self.class requestExists:requestId]){
                [script callFunction:luaFunctionName callback:nil parameters:requestId, responseStr, @"", nil];
            }
        }
    }];
    [[self sharedRequestDictionary] setObject:req forKey:requestId];
    
    return requestId;
}

+ (void)cancelRequestWithRequestId:(NSString *)requestId
{
    id<HTTPGetRequest> req = [[self sharedRequestDictionary ] objectForKey:requestId];
    if(req){
        [req cancel];
        [[self sharedRequestDictionary] removeObjectForKey:requestId];
    }
}

@end
