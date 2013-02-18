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
#import "UnicodeChecker.h"
#import "IdentitySupportChecker.h"
#import "PrefixGrammarChecker.h"
#import "AutoreleasePoolChecker.h"
#import "CodeUtils.h"
#import "RequireReplaceChecker.h"
#import "SuperSupportChecker.h"
#import "AddBaseScriptsChecker.h"
#import "LuaObjectManager.h"
#import "RequireAutoreleasePoolChecker.h"
#import "TabCharReplaceChecker.h"

@interface LuaAppManager ()

@property(nonatomic, retain)NSArray *scriptCheckers;

@property(nonatomic, retain)LuaApp *rootApp;
@property(nonatomic, retain)NSMutableDictionary *appDict;

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
                           [[UnicodeChecker new] autorelease],
//                           [[AddBaseScriptsChecker new] autorelease],
                           [[RequireAutoreleasePoolChecker new] autorelease],
                           [[RequireReplaceChecker new] autorelease],
                           [[PrefixGrammarChecker new] autorelease],
                           [[IdentitySupportChecker new] autorelease],
                           [[SuperSupportChecker new] autorelease],
#ifndef __IPHONE_6_0
                           [[TabCharReplaceChecker new] autorelease],
#endif
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
    if(originalScript.length == 0){
        originalScript = [self.class baseScriptWithScriptName:scriptName];
    }
    NSString *script = [self compileScript:originalScript scriptName:scriptName bundleId:[targetApp.scriptBundle bundleId]];

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
        paramsId = [LuaObjectManager addObject:params group:appId];
    }
    [self.appDict setObject:app forKey:[app.scriptBundle bundleId]];
    NSString *mainScript = [self compileScript:[app.scriptBundle mainScript]
                                    scriptName:lua_main_function
                                      bundleId:appId];
    NSString *returnValue = nil;
    if(mainScript.length != 0){
        id<ScriptInteraction> si = [[[LuaScriptInteraction alloc] initWithScript:mainScript] autorelease];
        app.scriptInteraction = si;
        returnValue = [si callFunction:lua_main_function errorBlock:^(NSString *error) {
            [app consoleOutput:[NSString stringWithFormat:@"%@", error]];
        } parameters:paramsId != nil ? paramsId : nil, nil];
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
//    LuaApp *app = [self.appDict objectForKey:appId];
//    if(app == self.rootApp){
//        NSLog(@"root app cannot be destoryed");
//    }else{
//        [self.appDict removeObjectForKey:appId];
//    }
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

+ (NSBundle *)baseScriptsBundle
{
    static NSBundle *baseScriptsBundle = nil;
    if(baseScriptsBundle == nil){
        baseScriptsBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"BaseScripts" ofType:@".bundle"]];
    }
    return baseScriptsBundle;
}

+ (NSString *)generateUnitScriptWithFolderPath:(NSString *)folderPath
{
    NSArray *subFileNameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSMutableString *requireString = [NSMutableString string];
    for(NSString *subFileName in subFileNameList){
        if([subFileName hasSuffix:@".lua"]){
            [requireString appendFormat:@"require \"%@\"\n", subFileName];
        }
    }
    NSString *tmpPath = [NSString stringWithFormat:@"%@/Library/tmpUnitScripts/", NSHomeDirectory()];
    if(![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *tmpScriptPath = [tmpPath stringByAppendingPathComponent:[folderPath lastPathComponent]];
    [requireString writeToFile:tmpScriptPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    return tmpScriptPath;
}

+ (NSString *)baseScriptWithScriptName:(NSString *)scriptName
{
    static NSDictionary *baseScriptFileDictionary = nil;
    if(baseScriptFileDictionary == nil){
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"BaseScripts.bundle" ofType:nil]];
        NSString *bundleRootPath = [bundle bundlePath];
        NSMutableArray *folderList = [NSMutableArray arrayWithObject:bundleRootPath];
        while(folderList.count != 0){
            NSString *lastFolder = [[[folderList lastObject] retain] autorelease];
            [folderList removeLastObject];
            
            NSArray *subFileNameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:lastFolder error:nil];
            for(NSString *subFileName in subFileNameList){
                NSString *subFilePath = [lastFolder stringByAppendingPathComponent:subFileName];
                BOOL isDir = NO;
                [[NSFileManager defaultManager] fileExistsAtPath:subFilePath isDirectory:&isDir];
                if(isDir){
                    [folderList addObject:subFilePath];
                    if([lastFolder isEqualToString:bundleRootPath]){
                        [tmpDict setObject:[self generateUnitScriptWithFolderPath:subFilePath]
                                    forKey:[NSString stringWithFormat:@"%@.lua", subFileName]];
                    }
                }else{
                    [tmpDict setObject:subFilePath forKey:[subFilePath lastPathComponent]];
                }
            }
        }
        baseScriptFileDictionary = [tmpDict retain];
    }
    
    return [NSString stringWithContentsOfFile:[baseScriptFileDictionary objectForKey:scriptName] encoding:NSUTF8StringEncoding error:nil];
}

@end
