//
//  RuntimeImpl.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeImpl : NSObject

+ (void)recycleObjectWithScriptId:(NSString *)scriptId;
+ (void)recycleObjectWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId;

+ (void)invokeObjectMethodWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId methodName:(NSString *)methodName;

+ (void)invokeObjectMethodSetStringWithScriptId:(NSString *)scriptId
                                       objectId:(NSString *)objectId
                                     methodName:(NSString *)methodName
                                          value:(NSString *)value;

+ (NSString *)invokeObjectMethodGetStringWithScriptId:(NSString *)scriptId
                                             objectId:(NSString *)objectId
                                           methodName:(NSString *)methodName
                                                value:(NSString *)value;
+ (NSString *)invokeObjectMethodGetObjectIdWithScriptId:(NSString *)scriptId
                                               objectId:(NSString *)objectId
                                             methodName:(NSString *)methodName;
+ (void)invokeObjectMethodSetObjectIdWithScriptId:(NSString *)scriptId
                                         objectId:(NSString *)objectId
                                       methodName:(NSString *)methodName
                                    valueObjectId:(NSString *)valueObjectId;

+ (NSString *)invokeObjectPropertyGetWithScriptId:(NSString *)scriptId
                                         objectId:(NSString *)objectId
                                     propertyName:(NSString *)propertyName;

+ (void)invokeObjectPropertySetWithScriptId:(NSString *)scriptId
                                   objectId:(NSString *)objectId
                               propertyName:(NSString *)propertyName
                                      value:(NSString *)value;

+ (NSString *)createObjectWithScriptId:(NSString *)scriptId objectClassName:(NSString *)className;
+ (NSString *)propertyIdOfObjectWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId propertyName:(NSString *)propertyName;

@end
