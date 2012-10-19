//
//  Utils.m
//  VOA
//
//  Created by yangzexin on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+ (NSString *)formatTimeNumber:(NSInteger)n
{
    if (n < 10) {
        return [NSString stringWithFormat:@"0%d", n];
    }
    return [NSString stringWithFormat:@"%d", n];
}

+ (BOOL)singleCharIsChinese:(NSString *)str
{
    int firstChar = [str characterAtIndex:0];
    if(firstChar >= 0x4e00 && firstChar <= 0x9FA5){
        return YES;
    }
    return NO;
}

+ (BOOL)stringContainsChinese:(NSString *)str
{
    BOOL contains = NO;
    for(NSInteger i = 0; i < [str length]; ++i){
        NSString *sub = [str substringWithRange:NSMakeRange(i, 1)];
        if([CommonUtils singleCharIsChinese:sub]){
            contains = YES;
            break;
        }
    }
    return contains;
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)randomString
{
    NSDate *date = [[[NSDate alloc] init] autorelease];
    NSString *randomString = [NSString stringWithFormat:@"%f", [date timeIntervalSinceReferenceDate]];
    
    return [randomString stringByReplacingOccurrencesOfString:@"." withString:@""];
}

+ (NSString *)tmpPath
{
    NSString *homeDirectory = NSHomeDirectory();
    
    return [NSString stringWithFormat:@"%@/tmp/", homeDirectory];
}

+ (NSString *)libraryPath
{
    NSString *homeDirectory = NSHomeDirectory();
    
    return [NSString stringWithFormat:@"%@/Library/", homeDirectory];    
}

+ (NSString *)formatNumber:(NSUInteger)number
{
    if(number < 10){
        return [NSString stringWithFormat:@"0%d", number];
    }
    return [NSString stringWithFormat:@"%d", number];
}

+ (NSArray *)fileNameListInDocumentPath
{
    NSString *documentPath = [self documentPath];
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
}

+ (NSString *)timeStringWithDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate] 
    - [[dateFormatter dateFromString:dateString] timeIntervalSinceReferenceDate];
    NSString *timeString = nil;
    if(interval < 60){
        // 1分钟之内，秒
        timeString = @"刚刚";
    }else if(interval >= 60 && interval < 3600){
        // 1分钟－1小时，分
        NSInteger minute = interval / 60;
        timeString = [NSString stringWithFormat:@"%d分钟前", minute];
    }else if(interval >= 3600 && interval < 86400){
        // 1小时－1天，时
        NSInteger hour = interval / 3600;
        timeString = [NSString stringWithFormat:@"%d小时前", hour];
    }else if(interval >= 86400 && interval < 2592000){
        // 1天－1个月，天
        NSInteger day = interval / 86400;
        timeString = [NSString stringWithFormat:@"%d天前", day];
    }else if(interval >= 2592000 && interval < 31104000){
        // 1个月－1年，月
        NSInteger month = interval / 2592000;
        timeString = [NSString stringWithFormat:@"%d个月前", month];
    }else{
        // 大于1年，年
        NSInteger year = interval / 31104000;
        timeString = [NSString stringWithFormat:@"%d年前", year];
    }
    
    return timeString;
}

+ (BOOL)stringIsPureAlphabet:(NSString *)string
{
    const char *charArray = [string UTF8String];
    for(int i = 0; i < string.length; ++i){
        char ch = *(charArray + i);
        if(ch < 48 || (ch > 57 && ch < 65) || (ch > 90 && ch <97) || ch > 122){
            return NO;
        }
    }
    
    return YES;
}

@end
