//
//  HTTPRequest.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPGetRequest.h"
#import "HTTPPostRequest.h"

@interface HTTPRequest : NSObject <HTTPGetRequest, HTTPPostRequest>

+ (id)requestWithURLString:(NSString *)URLString identifier:(NSString *)identifier completion:(void (^)(NSString *, NSError *))completion;
+ (void)cancelRequestWithIdentifier:(NSString *)identifier;

@end
