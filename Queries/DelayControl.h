//
//  DelayControl.h
//  GewaraSport
//
//  Created by yangzexin on 12-11-28.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderPool.h"

@interface DelayControl : NSObject <ProviderPoolable>

- (id)initWithInterval:(NSTimeInterval)timeInterval completion:(void(^)())completion;
- (id)start;
- (void)cancel;

@end
