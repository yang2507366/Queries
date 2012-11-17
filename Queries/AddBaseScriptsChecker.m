//
//  AddBaseScriptsChecker.m
//  Queries
//
//  Created by yangzexin on 11/17/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "AddBaseScriptsChecker.h"
#import "LuaAppManager.h"
#import "LuaCommonUtils.h"

@interface AddBaseScriptsChecker ()

@property(nonatomic, copy)NSString *requireStrings;

@end

@implementation AddBaseScriptsChecker

- (void)dealloc
{
    self.requireStrings = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    NSMutableString *allRequireStrings = [NSMutableString string];
    NSBundle *baseScriptsBundle = [LuaAppManager baseScriptsBundle];
    NSArray *allScriptFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[baseScriptsBundle bundlePath] error:nil];
    for(NSString *scriptFile in allScriptFiles){
        [allRequireStrings appendFormat:@"require \"%@\"\n", scriptFile];
    }
    self.requireStrings = allRequireStrings;
    return self;
}

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    if([LuaCommonUtils scriptIsMainScript:script]){
        script = [NSString stringWithFormat:@"%@\n%@", self.requireStrings, script];
    }
    return script;
}

@end
