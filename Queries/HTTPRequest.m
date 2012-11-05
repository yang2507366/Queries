//
//  HTTPRequest.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "HTTPRequest.h"
#import "DelayController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface HTTPRequest ()

@property(nonatomic, copy)void (^callback)(NSString *, NSError *);
@property(nonatomic, copy)void(^returnDataCallback)(NSData *, NSError *);
@property(nonatomic, assign)BOOL recyclable;
@property(nonatomic, retain)ASIHTTPRequest *httpRequest;

@end

@implementation HTTPRequest

+ (id)requestWithURLString:(NSString *)URLString identifier:(NSString *)identifier completion:(void (^)(NSString *, NSError *))completion
{
    HTTPRequest *req = [[[HTTPRequest alloc] init] autorelease];
    [req requestWithURLString:URLString completion:completion];
    [ProviderPool addProviderToSharedPool:req identifier:identifier];
    return req;
}

+ (void)cancelRequestWithIdentifier:(NSString *)identifier
{
    [ProviderPool cleanWithIdentifier:identifier];
}

- (void)dealloc
{
    self.callback = nil;
    self.returnDataCallback = nil;
    [self.httpRequest clearDelegatesAndCancel]; self.httpRequest = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.recyclable = NO;
    [ASIHTTPRequest setDefaultUserAgentString:@"Queries"];
    
    return self;
}

- (void)requestWithURLString:(NSString *)URLString
{
    self.httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URLString]];
    self.httpRequest.delegate = self;
    self.httpRequest.didFinishSelector = @selector(httpRequestDidFinish:);
    self.httpRequest.didFailSelector = @selector(httpRequestDidError:);
    [self.httpRequest startAsynchronous];
}

- (void)requestWithURLString:(NSString *)URLString completion:(void (^)(NSString *, NSError *))completion
{
    self.callback = completion;
    [self requestWithURLString:URLString];
}

- (void)requestWithURLString:(NSString *)URLString returnData:(void(^)(NSData *data, NSError *error))returnData
{
    self.returnDataCallback = returnData;
    [self requestWithURLString:URLString];
}

- (void)postWithParameters:(NSDictionary *)params baseURLString:(NSString *)baseURLString completion:(void (^)(NSString *, NSError *))completion
{
    self.callback = completion;
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseURLString]];
    for(NSString *key in params){
        [formRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    self.httpRequest = formRequest;
    self.httpRequest.delegate = self;
    self.httpRequest.didFinishSelector = @selector(httpRequestDidFinish:);
    self.httpRequest.didFailSelector = @selector(httpRequestDidError:);
    [self.httpRequest startAsynchronous];
}

- (BOOL)isExecuting
{
    return self.httpRequest.isExecuting;
}

- (void)cancel
{
    self.callback = nil;
}

#pragma mark - ASIHTTPRequestDelegate
- (void)httpRequestDidFinish:(ASIHTTPRequest *)req
{
    self.recyclable = YES;
    if(self.callback){
        self.callback(req.responseString, nil);
    }
    
    if(self.returnDataCallback){
        self.returnDataCallback(req.responseData, nil);
    }
}

- (void)httpRequestDidError:(ASIHTTPRequest *)req
{
    self.recyclable = YES;
    NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class)
                                         code:-1
                                     userInfo:[NSDictionary dictionaryWithObject:@"网络连接错误" forKey:NSLocalizedDescriptionKey]];
    if(self.callback){
        self.callback(nil, error);
    }
    if(self.returnDataCallback){
        self.returnDataCallback(nil, error);
    }
}

#pragma mark - ProviderPoolable
- (void)providerWillRemoveFromPool
{
    [self cancel];
}

- (BOOL)providerIsExecuting
{
    return self.isExecuting;
}

- (BOOL)providerShouldBeRemoveFromPool
{
    return self.recyclable;
}

@end
