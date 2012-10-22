//
//  ViewControllerManager.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface UIRelatedImpl : NSObject

+ (void)setRootViewControllerWithId:(NSString *)viewControllerId scriptId:(NSString *)scriptId;

+ (void)addSubViewWithViewId:(NSString *)viewId viewControllerId:(NSString *)viewControllerId scriptId:(NSString *)scriptId;

+ (void)pushViewControllerWithId:(NSString *)viewControllerId sourceViewControllerId:(NSString *)sourceViewControllerId scriptId:(NSString *)scriptId;

+ (void)setViewFrameWithViewId:(NSString *)viewId frame:(NSString *)frame scriptId:(NSString *)scriptId;

+ (CGRect)frameOfViewWithViewId:(NSString *)viewId scriptId:(NSString *)scriptId;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName;

@end
