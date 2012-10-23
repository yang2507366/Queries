//
//  RuntimeUtils.m
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "RuntimeUtils.h"
#import <objc/runtime.h>
#import "RTProperty.h"

@implementation RuntimeUtils

+ (SEL)selectorForSetterWithPropertyName:(NSString *)propertyName
{
    if(propertyName.length > 0){
        NSString *firstLetter = [propertyName substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:", firstLetter, [propertyName substringFromIndex:1]];
        return NSSelectorFromString(methodName);
    }
    return nil;
}

+ (SEL)selectorForGetterWithPropertyName:(NSString *)propertyName
{
    if(propertyName.length > 0){
        return NSSelectorFromString(propertyName);
    }
    return nil;
}

+ (void)invokePropertySetterWithTargetObject:(id<NSObject>)object propertyName:(NSString *)propertyName value:(void *)value
{
    SEL targetSelector = [self.class selectorForSetterWithPropertyName:propertyName];
    if([object respondsToSelector:targetSelector]){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object.class instanceMethodSignatureForSelector:targetSelector]];
        invocation.target = object;
        invocation.selector = targetSelector;
        [invocation setArgument:value atIndex:2];
        [invocation invoke];
    }
}

+ (NSString *)fixValueFormat:(NSString *)value
{
    NSMutableDictionary *replaceDict = [NSMutableDictionary dictionary];
    [replaceDict setObject:@"\\n" forKey:@"\n"];
    [replaceDict setObject:@"\\t" forKey:@"\t"];
    
    NSArray *allKeys = [replaceDict allKeys];
    for(NSString *key in allKeys){
        value = [value stringByReplacingOccurrencesOfString:key withString:[replaceDict objectForKey:key]];
    }
    return value;
}

+ (NSString *)descriptionOfObject:(id<NSObject>)obj
{
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@{\n", NSStringFromClass(obj.class)];
    
    unsigned int property_count = 0;
    objc_property_t *property_list = class_copyPropertyList(obj.class, &property_count);
    
    RTProperty *tmpProperty = [[[RTProperty alloc] initWithProperty:NULL] autorelease];
    
    for(NSInteger i = 0; i < property_count; ++i){
        tmpProperty.objc_property = *(property_list + i);
        NSString *value = [tmpProperty getStringFromTargetObject:obj];
        if([value rangeOfString:@"\n"].location != NSNotFound){
            [desc appendFormat:@"\t\"%@\" : [\n\t\t%@\n\t]\n", tmpProperty.name, [value stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t\t"]];
        }else{
            [desc appendFormat:@"\t\"%@\" : %@\n", tmpProperty.name, value];
        }
    }
    [desc appendString:@"}"];
    
    free(property_list);
    
    return desc;
}

+ (NSString *)descriptionOfObjectList:(NSArray *)objList
{
    NSMutableString *desc = [NSMutableString stringWithString:@"\n"];
    
    for(id<NSObject> obj in objList){
        [desc appendFormat:@"%@\n\n", [self.class descriptionOfObject:obj]];
    }
    [desc appendString:@"\n"];
    
    return desc;
}

@end
