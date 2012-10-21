//
//  LuaScriptManager.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaApplication : NSObject

+ (void)run;
+ (void)runOnWindow:(UIWindow *)window;
+ (UIWindow *)window;
+ (NSString *)originalScriptWithScriptId:(NSString *)scriptId;
+ (NSString *)scriptWithScriptId:(NSString *)scriptId;

@end
