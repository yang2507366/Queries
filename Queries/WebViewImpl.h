//
//  WebViewImpl.h
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface WebViewImpl : UIWebView

+ (NSString *)createWebViewWithScriptId:(NSString *)scriptId
                                     si:(id<ScriptInteraction>)si
                                  frame:(CGRect)frame
                        shouldStartFunc:(NSString *)shouldStartFunc
                            didLoadFunc:(NSString *)didLoadFunc
                           didErrorFunc:(NSString *)didErrorFunc;
+ (void)loadRequestWithScriptId:(NSString *)scriptId webViewId:(NSString *)webViewId urlString:(NSString *)urlString;

@end
