//
//  LuaScriptInteraction.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaScriptInteraction.h"
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "UnicodeScriptInvokeFilter.h"
#import "LuaFunctions.h"
#import "LuaScriptManager.h"

@interface LuaScriptInteraction () {
    char *_scriptChars;
    lua_State *_L;
}

@end

@implementation LuaScriptInteraction

- (void)dealloc
{
    self.script = nil;
    if(_scriptChars){
        free(_scriptChars);
    }
    if(_L){
        lua_close(_L);
    }
    
    [super dealloc];
}

- (id)initWithScript:(NSString *)script
{
    self = [super init];
    
    self.script = script;
    _L = lua_open();
    luaL_openlibs(_L);
//    self.scriptInvokeFilter = [[UnicodeScriptInvokeFilter new] autorelease];
    
    return self;
}

- (void)callFunction:(NSString *)funcName callback:(void(^)(NSString *returnValue, NSString *error))callback parameters:(NSString *)firstParameter,...
{
    if(!_scriptChars){
        if(callback){
            callback(nil, @"error script cannot be NULL");
        }
        return;
    }
    
    luaL_dostring(_L, _scriptChars);
    lua_getglobal(_L, [funcName UTF8String]);
    
    initFuntions(_L);
    
    NSInteger parameterCount = 0;
    va_list args;
    
    if(firstParameter){
        va_start(args, firstParameter);
        for(NSString *tmpParameter = firstParameter; tmpParameter; tmpParameter = va_arg(args, id), ++parameterCount){
            if(self.scriptInvokeFilter){
                tmpParameter = [self.scriptInvokeFilter filterParameter:tmpParameter];
            }
            lua_pushstring(_L, [tmpParameter UTF8String]);
        }
        va_end(args);
    }
    
    int result = lua_pcall(_L, parameterCount, 1, 0);
    NSString *errorMsg = @"unknown error";
    if(result == 0){
        const char *returnValue = lua_tostring(_L, -1);
        if(callback){
            NSString *returnString = @"";
            if(returnValue){
                returnString = [NSString stringWithUTF8String:returnValue];
            }
            if(self.scriptInvokeFilter){
                returnString = [self.scriptInvokeFilter filterReturnValue:returnString];
            }
            callback(returnString, nil);
        }
        return;
    }else if(result == LUA_YIELD){
        errorMsg = @"lua yield";
    }else if(result == LUA_ERRRUN){
        errorMsg = @"lua errrun";
    }else if(result == LUA_ERRSYNTAX){
        errorMsg = @"lua errsyntax";
    }else if(result == LUA_ERRMEM){
        errorMsg = @"lua errmem";
    }else if(result == LUA_ERRERR){
        errorMsg = @"lua errerr";
    }
    if(callback){
        callback(nil, errorMsg);
    }
}

- (void)setScript:(NSString *)pScript
{
    if(_script != pScript){
        [_script release];
        _script = [pScript copy];
    }
    if(_scriptChars){
        free(_scriptChars);
    }
    if(_script){
        _scriptChars = malloc(_script.length * sizeof(char));
        strcpy(_scriptChars, [_script UTF8String]);
        [[LuaScriptManager sharedManager] addScript:_script];
    }else{
        _scriptChars = NULL;
    }
}

@end
