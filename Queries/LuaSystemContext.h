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

@interface LuaSystemContext : NSObject

+ (UIWindow *)currentWindow;
+ (id<ScriptInteraction>)scriptInteractionWithAppId:(NSString *)appId;
+ (NSString *)scriptWithScriptName:(NSString *)scriptName appId:(NSString *)appId;

+ (void)runApp:(LuaApp *)app;

@end
