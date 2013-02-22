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

+ (NSString *)homePath
{
    return NSHomeDirectory();
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

+ (BOOL)isAlphbelt:(char)c
{
    return (c >= 48 && c <= 57) || (c >= 65 && c <= 90) || (c >= 97 && c <= 122) || c == '_';
}

+ (BOOL)isAlphbelts:(NSString *)str
{
    for(NSInteger i = 0; i < str.length; ++i){
        if(![self.class isAlphbelt:[str characterAtIndex:i]]){
            return NO;
        }
    }
    return YES;
}

+ (NSString *)filterNil:(NSString *)string
{
    if(string == nil){
        return @"";
    }
    return string;
}

+ (NSString *)countableTempFileName:(NSString *)fileName atDirectory:(NSString *)directory
{
    NSString *fileExtension = [fileName pathExtension];
    fileName = [fileName stringByDeletingPathExtension];
    NSString *originalFileName = fileName;
    NSString *filePath = [directory stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:fileExtension]];
    NSInteger count = 0;
    while([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        fileName = [NSString stringWithFormat:@"%@ - %d", originalFileName, ++count];
        filePath = [directory stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:fileExtension]];
    }
    return [fileName stringByAppendingPathExtension:fileExtension];
}

@end
