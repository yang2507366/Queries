//
//  UIBarButtonItemImpl.h
//  Queries
//
//  Created by yangzexin on 10/24/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface UIBarButtonItemImpl : UIBarButtonItem

+ (NSString *)createBarButtonItemWithScriptId:(NSString *)scriptId
                                           si:(id<ScriptInteraction>)si
                                        title:(NSString *)title
                                 callbackFunc:(NSString *)callbackFunc;

@end
