//
//  TimeCostTracer.h
//  GewaraSport
//
//  Created by yangzexin on 13-2-25.
//  Copyright (c) 2013年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeCostTracer : NSObject

+ (void)markWithIdentifier:(id)identifier;
+ (NSTimeInterval)timeCostWithIdentifier:(id)identifier;
+ (NSTimeInterval)timeCostWithIdentifier:(id)identifier print:(BOOL)print;

@end
