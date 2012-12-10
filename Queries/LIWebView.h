//
//  LIWebView.h
//  Queries
//
//  Created by yangzexin on 12/10/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"

@interface LIWebView : UIWebView <LuaImplentatable>

@property(nonatomic, copy)NSString *shouldStartLoadWithRequest;
@property(nonatomic, copy)NSString *didStartLoad;
@property(nonatomic, copy)NSString *didFinishLoad;
@property(nonatomic, copy)NSString *didFailLoadWithError;

@end
