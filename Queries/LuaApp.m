//
//  LuaApp.m
//  Queries
//
//  Created by yangzexin on 11/2/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaApp.h"
#import "LuaScriptInteraction.h"

@interface LuaApp ()

@end


@implementation LuaApp

- (void)dealloc
{
    self.scriptInteraction = nil;
    [_scriptBundle release];
    [_baseWindow release];
    self.relatedViewController = nil;
    self.consoleOutputBlock = nil;
    
    [super dealloc];
}

- (id)initWithScriptBundle:(id<ScriptBundle>)scriptBundle baseWindow:(UIWindow *)window
{
    self = [super init];
    
    _scriptBundle = [scriptBundle retain];
    _baseWindow = [window retain];
    
    return self;
}

- (void)consoleOutput:(NSString *)output
{
    if(self.consoleOutputBlock){
        self.consoleOutputBlock(output);
    }
}

@end
