//
//  HTTPPostRequest.h
//  Queries
//
//  Created by yangzexin on 11/5/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPPostRequest <NSObject>

- (void)postWithParameters:(NSDictionary *)params
             baseURLString:(NSString *)baseURLString
                completion:(void(^)(NSString *responseString, NSError *error))completion;
- (void)cancel;

@end
