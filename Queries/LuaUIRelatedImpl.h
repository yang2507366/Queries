//
//  ViewControllerManager.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface UIManager : NSObject

+ (NSString *)rootViewControllerId;
+ (void)addSubViewWithViewId:(NSString *)viewId viewControllerId:(NSString *)viewControllerId;
+ (void)pushViewControllerWithId:(NSString *)viewControllerId sourceViewControllerId:(NSString *)sourceViewControllerId;
+ (NSString *)createViewControllerWithTitle:(NSString *)title;
+ (NSString *)createButtonWithTitle:(NSString *)title scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName;
+ (void)setViewFrameWithViewId:(NSString *)viewId frame:(NSString *)frame;
+ (CGRect)frameOfViewWithViewId:(NSString *)viewId;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName;

@end
