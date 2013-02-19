//
//  ZipHandlerFactory.h
//  Queries
//
//  Created by yangzexin on 13-2-19.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZipHandler;

@interface ZipHandlerFactory : NSObject

+ (id<ZipHandler>)defaultZipHandler;

@end
