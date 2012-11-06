//
//  LuaCommonUtils.h
//  Queries
//
//  Created by yangzexin on 12-11-5.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaCommonUtils : NSObject

+ (BOOL)charIndexInCommentBlockWithScript:(NSString *)script index:(NSInteger)index;
+ (BOOL)scriptIsMainScript:(NSString *)script;
+ (BOOL)isObjCObject:(NSString *)objId;
+ (NSString *)uniqueString;

@end
