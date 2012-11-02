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
#import "LuaSystemContext.h"
#import "NSString+Substring.h"
#import "LuaConstants.h"

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
    self.scriptInvokeFilter = nil;
    D_Log(@"%@", self);
    [super dealloc];
}

int get_module(lua_State *L)
{
    const char *cModName = luaL_checkstring(L, 1);
    if(strlen(cModName) != 0){
        NSString *requireString = [NSString stringWithFormat:@"%s.lua", cModName];
        NSString *modName = requireString;
        NSString *appId = @"";
        NSInteger beginIndex = [requireString find:lua_require_separator];
        if(beginIndex != -1){
            appId = [requireString substringToIndex:beginIndex];
            modName = [requireString substringFromIndex:beginIndex + 1];
        }
        NSString *script = [LuaSystemContext scriptWithScriptName:modName appId:appId];
        if(script.length != 0){
            const char *cscript = [script UTF8String];
            luaL_loadbuffer(L, cscript, [script length], cModName);
        }
    }
    return 1;
}

- (id)initWithScript:(NSString *)script
{
    self = [super init];
    
    self.script = script;
    _L = lua_open();
    luaL_openlibs(_L);
    
    lua_register(_L, "get_module", get_module);
    luaL_dostring(_L, "table.insert(package.loaders, get_module)");
    
    if(_scriptChars){
        luaL_dostring(_L, _scriptChars);
    }
    self.scriptInvokeFilter = [[UnicodeScriptInvokeFilter new] autorelease];
    
    return self;
}

- (void)callFunction:(NSString *)funcName callback:(void(^)(NSString *returnValue, NSString *error))callback parameters:(NSString *)firstParameter,...
{
    if(!_scriptChars){
        if(callback){
            callback(nil, [NSString stringWithFormat:@"call function:%@ error, script cannot be NULL", funcName]);
        }
        return;
    }
    
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

- (NSString *)callFunction:(NSString *)funcName parameters:(NSString *)firstParameter, ...
{
    if(!_scriptChars){
        return @"";
    }
    
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
        NSString *returnString = @"";
        if(returnValue){
            returnString = [NSString stringWithUTF8String:returnValue];
        }
        if(self.scriptInvokeFilter){
            returnString = [self.scriptInvokeFilter filterReturnValue:returnString];
        }
        return returnString;
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
    D_Log(@"callFunction:%@, error:%@", funcName, errorMsg);
    return @"";
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
    }else{
        _scriptChars = NULL;
    }
}

@end
