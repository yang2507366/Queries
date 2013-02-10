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

@end
