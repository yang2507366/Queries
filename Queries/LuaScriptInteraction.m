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

@interface LuaFuncReturnValue : NSObject

+ (id)createWithReturnValue:(NSString *)returnValue error:(NSString *)error;
@property(nonatomic, copy)NSString *returnValue;
@property(nonatomic, copy)NSString *error;

@end

@implementation LuaFuncReturnValue

- (void)dealloc
{
    self.returnValue = nil;
    self.error = nil;
    [super dealloc];
}

+ (id)createWithReturnValue:(NSString *)returnValue error:(NSString *)error
{
    LuaFuncReturnValue *tmp = [[LuaFuncReturnValue new] autorelease];
    tmp.returnValue = returnValue;
    tmp.error = error;
    
    return tmp;
}

@end

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

char *lua_typeof(int index)
{
    switch (index)
    {
        case LUA_TNIL:            return "nil";
        case LUA_TNUMBER:         return "number";
        case LUA_TBOOLEAN:        return "boolean";
        case LUA_TSTRING:         return "string";
        case LUA_TTABLE:          return "table";
        case LUA_TFUNCTION:       return "function";
        case LUA_TUSERDATA:       return "userdata";
        case LUA_TTHREAD:         return "thread";
        case LUA_TLIGHTUSERDATA:  return "light userdata";
            
        default: return "unknown type";
    }
}

int HAPI_echo(lua_State* L)
{
    int args_from_lua = lua_gettop(L);
    
    //in this example, we'll take any number of args
    printf("HAPI_echo() called with %d arguments\n",
           args_from_lua);
    for (int n = 1; n <= args_from_lua; ++n)
    {
        printf(" * arg %02d (%s):\t%s\n",
               n,
               lua_typeof(lua_type(L, n)),
               lua_tostring(L, n));
        //note: lua_tostring coerces stack value!
    }
    
    //return (123, "abc") to lua
    lua_pushnumber(L, 123);
    lua_pushstring(L, "abc");
    return 2; // 2 return values are on the stack
    
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
    
    lua_getglobal(_L, "debug");
    lua_getfield(_L, -1, "traceback");
    lua_remove(_L, -2);
    int errorHandler = lua_gettop(_L);
    
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
    
    int result = lua_pcall(_L, parameterCount, 1, errorHandler);
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
        lua_pop(_L, 1);
        return;
    }else{
        if(result == LUA_YIELD){
            errorMsg = @"lua yield";
        }else if(result == LUA_ERRRUN){
            errorMsg = @"Runtime error";
        }else if(result == LUA_ERRSYNTAX){
            errorMsg = @"Syntax error";
        }else if(result == LUA_ERRMEM){
            errorMsg = @"lua errmem";
        }else if(result == LUA_ERRERR){
            errorMsg = @"lua errerr";
        }
        errorMsg = [NSString stringWithFormat:@"%@\n%s", errorMsg, lua_tostring(_L, -1)];
        NSLog(@"callFunction:%@, error:%@", funcName, errorMsg);
    }
    if(callback){
        callback(nil, errorMsg);
    }
    lua_pop(_L, 1);
}

- (NSString *)callFunction:(NSString *)funcName parameters:(NSString *)firstParameter, ...
{
    if(!_scriptChars){
        return @"";
    }
    
    lua_getglobal(_L, "debug");
    lua_getfield(_L, -1, "traceback");
    lua_remove(_L, -2);
    int errorHandler = lua_gettop(_L);
    
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
    
    int result = lua_pcall(_L, parameterCount, 1, errorHandler);
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
        lua_pop(_L, 1);
        return returnString;
    }else{
        if(result == LUA_YIELD){
            errorMsg = @"lua yield";
        }else if(result == LUA_ERRRUN){
            errorMsg = @"Runtime error";
        }else if(result == LUA_ERRSYNTAX){
            errorMsg = @"Syntax error";
        }else if(result == LUA_ERRMEM){
            errorMsg = @"lua errmem";
        }else if(result == LUA_ERRERR){
            errorMsg = @"lua errerr";
        }
        errorMsg = [NSString stringWithFormat:@"%@\n%s", errorMsg, lua_tostring(_L, -1)];
        NSLog(@"callFunction:%@, error:%@", funcName, errorMsg);
    }
    lua_pop(_L, 1);
    return @"";
}

- (LuaFuncReturnValue *)callWithFunctionName:(NSString *)funcName parameters:(NSString *)firstParameter, ...
{
    if(!_scriptChars){
        return nil;
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
        return [LuaFuncReturnValue createWithReturnValue:returnString error:nil];
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
    return nil;
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
