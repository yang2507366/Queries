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
#import "LuaAppManager.h"
#import "NSString+Substring.h"
#import "LuaConstants.h"

@interface LuaReturnValue : NSObject

@property(nonatomic, copy)NSString *errorString;
@property(nonatomic, copy)NSString *returnValue;

@end

@implementation LuaReturnValue

- (void)dealloc
{
    self.errorString = nil;
    self.returnValue = nil;
    [super dealloc];
}

+ (LuaReturnValue *)createWithReturnValue:(NSString *)returnValue
{
    LuaReturnValue *tmp = [[LuaReturnValue new] autorelease];
    tmp.returnValue = returnValue;
    
    return tmp;
}

+ (LuaReturnValue *)createWithError:(NSString *)errorString
{
    LuaReturnValue *tmp = [[LuaReturnValue new] autorelease];
    tmp.errorString = errorString;
    
    return tmp;
}

@end

@interface LuaScriptInteraction () {
    char *script_string;
    lua_State *lua_state;
}

@end

@implementation LuaScriptInteraction

- (void)dealloc
{
    self.script = nil;
    if(script_string){
        free(script_string);
    }
    if(lua_state){
        lua_close(lua_state);
    }
    self.scriptInvokeFilter = nil;
#ifdef D_Log
    D_Log(@"%@", self);
#endif
    [super dealloc];
}

int get_module(lua_State *L)
{
    const char *cModName = luaL_checkstring(L, 1);
    if(strlen(cModName) != 0){
        NSString *requireString = [NSString stringWithFormat:@"%s", cModName];
        if(![requireString hasSuffix:@".lua"]){
            requireString = [NSString stringWithFormat:@"%@.lua", requireString];
        }
        NSString *modName = requireString;
        NSString *appId = @"";
        NSInteger beginIndex = [requireString find:lua_require_separator];
        NSString *targetScript = nil;
        if(beginIndex != -1){
            appId = [requireString substringToIndex:beginIndex];
            modName = [requireString substringFromIndex:beginIndex + 1];
            targetScript = [LuaAppManager scriptWithScriptName:modName appId:appId];
        }
        if(targetScript.length != 0){
            const char *cscript = [targetScript UTF8String];
            luaL_loadbuffer(L, cscript, [targetScript length], cModName);
        }
    }
    return 1;
}

- (id)initWithScript:(NSString *)script
{
    self = [super init];
    
    self.script = script;
    lua_state = lua_open();
    luaL_openlibs(lua_state);
    
    lua_register(lua_state, "get_module", get_module);
    luaL_dostring(lua_state, "table.insert(package.loaders, get_module)");
    
    if(script_string){
        luaL_dostring(lua_state, script_string);
    }
    self.scriptInvokeFilter = [[UnicodeScriptInvokeFilter new] autorelease];
    
    return self;
}

void attachCFunctions(lua_State *L)
{
    initFuntions(L);
}

- (void)callFunction:(NSString *)funcName callback:(void(^)(NSString *returnValue, NSString *error))callback parameters:(NSString *)firstParameter,...
{
    va_list args;
    NSMutableArray *parameters = [NSMutableArray array];
    if(firstParameter){
        va_start(args, firstParameter);
        for(NSString *tmpParameter = firstParameter; tmpParameter; tmpParameter = va_arg(args, id)){
            [parameters addObject:tmpParameter];
        }
        va_end(args);
    }
    LuaReturnValue *returnValue = [self callWithFunctionName:funcName parameters:parameters autoreleasePool:YES];
    if(callback){
        callback(returnValue.returnValue, returnValue.errorString);
    }
}

- (NSString *)callFunction:(NSString *)funcName parameters:(NSString *)firstParameter, ...
{
    va_list args;
    NSMutableArray *parameters = [NSMutableArray array];
    if(firstParameter){
        va_start(args, firstParameter);
        for(NSString *tmpParameter = firstParameter; tmpParameter; tmpParameter = va_arg(args, id)){
            [parameters addObject:tmpParameter];
        }
        va_end(args);
    }
    LuaReturnValue *returnValue = [self callWithFunctionName:funcName parameters:parameters autoreleasePool:YES];
    return returnValue.returnValue;
}

- (LuaReturnValue *)callWithFunctionName:(NSString *)funcName parameters:(NSArray *)parameters autoreleasePool:(BOOL)autoreleasePool
{
    if(!script_string){
        return [LuaReturnValue createWithError:@""];
    }
    int errorHandler = 0;
#ifdef DEBUG
    lua_getglobal(lua_state, "debug");
    lua_getfield(lua_state, -1, "traceback");
    lua_remove(lua_state, -2);
    errorHandler = lua_gettop(lua_state);
#endif
    
    if(autoreleasePool){
        lua_getglobal(lua_state, lua_ap_new);
        lua_pcall(lua_state, 0, 0, 0);
    }
    
    lua_getglobal(lua_state, [funcName UTF8String]);
    
    attachCFunctions(lua_state);
    
    NSInteger parameterCount = [parameters count];
    
    for(NSString *tmpParameter in parameters){
        if(self.scriptInvokeFilter){
            tmpParameter = [self.scriptInvokeFilter filterParameter:tmpParameter];
        }
        lua_pushstring(lua_state, [tmpParameter UTF8String]);
    }
    
    int result = lua_pcall(lua_state, parameterCount, 1, errorHandler);
    NSString *errorMsg = @"unknown error";
    if(result == 0){
        const char *returnValue = lua_tostring(lua_state, -1);
        NSString *returnString = @"";
        if(returnValue){
            returnString = [NSString stringWithUTF8String:returnValue];
        }
        if(self.scriptInvokeFilter){
            returnString = [self.scriptInvokeFilter filterReturnValue:returnString];
        }
        if(autoreleasePool){
            lua_getglobal(lua_state, lua_ap_release);
            lua_pcall(lua_state, 0, 0, 0);
        }
#ifdef DEBUG
        lua_pop(lua_state, 1);
#endif
        return [LuaReturnValue createWithReturnValue:returnString];
    }else{
        if(autoreleasePool){
            lua_getglobal(lua_state, lua_ap_release);
            lua_pcall(lua_state, 0, 0, 0);
        }
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
#ifdef DEBUG
        errorMsg = [NSString stringWithFormat:@"%@\n%s", errorMsg, lua_tostring(lua_state, -1)];
        NSLog(@"%@, error:%@", funcName, errorMsg);
#else
        errorMsg = [NSString stringWithFormat:@"%@\n", errorMsg];
#endif
    }
#ifdef DEBUG
    lua_pop(lua_state, 1);
#endif
    NSLog(@"%@", errorMsg);
    return [LuaReturnValue createWithError:errorMsg];
}

- (void)setScript:(NSString *)pScript
{
    if(_script != pScript){
        [_script release];
        _script = [pScript copy];
    }
    if(script_string){
        free(script_string);
    }
    if(_script){
        script_string = malloc(_script.length * sizeof(char));
        strcpy(script_string, [_script UTF8String]);
    }else{
        script_string = NULL;
    }
}

@end
