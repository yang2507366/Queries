//
//  LuaInvoker.m
//  imyvoa
//
//  Created by gewara on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LuaInvoker.h"

@implementation LuaInvoker

@dynamic script;

- (void)dealloc
{
    lua_close(L);
    free(_script);
    [super dealloc];
}

- (id)initWithScript:(NSString *)script
{
    self = [self init];
    
    _script = malloc(sizeof(char) * [script length]);
    strcpy(_script, [script UTF8String]);
    
    return self;
}

- (id)init
{
    self = [super init];
    
    L = lua_open();
    luaL_openlibs(L);
    
    return self;
}

- (NSString *)invokeProperty:(NSString *)methodName
{
    if(_script == NULL){
        return nil;
    }
    
    NSString *result = nil;
    luaL_dostring(L, _script);
    lua_getglobal(L, [methodName UTF8String]);
    if(lua_pcall(L, 0, 1, 0) == 0){// 调用lua函数，第二个参数为传入参数个数，第三个为返回参数个数
        result = [NSString stringWithUTF8String:lua_tostring(L, -1)];
    }
    return result;
}

- (NSString *)invokeMethodWithName:(NSString *)methodName paramValue:(NSString *)paramValue
{
    if(_script == NULL){
        return nil;
    }
    luaL_dostring(L, _script);
    lua_getglobal(L, [methodName UTF8String]);
    lua_pushstring(L, [paramValue UTF8String]);
    if(lua_pcall(L, 1, 1, 0) == 0){
        const char *result = lua_tostring(L, -1);
        return [NSString stringWithUTF8String:result];
    }
    return nil;
}

- (NSString *)script
{
    if(_script == NULL){
        return nil;
    }
    return [NSString stringWithUTF8String:_script];
}

- (void)setScript:(NSString *)script
{
    if(_script != NULL){
        free(_script);
    }
    if([script length] == 0){
        _script = NULL;
    }else{
        _script = malloc(sizeof(char) * [script length]);
        strcpy(_script, [script UTF8String]);
    }
}

@end
