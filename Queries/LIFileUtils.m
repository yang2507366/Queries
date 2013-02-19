//
//  FiltUtils.m
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "LIFileUtils.h"

@implementation LIFileUtils

+ (NSString *)readStringFromFile:(NSString *)path
{
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
