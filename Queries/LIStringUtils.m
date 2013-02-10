//
//  LIStringUtils.m
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "LIStringUtils.h"
#import "CommonUtils.h"

@implementation LIStringUtils

+ (NSString *)appendingPath:(NSString *)path component:(NSString *)component
{
    return [path stringByAppendingPathComponent:component];
}

+ (NSString *)trim:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)string:(NSString *)string hasPrefix:(NSString *)prefix
{
    return [string hasPrefix:prefix] ? @"YES" : @"NO";
}

+ (NSString *)length:(NSString *)string
{
    return [NSString stringWithFormat:@"%d", [string length]];
}

+ (NSString *)equals:(NSString *)str with:(NSString *)str2
{
    NSString *b = [str isEqualToString:str2] ? @"YES" : @"NO";
    return b;
}

+ (NSString *)objectToString:(id)obj
{
    return [NSString stringWithFormat:@"%@", obj];
}

@end
