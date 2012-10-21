//
//  LuaRelatedObjectManager.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaObjectManager.h"

@implementation LuaObjectManager

+ (NSMutableDictionary *)objectPool
{
    static NSMutableDictionary *instance = nil;
    
    @synchronized(self.class){
        if(instance == nil){
            instance = [[NSMutableDictionary dictionary] retain];
        }
    }
    
    return instance;
}

+ (NSString *)addObject:(id)object
{
    NSString *controlId = [NSString stringWithFormat:@"%d", (NSInteger)object];
    [[self objectPool] setObject:object forKey:controlId];
    
    return controlId;
}

+ (id)objectForId:(NSString *)objectId
{
    return [[self objectPool] objectForKey:objectId];
}

@end
