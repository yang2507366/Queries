//
//  lua_http_request.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIHTTPRequest.h"
#import "HTTPRequest.h"
#import "HTTPDownloader.h"
#import "CommonUtils.h"

@implementation LIHTTPRequest

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

+ (NSString *)dataToString:(NSData *)data encoding:(NSString *)encoding
{
    CFStringEncoding cfEncoding = kCFStringEncodingUTF8;
    if([encoding isEqualToString:kHTTPRequestEncodingGBK]){
        cfEncoding = kCFStringEncodingGB_18030_2000;
    }
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
    return [[[NSString alloc] initWithData:data encoding:enc] autorelease];
}

+ (NSString *)requestWithLuaState:(id<ScriptInteraction>)script
                        urlString:(NSString *)urlString
          callbackLuaFunctionName:(NSString *)luaFunctionName
                         encoding:(NSString *)encoding
{
    NSString *requestId = [NSString stringWithFormat:@"%d", (NSInteger)urlString];
    
    id<HTTPGetRequest> request = [[[HTTPRequest alloc] init] autorelease];
    [request requestWithURLString:urlString returnData:^(NSData *data, NSError *error) {
        if(error){
            if([self requestExists:requestId]){
                [script callFunction:luaFunctionName callback:nil parameters:requestId, @"", error.localizedDescription, nil];
            }
        }else{
            NSString *responseString = [self dataToString:data encoding:encoding];
            if([self requestExists:requestId]){
                [script callFunction:luaFunctionName callback:nil parameters:requestId, responseString, @"", nil];
            }
        }
        [[self sharedRequestDictionary] removeObjectForKey:requestId];
    }];
    [ProviderPool addProviderToSharedPool:request identifier:requestId];
    [[self sharedRequestDictionary] setObject:request forKey:requestId];
    
    return requestId;
}

+ (NSString *)postWithSi:(id<ScriptInteraction>)si
               urlString:(NSString *)urlString
              parameters:(NSMutableDictionary *)params
            callbackFunc:(NSString *)callbackFunc
                encoding:(NSString *)encoding
{
    NSString *requestId = [NSString stringWithFormat:@"%d", (NSInteger)urlString];
    
    HTTPRequest *req = [[HTTPRequest new] autorelease];
    [req postWithParameters:params baseURLString:urlString returnData:^(NSData *data, NSError *error) {
        if(error){
            if([self.class requestExists:requestId]){
                [si callFunction:callbackFunc callback:nil parameters:requestId, @"", error.localizedDescription, nil];
            }
        }else{
            NSString *responseString = [self dataToString:data encoding:encoding];
            if([self.class requestExists:requestId]){
                [si callFunction:callbackFunc callback:nil parameters:requestId, responseString, @"", nil];
            }
        }
        [[self sharedRequestDictionary] removeObjectForKey:requestId];
    }];
    [ProviderPool addProviderToSharedPool:req identifier:requestId];
    [[self sharedRequestDictionary] setObject:req forKey:requestId];
    
    return requestId;
}

+ (NSString *)downloadWithSi:(id<ScriptInteraction>)si
                   URLString:(NSString *)URLString
            progressFuncName:(NSString *)progressFuncName
          completionFuncName:(NSString *)completionFuncName
{
    HTTPDownloader *downloader = [[HTTPDownloader new] autorelease];
    NSString *reqId = [NSString stringWithFormat:@"%d", [downloader hash]];
    [[self sharedRequestDictionary] setObject:downloader forKey:reqId];
    [ProviderPool addProviderToSharedPool:downloader identifier:reqId];
    [downloader downloadWithURLString:URLString progress:^(long long downloadedLength, long long totalLength) {
        if(progressFuncName.length != 0){
            [si callFunction:progressFuncName
                  parameters:reqId, [NSString stringWithFormat:@"%lld", downloadedLength], [NSString stringWithFormat:@"%lld", totalLength], nil];
        }
    } completion:^(NSString *tmpFilePath, NSError *error) {
        if(completionFuncName.length != 0){
            [si callFunction:completionFuncName
                  parameters:reqId, [CommonUtils filterNil:tmpFilePath], [CommonUtils filterNil:error.localizedDescription], nil];
        }
        [[self sharedRequestDictionary] removeObjectForKey:reqId];
    }];
    return reqId;
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
