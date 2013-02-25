//
//  LuaScriptManager.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaAppManager.h"
#import "LuaScriptInteraction.h"
#import "LuaConstants.h"
#import "CodeUtils.h"
#import "LuaObjectManager.h"
#import "ScriptCompiler.h"
#import "LuaScriptCompiler.h"
#import "BaseScriptManager.h"
#import "BaseScriptManagerFactory.h"

@interface LuaAppManager ()

@property(nonatomic, retain)LuaApp *rootApp;
@property(nonatomic, retain)NSMutableDictionary *appDict;
@property(nonatomic, retain)id<ScriptCompiler> scriptCompiler;
@property(nonatomic, retain)id<BaseScriptManager> baseScriptManager;

@end

@implementation LuaAppManager

+ (id)sharedApplication
{
    static typeof(self) instance = nil;
    @synchronized(self.class){
        if(instance == nil){
            instance = [[self.class alloc] init];
        }
    }
    return instance;
}

- (void)dealloc
{
    self.rootApp = nil;
    self.appDict = nil;
    self.scriptCompiler = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.appDict = [NSMutableDictionary dictionary];
    self.scriptCompiler = [LuaScriptCompiler defaultScriptCompiler];
    self.baseScriptManager = [BaseScriptManagerFactory defaultBaseScriptManagerWithBaseScriptsBundlePath:
                              [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"BaseScripts.bundle" ofType:nil]] bundlePath]];
    
    return self;
}

- (NSString *)compileScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    return [self.scriptCompiler compileScript:script scriptName:scriptName bundleId:bundleId];
}

- (NSString *)scriptWithScriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    LuaApp *targetApp = [self.appDict objectForKey:bundleId];
    NSString *script = [targetApp.scriptBundle scriptWithScriptName:scriptName];
    if(script.length == 0){
        script = [self.baseScriptManager compiledScriptWithScriptName:scriptName bundleId:bundleId];
    }else{
        if(![targetApp.scriptBundle isCompiled]){
            script = [self compileScript:script scriptName:scriptName bundleId:[targetApp.scriptBundle bundleId]];
        }
    }
    return script;
}

- (id)runRootApp:(LuaApp *)app params:(id)params;
{
    self.rootApp = app;
    return [self runApp:app params:params];
}

- (id)runApp:(LuaApp *)app params:(id)params
{
    NSString *paramsId = nil;
    NSString *appId = [app.scriptBundle bundleId];
    if(params){
        if([params isKindOfClass:[NSString class]]){
            paramsId = params;
        }else{
            paramsId = [LuaObjectManager addObject:params group:appId];
        }
    }
    [self.appDict setObject:app forKey:[app.scriptBundle bundleId]];
    NSString *mainScript = nil;
    if([app.scriptBundle isCompiled]){
        mainScript = [app.scriptBundle mainScript];
    }else{
        mainScript = [self compileScript:[app.scriptBundle mainScript]
                              scriptName:lua_main_function
                                bundleId:appId];
    }
    NSString *returnValue = nil;
    if(mainScript.length != 0){
        LuaScriptInteraction *luaScriptInteraction = [[[LuaScriptInteraction alloc] initWithScript:mainScript] autorelease];
        [luaScriptInteraction setErrorMsgThrowBlock:^(NSString *errorMsg) {
            [app consoleOutput:[NSString stringWithFormat:@"%@", errorMsg]];
        }];
        app.scriptInteraction = luaScriptInteraction;
        returnValue = [luaScriptInteraction callFunction:lua_main_function parameters:paramsId != nil ? paramsId : nil, nil];
    }else{
        NSLog(@"run app:%@ failed, main script cannot be found", appId);
        [app consoleOutput:[NSString stringWithFormat:@"run app:%@ failed, main script cannot be found", appId]];
    }
    if(paramsId != nil){
        [LuaObjectManager releaseObjectWithId:paramsId group:appId];
    }
    return returnValue;
}

- (void)destoryAppWithAppId:(NSString *)appId
{
    [self.appDict removeObjectForKey:appId];
    [LuaObjectManager removeGroup:appId];
}

- (void)destoryAllApps
{
    NSArray *allAppIds = [self.appDict allKeys];
    for(NSString *appId in allAppIds){
        [self destoryAppWithAppId:appId];
    }
}

- (LuaApp *)appForId:(NSString *)appId
{
    return [self.appDict objectForKey:appId];
}

- (UIWindow *)currentWindow
{
    return [self.rootApp baseWindow];
}

- (id<ScriptInteraction>)scriptInteractionWithAppId:(NSString *)appId
{
    return [[self.appDict objectForKey:appId] scriptInteraction];
}

+ (id<ScriptInteraction>)scriptInteractionWithAppId:(NSString *)appId
{
    return [[self sharedApplication] scriptInteractionWithAppId:appId];
}

+ (LuaApp *)appForId:(NSString *)appId
{
    return [[self sharedApplication] appForId:appId];
}

+ (NSMutableDictionary *)appDictionary
{
    return [[self sharedApplication] appDict];
}

+ (UIWindow *)currentWindow
{
    return [[self sharedApplication] currentWindow];
}

+ (NSString *)scriptWithScriptName:(NSString *)scriptName appId:(NSString *)appId
{
    NSString *script = [[self sharedApplication] scriptWithScriptName:scriptName bundleId:appId];
    
    return script;
}

+ (id)runRootApp:(LuaApp *)app
{
    return [[self sharedApplication] runRootApp:app params:nil];
}

+ (id)runRootApp:(LuaApp *)app params:(id)params
{
    return [[self sharedApplication] runRootApp:app params:params];
}

+ (id)runApp:(LuaApp *)app
{
    return [[self sharedApplication] runApp:app params:nil];
}

+ (id)runApp:(LuaApp *)app params:(id)params
{
    return [[self sharedApplication] runApp:app params:params];
}

+ (void)destoryAppWithAppId:(NSString *)appId
{
    [[self sharedApplication] destoryAppWithAppId:appId];
}

+ (void)destoryAllApps
{
    [[self sharedApplication] destoryAllApps];
}

+ (NSBundle *)baseScriptsBundle
{
    static NSBundle *baseScriptsBundle = nil;
    if(baseScriptsBundle == nil){
        baseScriptsBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"BaseScripts" ofType:@".bundle"]];
    }
    return baseScriptsBundle;
}

@end
