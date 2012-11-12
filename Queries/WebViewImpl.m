//
//  WebViewImpl.m
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "WebViewImpl.h"
#import "LuaObjectManager.h"

@interface WebViewImpl () <UIWebViewDelegate>

@property(nonatomic, copy)BOOL(^shouldStartBlock)(NSString *);
@property(nonatomic, copy)void(^didLoadBlock)();
@property(nonatomic, copy)void(^didErrorBlock)(NSString *error);

@end

@implementation WebViewImpl

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    self.shouldStartBlock = nil;
    self.didLoadBlock = nil;
    self.didErrorBlock = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.delegate = self;
    
    return self;
}

#pragma mark - instance methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(self.shouldStartBlock){
        return self.shouldStartBlock(request.URL.absoluteString);
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.didLoadBlock){
        self.didLoadBlock();
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(self.didErrorBlock){
        self.didErrorBlock(error.localizedDescription);
    }
}

#pragma mark - class methods
+ (NSString *)createWebViewWithScriptId:(NSString *)scriptId
                                     si:(id<ScriptInteraction>)si
                                  frame:(CGRect)frame
                        shouldStartFunc:(NSString *)shouldStartFunc
                            didLoadFunc:(NSString *)didLoadFunc
                           didErrorFunc:(NSString *)didErrorFunc
{
    WebViewImpl *webView = [[[WebViewImpl alloc] initWithFrame:frame] autorelease];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSString *objId = [LuaObjectManager addObject:webView group:scriptId];
    if(shouldStartFunc.length != 0){
        webView.shouldStartBlock = ^BOOL(NSString *urlString){
            NSString *returnValue = [si callFunction:shouldStartFunc parameters:urlString, nil];
            return [returnValue intValue] == 1;
        };
    }
    if(didLoadFunc.length != 0){
        webView.didLoadBlock = ^{
            [si callFunction:didLoadFunc parameters:nil];
        };
    }
    if(didErrorFunc.length != 0){
        webView.didErrorBlock = ^(NSString *error){
            [si callFunction:didErrorFunc parameters:error, nil];
        };
    }
    
    return objId;
}

+ (void)loadRequestWithScriptId:(NSString *)scriptId webViewId:(NSString *)webViewId urlString:(NSString *)urlString
{
    WebViewImpl *webView = [LuaObjectManager objectWithId:webViewId group:scriptId];
    if(webView){
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
}

@end
