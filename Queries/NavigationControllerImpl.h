//
//  NavigationControllerImpl.h
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface NavigationControllerImpl : UINavigationController

+ (NSString *)createNavigationControllerWithScriptId:(NSString *)scriptId
                                                  si:(id<ScriptInteraction>)si
                                rootViewControllerId:(NSString *)rootViewControllerId;

@end
