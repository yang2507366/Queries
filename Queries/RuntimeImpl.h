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
+ (NSString *)invokeObjectMethodWithScriptId:(NSString *)scriptId objectId:(NSString *)objectId methodName:(NSString *)methodName;

@end
