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

+ (NSString *)relatedViewControllerForAppId:(NSString *)appId;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName;

@end
