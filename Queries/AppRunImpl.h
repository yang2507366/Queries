//
//  AppRunImpl.h
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppRunImpl : NSObject

+ (void)runWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId relatedViewControllerId:(NSString *)rvcId;
+ (void)destoryAppWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId;

@end
