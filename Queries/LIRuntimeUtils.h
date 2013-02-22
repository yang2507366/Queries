//
//  LIRuntimeUrils.h
//  Queries
//
//  Created by yangzexin on 2/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIRuntimeUtils : NSObject

+ (void)setAssociatedObjectFor:(id)object key:(NSString *)key value:(id)value policy:(NSInteger)policy override:(BOOL)override;
+ (NSString *)getAssociatedObjectWithAppId:(NSString *)appId forObject:(id)object key:(NSString *)key;
+ (id)getAssociatedObjectForObject:(id)object key:(NSString *)key;
+ (NSString *)object:(id)object isKindOfClass:(NSString *)className;

@end
