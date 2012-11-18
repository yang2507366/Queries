//
//  OnlineAppBundle.h
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderPool.h"

@interface OnlineAppBundleLoader : NSObject <ProviderPoolable>

- (id)initWithURLString:(NSString *)urlString;
- (void)loadWithCompletion:(void(^)(NSString *downloadedZipPath))completion;
- (void)cancel;

@end
