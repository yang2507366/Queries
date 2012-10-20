//
//  LuaScriptInteraction.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScirptInteraction.h"
#import "LuaScriptInvokeFilter.h"

@interface LuaScriptInteraction : NSObject <ScriptInteraction>

@property(nonatomic, copy)NSString *script;
@property(nonatomic, retain)id<LuaScriptInvokeFilter> scriptInvokeFilter;

- (id)initWithScript:(NSString *)script;

@end
