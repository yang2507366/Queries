//
//  LuaRelatedObjectManager.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaObjectManager : NSObject

+ (NSString *)addObject:(id)object;
+ (id)objectForId:(NSString *)objectId;

@end
