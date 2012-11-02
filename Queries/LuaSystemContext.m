//
//  LuaScriptManager.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaApplication.h"
#import "LuaScriptInteraction.h"
#import "LuaInvoker.h"
#import "LuaConstants.h"
#import "UnicodeChecker.h"
#import "SelfSupportChecker.h"
#import "ImportSupportChecker.h"
#import "PrefixGrammarChecker.h"
#import "AutoreleasePoolChecker.h"
#import "CodeUtils.h"

@interface LuaApplication ()

@property(nonatomic, retain)NSMutableDictionary *originalScriptDictionary;
@property(nonatomic, retain)NSMutableDictionary *runnableScriptDictionary;
@property(nonatomic, retain)NSMutableDictionary *runningProgramDictionary;
@property(nonatomic, retain)NSArray *scriptCheckers;

@property(nonatomic, retain)UIWindow *window;

@end

@implementation LuaApplication

+ (id)sharedManager
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
    self.originalScriptDictionary = nil;
    self.runnableScriptDictionary = nil;
    self.runningProgramDictionary = nil;
    self.scriptCheckers = nil;
    self.window = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.originalScriptDictionary = [NSMutableDictionary dictionary];
    self.runnableScriptDictionary = [NSMutableDictionary dictionary];
    self.runningProgramDictionary = [NSMutableDictionary dictionary];
    self.scriptCheckers = [NSArray arrayWithObjects:
//                           [[[ImportSupportChecker alloc] init] autorelease],
                           [[[UnicodeChecker alloc] init] autorelease],
//                           [[AutoreleasePoolChecker new] autorelease],
                           [[[PrefixGrammarChecker alloc] init] autorelease],
                           [[[SelfSupportChecker alloc] init] autorelease],
                           nil];
    
    return self;
}

- (NSString *)checkScript:(NSString *)script scriptId:(NSString *)scriptId
{
    for(NSInteger i = 0; i < self.scriptCheckers.count; ++i){
        id<LuaScriptChecker> checker = [self.scriptCheckers objectAtIndex:i];
        if(script){
            script = [checker checkScript:script scriptId:scriptId];
        }else{
            return nil;
        }
    }
    return script;
}

- (void)processAllScripts
{
    NSArray *allScriptIds = [self.originalScriptDictionary allKeys];
    for(NSString *scriptId in allScriptIds){
        [self processScriptWithScriptId:scriptId script:[self originalScriptWithScriptId:scriptId]];
    }
    
}

- (void)processScriptWithScriptId:(NSString *)scriptId script:(NSString *)script
{
    script = [self checkScript:script scriptId:scriptId];
    if(script.length == 0){
        script = @"";
    }
    [self.runnableScriptDictionary setObject:script forKey:scriptId];
}

- (NSString *)originalScriptWithScriptId:(NSString *)scriptId
{
    return [self.originalScriptDictionary objectForKey:scriptId];
}

- (NSString *)scriptWithScriptId:(NSString *)scriptId
{
    return [self.runnableScriptDictionary objectForKey:scriptId];
}

+ (void)setProgram:(id<ScriptInteraction>)si forScriptId:(NSString *)scriptId
{
    [[[self.class sharedManager] runningProgramDictionary] setObject:si forKey:scriptId];
}

+ (id<ScriptInteraction>)programWithScriptId:(NSString *)scriptId
{
    id<ScriptInteraction> program = [[[self sharedManager] runningProgramDictionary] objectForKey:scriptId];
    if(!program){
        NSString *script = [self scriptWithScriptId:scriptId];
//        D_Log(@"create script interaction for:%@\n%@", scriptId, script);
        program = [[[LuaScriptInteraction alloc] initWithScript:script] autorelease];
        [self setProgram:program forScriptId:scriptId];
    }
    return program;
}

+ (void)removeProgramWithScriptId:(NSString *)scriptId
{
    [[[self sharedManager] runningProgramDictionary] removeObjectForKey:scriptId];
}

+ (id<ScriptInteraction>)restartProgramWithScriptId:(NSString *)scritId
{
    [self removeProgramWithScriptId:scritId];
    return [self programWithScriptId:scritId];
}

+ (void)run
{
    [self.class loadLuaScripts];
    
    LuaScriptInteraction *si = [self programWithScriptId:lua_main_file];
    [si callFunction:@"main" callback:^(NSString *returnValue, NSString *error) {
        D_Log(@"lua main:%@, %@", returnValue, error);
        if(error.length != 0){
            D_Log(@"%@", [CodeUtils decodeUnicode:si.script]);
        }
    } parameters:nil];
}

+ (void)runOnWindow:(UIWindow *)window
{
    [[self.class sharedManager] setWindow:window];
    [self run];
}

+ (UIWindow *)window
{
    return [[self.class sharedManager] window];
}

+ (void)loadLuaScripts
{
    // read all scripts, and save to original script dictionary as scriptId : script
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(NSString *fileName in fileNames){
        if([[fileName lowercaseString] hasSuffix:@".lua"]){
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            if(script.length == 0){
                script = @"";
            }
            [[[self.class sharedManager] originalScriptDictionary] setObject:script forKey:fileName];
        }
    }
    // process scripts
    [[self.class sharedManager] processAllScripts];
}

+ (NSString *)originalScriptWithScriptId:(NSString *)scriptId
{
    return [[LuaApplication sharedManager] originalScriptWithScriptId:scriptId];
}

+ (NSString *)scriptWithScriptId:(NSString *)identifier
{
    return [[LuaApplication sharedManager] scriptWithScriptId:identifier];
}

+ (NSString *)requireScriptWithScriptId:(NSString *)scriptId
{
    NSString *script = [self scriptWithScriptId:scriptId];
    if(script.length != 0){
        NSRange beginRange = [script rangeOfString:@"function" options:NSBackwardsSearch];
        if(beginRange.location != NSNotFound){
            script = [script substringToIndex:beginRange.location - 1];
        }
    }
    return script;
}

@end
