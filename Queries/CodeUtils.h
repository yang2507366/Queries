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

+ (NSString *)encodeAllChinese:(NSString *)string;
+ (NSString *)decodeAllChinese:(NSString *)string;

@end
