//
//  LIStringUtils.m
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "LIStringUtils.h"

@implementation LIStringUtils

+ (NSString *)appendingPath:(NSString *)path component:(NSString *)component
{
    return [path stringByAppendingPathComponent:component];
}

+ (NSString *)trim:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
