//
//  LuaRelatedObjectManager.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaObjectManagerLegacy : NSObject

+ (NSString *)addObject:(id)object;
+ (void)removeObjectWithObjectId:(NSString *)objectId;
+ (id)objectForId:(NSString *)objectId;

@end
