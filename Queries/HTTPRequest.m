//
//  HTTPRequest.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "HTTPRequest.h"
#import "DelayController.h"

@interface HTTPRequest () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, DelayControllerDelegate>

@property(nonatomic, copy)void (^callback)(NSString *, NSError *);
@property(nonatomic, copy)void(^returnDataCallback)(NSData *, NSError *);
@property(nonatomic, retain)NSURLConnection *URLConnection;
@property(nonatomic, retain)NSMutableData *responseData;
@property(nonatomic, assign)BOOL complete;
@property(nonatomic, retain)DelayController *timeOutChecker;

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
    [self.URLConnection cancel]; self.URLConnection = nil;
    self.responseData = nil;
    [self.timeOutChecker cancel]; self.timeOutChecker = nil;
    [super dealloc];
}

- (void)requestWithURLString:(NSString *)URLString
{
    self.responseData = [NSMutableData data];
    
    NSURL *url = [NSURL URLWithString:URLString];
    self.URLConnection = [[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self] autorelease];
    [self.URLConnection start];
    self.complete = NO;
    self.timeOutChecker = [[[DelayController alloc] initWithInterval:10] autorelease];
    self.timeOutChecker.delegate = self;
    [self.timeOutChecker start];
    NSLog(@"%@", URLString);
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

- (BOOL)isExecuting
{
    return self.complete;
}

- (void)cancel
{
    self.callback = nil;
    [self.URLConnection cancel];
}

- (void)setComplete:(BOOL)complete
{
    _complete = complete;
    [_timeOutChecker cancel];
}

#pragma mark - DelayControllerDelegate
- (void)delayControllerDidFinishDelay:(DelayController *)controller
{
    [self cancel];
    self.complete = YES;
    if(self.callback){
        self.callback(nil, [NSError errorWithDomain:NSStringFromClass(self.class)
                                               code:-1
                                           userInfo:[NSDictionary dictionaryWithObject:@"网络连接超时" forKey:NSLocalizedDescriptionKey]]);
    }
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.callback){
        self.callback(nil, error);
    }
    if(self.returnDataCallback){
        self.returnDataCallback(nil, error);
    }
    self.complete = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease];
    if(self.callback){
        self.callback(responseString, nil);
    }
    if(self.returnDataCallback){
        self.returnDataCallback(self.responseData, nil);
    }
    self.complete = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
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
    return self.complete;
}

@end
