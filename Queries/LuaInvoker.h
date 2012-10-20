//
//  LuaInvoker.h
//  imyvoa
//
//  Created by gewara on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

@interface LuaInvoker : NSObject {
    lua_State *L;
    
    char *_script;
}

@property(nonatomic, copy)NSString *script;

- (id)initWithScript:(NSString *)script;

/**
 调用不需要参数的lua方法，返回一个字符串
 */
- (NSString *)invokeProperty:(NSString *)methodName;
/**
 调用lua方法，方法需要一个入参，返回一个字符串
 */
- (NSString *)invokeMethodWithName:(NSString *)methodName paramValue:(NSString *)paramValue;

@end
