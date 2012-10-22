//
//  GroupedObjectManager.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface LuaGroupedObjectManager : NSObject

+ (NSString *)addObject:(id)object group:(NSString *)group;
+ (void)removeGroup:(NSString *)group;
+ (id)objectWithId:(NSString *)objectId group:(NSString *)group;

@end
