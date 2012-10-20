//
//  HTTPRequest.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property(nonatomic, copy)void (^callback)(NSString *, NSError *);
@property(nonatomic, retain)NSURLConnection *URLConnection;
@property(nonatomic, retain)NSMutableData *responseData;
@property(nonatomic, assign)BOOL complete;

@end

@implementation HTTPRequest

+ (void)requestWithURLString:(NSString *)URLString identifier:(NSString *)identifier completion:(void (^)(NSString *, NSError *))completion
{
    HTTPRequest *req = [[[HTTPRequest alloc] init] autorelease];
    [req requestWithURLString:URLString completion:completion];
    [ProviderPool addProviderToSharedPool:req identifier:identifier];
}

+ (void)cancelRequestWithIdentifier:(NSString *)identifier
{
    [ProviderPool cleanWithIdentifier:identifier];
}

- (void)dealloc
{
    self.callback = nil;
    [self.URLConnection cancel]; self.URLConnection = nil;
    self.responseData = nil;
    [super dealloc];
}

- (void)requestWithURLString:(NSString *)URLString completion:(void (^)(NSString *, NSError *))completion
{
    self.callback = completion;
    
    self.responseData = [NSMutableData data];
    
    NSURL *url = [NSURL URLWithString:URLString];
    self.URLConnection = [[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self] autorelease];
    [self.URLConnection start];
    self.complete = NO;
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

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.callback){
        self.callback(nil, error);
    }
    self.complete = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease];
    if(self.callback){
        self.callback(responseString, nil);
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
