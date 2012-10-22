//
//  ArrayImpl.m
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "ArrayImpl.h"
#import "LuaGroupedObjectManager.h"

@implementation ArrayImpl

+ (NSString *)createArrayWithScriptId:(NSString *)scriptId
{
    NSMutableArray *array = [NSMutableArray array];
    
    return [LuaGroupedObjectManager addObject:array group:scriptId];
}

@end
