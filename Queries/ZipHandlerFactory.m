//
//  ZipHandlerFactory.m
//  Queries
//
//  Created by yangzexin on 13-2-19.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "ZipHandlerFactory.h"
#import "ZKZipHandlerAdapter.h"

@implementation ZipHandlerFactory

+ (id<ZipHandler>)defaultZipHandler
{
    return [[ZKZipHandlerAdapter new] autorelease];
}

@end
