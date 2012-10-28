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

+ (void)pushViewControlerToNaviationControllerWithScriptId:(NSString *)scriptId
                                          viewControllerId:(NSString *)vcId
                                    navigationControllerId:(NSString *)ncId
                                                  animated:(BOOL)animated;

+ (void)setViewFrameWithViewId:(NSString *)viewId frame:(NSString *)frame scriptId:(NSString *)scriptId;

+ (CGRect)frameOfViewWithViewId:(NSString *)viewId scriptId:(NSString *)scriptId;
+ (CGRect)boundsOfViewWithViewId:(NSString *)viewId scriptId:(NSString *)scriptId;

+ (NSString *)viewForTagWithScriptId:(NSString *)scriptId viewId:(NSString *)viewId tag:(NSInteger)tag;
+ (void)addSubviewToViewWithScriptId:(NSString *)scriptId viewId:(NSString *)viewId toViewId:(NSString *)toViewId;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName;

@end
