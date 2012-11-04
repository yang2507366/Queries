//
//  ApplicationScriptBundle.m
//  Queries
//
//  Created by yangzexin on 11/2/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ApplicationScriptBundle.h"
#import "LuaConstants.h"

@interface ApplicationScriptBundle ()

@end

@implementation ApplicationScriptBundle

- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    return self;
}

- (NSString *)bundleId
{
    return @"main_bundle";
}

- (NSString *)scriptWithScriptName:(NSString *)scriptName
{
    if(![scriptName hasSuffix:@".lua"]){
        scriptName = [NSString stringWithFormat:@"%@.lua", scriptName];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:scriptName ofType:nil];
    
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)mainScript
{
    return [self scriptWithScriptName:lua_main_file];
}

- (NSData *)resourceWithName:(NSString *)resName
{
    return nil;
}

@end
