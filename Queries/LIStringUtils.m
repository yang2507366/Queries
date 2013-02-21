//
//  LIStringUtils.m
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "LIStringUtils.h"
#import "CommonUtils.h"
#import "NSString+Substring.h"

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

+ (NSString *)UTF8StringFromData:(NSData *)data
{
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSData *)dataFromUTF8String:(NSString *)str
{
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSInteger)find:(NSString *)str matching:(NSString *)matching fromIndex:(NSInteger)fromIndex reverse:(BOOL)reverse
{
    return [str find:matching fromIndex:fromIndex reverse:reverse];
}

+ (NSString *)substring:(NSString *)str beginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex
{
    return [str substringWithBeginIndex:beginIndex endIndex:endIndex];
}

+ (NSString *)replace:(NSString *)str matching:(NSString *)matching replacement:(NSString *)replacement compareOptions:(NSInteger)compareOptions beginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex
{
    return [str stringByReplacingOccurrencesOfString:matching withString:replacement options:compareOptions range:NSMakeRange(beginIndex, endIndex - beginIndex)];
}

@end
