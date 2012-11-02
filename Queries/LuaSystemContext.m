//
//  LuaScriptManager.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaSystemContext.h"
#import "LuaScriptInteraction.h"
#import "LuaInvoker.h"
#import "LuaConstants.h"
#import "UnicodeChecker.h"
#import "SelfSupportChecker.h"
#import "PrefixGrammarChecker.h"
#import "AutoreleasePoolChecker.h"
#import "CodeUtils.h"
#import "RequireReplaceChecker.h"

@interface LuaSystemContext ()

@property(nonatomic, retain)NSArray *scriptCheckers;

@property(nonatomic, retain)LuaApp *currentApp;
@property(nonatomic, retain)NSMutableDictionary *appDict;

@end

@implementation LuaSystemContext

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
    
    self.currentApp = nil;
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

- (void)runApp:(LuaApp *)app
{
    self.currentApp = app;
    [self.appDict setObject:app forKey:[app.scriptBundle bundleId]];
    NSString *mainScript = [self compileScript:[app.scriptBundle mainScript]
                                    scriptName:lua_main_function
                                      bundleId:[app.scriptBundle bundleId]];
    id<ScriptInteraction> si = [[[LuaScriptInteraction alloc] initWithScript:mainScript] autorelease];
    app.scriptInteraction = si;
    [si callFunction:lua_main_function callback:^(NSString *returnValue, NSString *error) {
        if(error.length != 0){
            NSLog(@"%@", error);
            NSLog(@"%@", mainScript);
        }
    } parameters:nil];
}

- (UIWindow *)currentWindow
{
    return [self.currentApp baseWindow];
}

+ (id<ScriptInteraction>)scriptInteractionWithAppId:(NSString *)appId
{
    return [[[self appDictionary] objectForKey:appId] scriptInteraction];
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

+ (void)runApp:(LuaApp *)app
{
    [[self sharedApplication] runApp:app];
}

@end
