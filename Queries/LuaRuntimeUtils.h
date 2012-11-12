//
//  MethodInvoker.h
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-24.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaRuntimeUtils : NSObject

+ (NSString *)invokeWithObject:(id)object methodName:(NSString *)methodName parameters:(NSString *)firstParameter, ...;
+ (NSString *)invokeWithGroup:(NSString *)group objectId:(NSString *)objectId methodName:(NSString *)methodName parameters:(NSArray *)parameters;
+ (NSString *)createObjectWithGroup:(NSString *)group
                          className:(NSString *)className
                     initMethodName:(NSString *)initMethodName
                         parameters:(NSArray *)parameters;
+ (NSString *)invokeClassMethodWithGroup:(NSString *)group
                               className:(NSString *)className
                              methodName:(NSString *)methodName
                              parameters:(NSArray *)parameters;

@end
