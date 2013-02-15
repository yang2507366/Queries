//
//  LuaApp.h
//  Queries
//
//  Created by yangzexin on 11/2/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptBundle.h"
#import "ScriptInteraction.h"

@interface LuaApp : NSObject

@property(nonatomic, readonly)id<ScriptBundle>scriptBundle;
@property(nonatomic, retain)id<ScriptInteraction> scriptInteraction;
@property(nonatomic, readonly)UIWindow *baseWindow;
@property(nonatomic, retain)UIViewController *relatedViewController;
@property(nonatomic, copy)void(^consoleOutputBlock)(NSString *output);
- (id)initWithScriptBundle:(id<ScriptBundle>)scriptBundle baseWindow:(UIWindow *)window;
- (void)consoleOutput:(NSString *)output;

@end
