//
//  lua_http_request.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaHTTPRequest.h"

@implementation LuaHTTPRequest

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
    NSString *identifierForUrl = [NSString stringWithFormat:@"%d", (NSInteger)urlString];
    [[self.class sharedRequestList] addObject:identifierForUrl];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *err) {
        NSHTTPURLResponse *response = (id)res;
        if(response.statusCode == 200){
            NSString *responseStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            if(responseStr.length == 0){
                responseStr = @"";
            }
            if([self.class requestExists:identifierForUrl]){
                [script callFunction:luaFunctionName callback:nil parameters:responseStr, @"", nil];
            }
        }else{
            if([self.class requestExists:identifierForUrl]){
                [script callFunction:luaFunctionName callback:nil parameters:@"", err.localizedDescription, nil];
            }
        }
    }];
    
    return identifierForUrl;
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
