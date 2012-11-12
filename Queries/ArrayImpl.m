//
//  ArrayImpl.m
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "ArrayImpl.h"
#import "LuaObjectManager.h"

@implementation ArrayImpl

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    [super dealloc];
}

+ (NSString *)createArrayWithScriptId:(NSString *)scriptId
{
    NSMutableArray *array = [ArrayImpl array];
    
    return [LuaObjectManager addObject:array group:scriptId];
}

@end
