//
//  AbstractHTTPRequest.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderPool.h"

@protocol HTTPGetRequest <ProviderPoolable>

- (void)requestWithURLString:(NSString *)URLString completion:(void(^)(NSString *responseString, NSError *error))completion;
- (BOOL)isExecuting;
- (void)cancel;

@end
