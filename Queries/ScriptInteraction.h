//
//  ScirptInteraction.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScriptInteraction <NSObject>

- (void)callFunction:(NSString *)funcName callback:(void(^)(NSString *returnValue, NSString *error))callback parameters:(NSString *)firstParameter, ...;
- (NSString *)callFunction:(NSString *)funcName parameters:(NSString *)firstParameter, ...;
- (NSString *)callFunction:(NSString *)funcName errorBlock:(void(^)(NSString *error))errorBlock parameters:(NSString *)firstParameter, ...;

@end
