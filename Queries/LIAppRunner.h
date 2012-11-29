//
//  AppRunImpl.h
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIAppRunner : NSObject

+ (void)runWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId params:(NSString *)params relatedViewControllerId:(NSString *)rvcId;
+ (void)destoryAppWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId;

@end
