//
//  MethodInvoker.h
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-24.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MethodInvoker <NSObject>


@end

@interface MethodInvoker : NSObject

+ (NSString *)invokeWithObject:(id)object methodName:(NSString *)methodName parameters:(NSString *)firstParameter, ...;

@end
