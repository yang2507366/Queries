//
//  GroupedObjectManager.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface LuaObjectManager : NSObject

+ (NSString *)addObject:(id)object group:(NSString *)group;
+ (void)removeGroup:(NSString *)group;
+ (void)removeObjectWithId:(NSString *)objectId group:(NSString *)group;
+ (NSString *)containsObject:(id)object group:(NSString *)group;
+ (id)objectWithId:(NSString *)objectId group:(NSString *)group;

+ (void)retainObjectWithId:(NSString *)objectId group:(NSString *)group;
+ (BOOL)releaseObjectWithId:(NSString *)objectId group:(NSString *)group;
+ (NSInteger)objectRetainCountForId:(NSString *)objectId group:(NSString *)group;

@end
