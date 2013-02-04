//
//  HTTPDownload.h
//  Queries
//
//  Created by yangzexin on 2/4/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPDownload <NSObject>

- (void)downloadWithURLString:(NSString *)URLString
                     progress:(void(^)(long long downloadedLength, long long totalLength))progress
                   completion:(void(^)(NSString *tmpFilePath, NSError *error))completion;
- (void)cancel;

@end
