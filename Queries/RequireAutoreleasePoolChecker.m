//
//  RequireAutoreleasePoolChecker.m
//  Queries
//
//  Created by yangzexin on 12-12-11.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "RequireAutoreleasePoolChecker.h"
#import "LuaCommonUtils.h"

@implementation RequireAutoreleasePoolChecker

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    if([LuaCommonUtils scriptIsMainScript:script]){
        return [NSString stringWithFormat:@"require \"AutoreleasePool\"\n%@", script];
    }
    return script;
}

@end
