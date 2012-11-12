//
//  LuaScriptManager.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"
#import "ScriptBundle.h"
#import "LuaApp.h"

@interface LuaAppManager : NSObject

+ (UIWindow *)currentWindow;
+ (id<ScriptInteraction>)scriptInteractionWithAppId:(NSString *)appId;
+ (NSString *)scriptWithScriptName:(NSString *)scriptName appId:(NSString *)appId;
+ (LuaApp *)appForId:(NSString *)appId;

+ (void)runRootApp:(LuaApp *)app;
+ (void)runApp:(LuaApp *)app;
+ (void)destoryAppWithAppId:(NSString *)appId;

@end
