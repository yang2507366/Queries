//
//  LuaScriptCompiler.m
//  Queries
//
//  Created by yangzexin on 2/24/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "LuaScriptCompiler.h"
#import "UnicodeChecker.h"
#import "RequireAutoreleasePoolChecker.h"
#import "RequireReplaceChecker.h"
#import "IdentitySupportChecker.h"
#import "ClassDefineReplaceChecker.h"
#import "SuperSupportChecker.h"
#import "PrefixGrammarChecker.h"
#import "TabCharReplaceChecker.h"

@interface LuaScriptCompiler ()

@property(nonatomic, retain)NSArray *scriptCheckers;

@end

@implementation LuaScriptCompiler

+ (id)defaultScriptCompiler
{
    return [[self.class new] autorelease];
}

- (id)init
{
    self = [super init];
    
    
    self.scriptCheckers = [NSArray arrayWithObjects:
                           [[UnicodeChecker new] autorelease],
                           [[RequireAutoreleasePoolChecker new] autorelease],
                           [[RequireReplaceChecker new] autorelease],
                           [[PrefixGrammarChecker new] autorelease],
                           [[IdentitySupportChecker new] autorelease],
                           [[ClassDefineReplaceChecker new] autorelease],
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

@end
