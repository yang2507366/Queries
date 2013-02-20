//
//  LuaScriptInteraction.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"
#import "LuaScriptInvokeFilter.h"

@interface LuaScriptInteraction : NSObject <ScriptInteraction>

@property(nonatomic, copy)NSString *script;
@property(nonatomic, retain)id<LuaScriptInvokeFilter> scriptInvokeFilter;
@property(nonatomic, copy)void(^errorMsgThrowBlock)(NSString *);

- (id)initWithScript:(NSString *)script;

@end
