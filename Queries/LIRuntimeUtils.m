//
//  LIRuntimeUrils.m
//  Queries
//
//  Created by yangzexin on 2/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "LIRuntimeUtils.h"
#import <objc/runtime.h>
#import "LuaObjectManager.h"

@implementation LIRuntimeUtils

static char *askey = "";

+ (void)setAssociatedObjectFor:(id)object key:(NSString *)key value:(id)value policy:(NSInteger)policy override:(BOOL)override
{
    if(objc_getAssociatedObject(object, askey) != nil && !override){
        return;
    }
    objc_setAssociatedObject(object, askey, value, policy);
}

+ (NSString *)getAssociatedObjectWithAppId:(NSString *)appId forObject:(id)object key:(NSString *)key
{
    id value = objc_getAssociatedObject(object, askey);
    return [LuaObjectManager addObject:value group:appId];
}

+ (void)removeAssociatedObjectsForObject:(id)object
{
    objc_removeAssociatedObjects(object);
}

@end
