//
//  RuntimeImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "RuntimeImpl.h"
#import "LuaGroupedObjectManager.h"
#import "RTProperty.h"

@implementation RuntimeImpl

+ (void)recycleObjectWithScriptId:(NSString *)scriptId
{
    [LuaGroupedObjectManager removeGroup:scriptId];
}

+ (void)invokeObjectMethodWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId methodName:(NSString *)methodName
{
    id obj = [LuaGroupedObjectManager getObjectWithId:objectId group:scriptId];
    if(!obj){
        NSLog(@"invokeObjectMethodWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, methodName);
        return;
    }
    SEL targetSelector = NSSelectorFromString(methodName);
    if([obj respondsToSelector:targetSelector]){
        [obj performSelector:targetSelector];
    }
}

+ (void)invokeObjectMethodSetStringWithScriptId:(NSString *)scriptId
                              objectId:(NSString *)objectId
                            methodName:(NSString *)methodName
                                 value:(NSString *)value
{
    id obj = [LuaGroupedObjectManager getObjectWithId:objectId group:scriptId];
    if(!obj){
        NSLog(@"invokeObjectMethodWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, methodName);
        return;
    }
    SEL targetSelector = NSSelectorFromString(methodName);
    if([obj respondsToSelector:targetSelector]){
        [obj performSelector:targetSelector withObject:value];
    }
}

+ (NSString *)invokeObjectMethodGetStringWithScriptId:(NSString *)scriptId
                                            objectId:(NSString *)objectId
                                          methodName:(NSString *)methodName
                                               value:(NSString *)value
{
    id obj = [LuaGroupedObjectManager getObjectWithId:objectId group:scriptId];
    if(!obj){
        NSLog(@"invokeObjectMethodGetValueWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, methodName);
        return @"";
    }
    id returnValue = nil;
    SEL targetSelector = NSSelectorFromString(methodName);
    if([obj respondsToSelector:targetSelector]){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[obj methodSignatureForSelector:targetSelector]];
        invocation.target = obj;
        invocation.selector = targetSelector;
        if(value){
            [invocation setArgument:&value atIndex:2];
        }
        [invocation invoke];
        [invocation getReturnValue:&returnValue];
    }
    return [NSString stringWithFormat:@"%@", returnValue];
}

+ (objc_property_t)getObjc_property_tWithObject:(id<NSObject>)object propertyName:(NSString *)propertyName
{
    return class_getProperty(object.class, [propertyName UTF8String]);
}

+ (NSString *)invokeObjectPropertyGetWithScriptId:(NSString *)scriptId
                                         objectId:(NSString *)objectId
                                     propertyName:(NSString *)propertyName
{
    id obj = [LuaGroupedObjectManager getObjectWithId:objectId group:scriptId];
    if(!obj){
        NSLog(@"invokeObjectPropertyGetWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, propertyName);
    }
    
    objc_property_t property = [self getObjc_property_tWithObject:obj propertyName:propertyName];
    if(property){
        RTProperty *tmpProperty = [[[RTProperty alloc] initWithProperty:property] autorelease];
        return [tmpProperty getStringFromTargetObject:obj];
    }else{
        NSLog(@"property:%@ not found", propertyName);
    }
    
    return @"";
}

+ (void)invokeObjectPropertySetWithScriptId:(NSString *)scriptId
                                   objectId:(NSString *)objectId
                               propertyName:(NSString *)propertyName
                                      value:(NSString *)value
{
    id obj = [LuaGroupedObjectManager getObjectWithId:objectId group:scriptId];
    if(!obj){
        NSLog(@"invokeObjectPropertySetWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, propertyName);
    }
    objc_property_t property = [self getObjc_property_tWithObject:obj propertyName:propertyName];
    if(property){
        RTProperty *tmpProperty = [[[RTProperty alloc] initWithProperty:property] autorelease];
        [tmpProperty setWithString:value targetObject:obj];
        
    }else{
        NSLog(@"property:%@ not found", propertyName);
    }
}

@end
