//
//  LuaImplentatable.h
//  Queries
//
//  Created by yangzexin on 11/12/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LuaImplentatable <NSObject>

@property(nonatomic, copy)NSString *appId;
@property(nonatomic, copy)NSString *objId;

+ (NSString *)create:(NSString *)appId;

@end
