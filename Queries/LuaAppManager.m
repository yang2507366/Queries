//
//  LuaScriptManager.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaAppRunner.h"
#import "LuaScriptInteraction.h"
#import "LuaInvoker.h"
#import "LuaConstants.h"
#import "UnicodeChecker.h"
#import "SelfSupportChecker.h"
#import "PrefixGrammarChecker.h"
#import "AutoreleasePoolChecker.h"
#import "CodeUtils.h"
#import "RequireReplaceChecker.h"
#import "SuperSupportChecker.h"

@interface LuaAppRunner ()

@property(nonatomic, retain)NSArray *scriptCheckers;

@property(nonatomic, retain)LuaApp *rootApp;
@property(nonatomic, retain)NSMutableDictionary *appDict;

@end

@implementation LuaAppRunner

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
    self.scriptCheckers = nil;
    
    self.rootApp = nil;
    self.appDict = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.appDict = [NSMutableDictionary dictionary];
    self.scriptCheckers = [NSArray arrayWithObjects:
                           [[[UnicodeChecker alloc] init] autorelease],
//                           [[AutoreleasePoolChecker new] autorelease],
                           [[RequireReplaceChecker new] autorelease],
                           [[[PrefixGrammarChecker alloc] init] autorelease],
                           [[[SelfSupportChecker alloc] init] autorelease],
//                           [[[SuperSupportChecker alloc] init] autorelease],
                           nil];
    
    return self;
}

- (NSString *)compileScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    for(NSInteger i = 0; i < self.scriptCheckers.count; ++i){
        id<LuaScriptChecker> checker = [self.scriptCheckers objectAtIndex:i];
        if(script){
            script = [checker checkScript:script scriptName:scriptName bundleId:bundleId];
        }else{
            return nil;
        }
    }
    return script;
}

- (NSString *)scriptWithScriptName:(NSString *)scriptName appId:(NSString *)appId
{
    LuaApp *targetApp = [self.appDict objectForKey:appId];
    NSString *originalScript = [targetApp.scriptBundle scriptWithScriptName:scriptName];
    NSString *script = [self compileScript:originalScript scriptName:scriptName bundleId:[targetApp.scriptBundle bundleId]];
    return script;
}

- (void)runRootApp:(LuaApp *)app
{
    self.rootApp = app;
    [self runApp:app];
}

- (void)runApp:(LuaApp *)app
{
    [self.appDict setObject:app forKey:[app.scriptBundle bundleId]];
    NSString *mainScript = [self compileScript:[app.scriptBundle mainScript]
                                    scriptName:lua_main_function
                                      bundleId:[app.scriptBundle bundleId]];
    if(mainScript.length != 0){
        id<ScriptInteraction> si = [[[LuaScriptInteraction alloc] initWithScript:mainScript] autorelease];
        app.scriptInteraction = si;
        [si callFunction:lua_main_function callback:^(NSString *returnValue, NSString *error) {
            if(error.length != 0){
                NSLog(@"%@", error);
                NSLog(@"%@", mainScript);
            }
        } parameters:nil];
    }else{
        NSLog(@"run app:%@ failed, main script cannot be found", [app.scriptBundle bundleId]);
    }
}

- (void)destoryAppWithAppId:(NSString *)appId
{
    LuaApp *app = [self.appDict objectForKey:appId];
    if(app == self.rootApp){
        NSLog(@"root app cannot be destoryed");
    }else{
        [self.appDict removeObjectForKey:appId];
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
    NSString *script = [[self sharedApplication] scriptWithScriptName:scriptName appId:appId];
    
    return script;
}

+ (void)runRootApp:(LuaApp *)app
{
    [[self sharedApplication] runRootApp:app];
}

+ (void)runApp:(LuaApp *)app
{
    [[self sharedApplication] runApp:app];
}

+ (void)destoryAppWithAppId:(NSString *)appId
{
    [[self sharedApplication] destoryAppWithAppId:appId];
}

@end
