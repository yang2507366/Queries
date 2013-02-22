//
//  CodeUtils.h
//  HexTest
//
//  Created by gewara on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeUtils : NSObject

+ (NSString *)encodeWithData:(NSData *)data;
+ (NSString *)encodeWithString:(NSString *)string;
+ (NSData *)dataDecodedWithString:(NSString *)string;
+ (NSString *)stringDecodedWithString:(NSString *)string;

+ (NSString *)encodeUnicode:(NSString *)string;
+ (NSString *)decodeUnicode:(NSString *)string;
+ (NSString *)removeAllUnicode:(NSString *)string;

+ (NSData *)md5DataForData:(NSData *)data;
+ (NSString *)md5ForData:(NSData *)data;
+ (NSString *)md5ForString:(NSString *)string;

@end
