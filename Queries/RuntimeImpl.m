//
//  RuntimeImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "RuntimeImpl.h"
#import "LuaGroupedObjectManager.h"

@implementation RuntimeImpl

+ (void)recycleObjectWithScriptId:(NSString *)scriptId
{
    [LuaGroupedObjectManager removeGroup:scriptId];
}

+ (NSString *)invokeObjectMethodWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId methodName:(NSString *)methodName
{
    NSString *obj = [LuaGroupedObjectManager getObjectWithId:objectId group:scriptId];
    if([obj respondsToSelector:NSSelectorFromString(methodName)]){
    }
}

@end
