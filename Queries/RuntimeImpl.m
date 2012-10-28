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

+ (void)recycleObjectWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId
{
    [LuaGroupedObjectManager removeObjectWithId:objectId group:scriptId];
}

+ (void)invokeObjectMethodWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId methodName:(NSString *)methodName
{
    id obj = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    if(!obj){
        D_Log(@"invokeObjectMethodWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, methodName);
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
    id obj = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    if(!obj){
        D_Log(@"invokeObjectMethodWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, methodName);
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
    id obj = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    if(!obj){
        D_Log(@"invokeObjectMethodGetValueWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, methodName);
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

+ (NSString *)invokeObjectMethodGetObjectIdWithScriptId:(NSString *)scriptId
                                               objectId:(NSString *)objectId
                                             methodName:(NSString *)methodName
{
    id obj = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    if(!obj){
        D_Log(@"invokeObjectMethodGetObjectIdWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, methodName);
        return @"";
    }
    id returnValue = nil;
    SEL targetSelector = NSSelectorFromString(methodName);
    if([obj respondsToSelector:targetSelector]){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[obj methodSignatureForSelector:targetSelector]];
        invocation.target = obj;
        invocation.selector = targetSelector;
        [invocation invoke];
        [invocation getReturnValue:&returnValue];
        if(returnValue){
            return [LuaGroupedObjectManager addObject:returnValue group:scriptId];
        }
    }
    return @"";
}

+ (void)invokeObjectMethodSetObjectIdWithScriptId:(NSString *)scriptId
                                         objectId:(NSString *)objectId
                                       methodName:(NSString *)methodName
                                    valueObjectId:(NSString *)valueObjectId
{
    id targetObj = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    id valueTargetObj = [LuaGroupedObjectManager objectWithId:valueObjectId group:scriptId];
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", methodName]);
    if([targetObj respondsToSelector:selector]){
        [targetObj performSelector:selector withObject:valueTargetObj];
    }
}

+ (objc_property_t)getObjc_property_tWithObject:(id<NSObject>)object propertyName:(NSString *)propertyName
{
    return class_getProperty(object.class, [propertyName UTF8String]);
}

+ (NSString *)invokeObjectPropertyGetWithScriptId:(NSString *)scriptId
                                         objectId:(NSString *)objectId
                                     propertyName:(NSString *)propertyName
{
    id obj = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    if(!obj){
        D_Log(@"invokeObjectPropertyGetWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, propertyName);
    }
    
    objc_property_t property = [self getObjc_property_tWithObject:obj propertyName:propertyName];
    if(property){
        RTProperty *tmpProperty = [[[RTProperty alloc] initWithProperty:property] autorelease];
        return [tmpProperty getStringFromTargetObject:obj];
    }else{
        D_Log(@"property:%@ not found", propertyName);
    }
    
    return @"";
}

+ (void)invokeObjectPropertySetWithScriptId:(NSString *)scriptId
                                   objectId:(NSString *)objectId
                               propertyName:(NSString *)propertyName
                                      value:(NSString *)value
{
    id obj = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    if(!obj){
        D_Log(@"invokeObjectPropertySetWithScriptId:%@, objectId:%@, methodName:%@ error, target object is null", scriptId, objectId, propertyName);
    }
    objc_property_t property = [self getObjc_property_tWithObject:obj propertyName:propertyName];
    if(property){
        RTProperty *tmpProperty = [[[RTProperty alloc] initWithProperty:property] autorelease];
        [tmpProperty setWithString:value targetObject:obj];
        
    }else{
        D_Log(@"property:%@ not found", propertyName);
    }
}

+ (NSString *)createObjectWithScriptId:(NSString *)scriptId objectClassName:(NSString *)className
{
    Class targetClass = NSClassFromString(className);
    if(targetClass){
        id object = [[[targetClass alloc] init] autorelease];
        return [LuaGroupedObjectManager addObject:object group:scriptId];
    }
    return nil;
}

+ (NSString *)propertyIdOfObjectWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId propertyName:(NSString *)propertyName
{
    id targetObject = [LuaGroupedObjectManager objectWithId:objectId group:scriptId];
    
    if(targetObject){
        SEL propertySelector = NSSelectorFromString(propertyName);
        if([targetObject respondsToSelector:propertySelector]){
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[targetObject methodSignatureForSelector:propertySelector]];
            invocation.target = targetObject;
            invocation.selector = propertySelector;
            [invocation invoke];
            id property = nil;
            [invocation getReturnValue:&property];
            if(property){
                NSString *propertyObjectId = [LuaGroupedObjectManager containsObject:property group:scriptId];
                if(propertyObjectId.length != 0){
                    return propertyObjectId;
                }else{
                    D_Log(@"add property object:%d", (NSInteger)property);
                    return [LuaGroupedObjectManager addObject:property group:scriptId];
                }
            }
        }
    }
    return nil;
}

@end
