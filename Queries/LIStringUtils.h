//
//  LIStringUtils.h
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIStringUtils : NSObject

+ (NSString *)appendingPath:(NSString *)path component:(NSString *)component;
+ (NSString *)trim:(NSString *)str;
+ (NSString *)string:(NSString *)string hasPrefix:(NSString *)prefix;
+ (NSString *)length:(NSString *)string;
+ (NSString *)equals:(NSString *)str with:(NSString *)str2;
+ (NSString *)objectToString:(id)obj;
+ (NSString *)UTF8StringFromData:(NSData *)data;
+ (NSData *)dataFromUTF8String:(NSString *)str;
+ (NSInteger)find:(NSString *)str matching:(NSString *)matching fromIndex:(NSInteger)fromIndex reverse:(BOOL)reverse;
+ (NSString *)substring:(NSString *)str beginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;
+ (NSString *)replace:(NSString *)str matching:(NSString *)matching replacement:(NSString *)replacement compareOptions:(NSInteger)compareOptions beginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;

@end
