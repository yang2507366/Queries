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

+ (NSBundle *)baseScriptsBundle;
+ (NSString *)baseScriptWithScriptName:(NSString *)scriptName;

+ (UIWindow *)currentWindow;
+ (id<ScriptInteraction>)scriptInteractionWithAppId:(NSString *)appId;
+ (NSString *)scriptWithScriptName:(NSString *)scriptName appId:(NSString *)appId;
+ (LuaApp *)appForId:(NSString *)appId;

+ (id)runRootApp:(LuaApp *)app;
+ (id)runRootApp:(LuaApp *)app params:(id)params;
+ (id)runApp:(LuaApp *)app;
+ (id)runApp:(LuaApp *)app params:(id)params;
+ (void)destoryAppWithAppId:(NSString *)appId;

@end
