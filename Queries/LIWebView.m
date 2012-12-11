//
//  LIWebView.m
//  Queries
//
//  Created by yangzexin on 12/10/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIWebView.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"
#import "UIWebViewAdditions.h"

@interface LIWebView () <UIWebViewDelegate>

@end

@implementation LIWebView

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    self.shouldStartLoadWithRequest = nil;
    self.didStartLoad = nil;
    self.didFinishLoad = nil;
    self.didFailLoadWithError = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.delegate = self;
    [self removeShadow];
    
    return self;
}


- (void)loadURLString:(NSString *)URLString
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [self loadRequest:req];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(self.shouldStartLoadWithRequest.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.appId]
                 callFunction:self.shouldStartLoadWithRequest parameters:self.objId,
                 [request.URL absoluteString],[NSString stringWithFormat:@"%d", navigationType], nil] boolValue];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(self.didStartLoad.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.didStartLoad parameters:self.objId, nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.didFinishLoad.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.didFinishLoad parameters:self.objId, nil];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(self.didFailLoadWithError.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.didFailLoadWithError parameters:self.objId, error.localizedDescription, nil];
    }
}

+ (NSString *)create:(NSString *)appId
{
    LIWebView *tmp = [[LIWebView new] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
