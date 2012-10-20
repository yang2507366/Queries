//
//  MemoryTracer.h
//  Queries
//
//  Created by yangzexin on 10/19/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryTracer : NSObject

+ (void)mark;
+ (void)start;
+ (void)stop;

@end
