//
//  LuaScriptManager.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface LuaApplication : NSObject

+ (void)run;
+ (void)runOnWindow:(UIWindow *)window;
+ (UIWindow *)window;
+ (id<ScriptInteraction>)programWithScriptId:(NSString *)scriptId;
+ (void)removeProgramWithScriptId:(NSString *)scriptId;
+ (id<ScriptInteraction>)restartProgramWithScriptId:(NSString *)scritId;
+ (NSString *)originalScriptWithScriptId:(NSString *)scriptId;
+ (NSString *)scriptWithScriptId:(NSString *)scriptId;
+ (NSString *)requireScriptWithScriptId:(NSString *)scriptId;

@end
