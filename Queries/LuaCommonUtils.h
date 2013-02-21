//
//  LuaCommonUtils.h
//  Queries
//
//  Created by yangzexin on 12-11-5.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaCommonUtils : NSObject

+ (BOOL)charIndexInCommentBlockWithScript:(NSString *)script index:(NSInteger)index;
+ (BOOL)scriptIsMainScript:(NSString *)script;
+ (BOOL)isObjCObject:(NSString *)objId;
+ (NSString *)uniqueString;

+ (CGRect)CGRectWithString:(NSString *)str;
+ (CGSize)CGSizeWithString:(NSString *)str;
+ (CGPoint)CGPointWithString:(NSString *)str;
+ (NSRange)NSRangeWithString:(NSString *)str;
+ (UIEdgeInsets)UIEdgeInsetsWithString:(NSString *)str;
+ (UIOffset)UIOffsetWithString:(NSString *)str;
+ (CATransform3D)CATransform3DWithString:(NSString *)str;
+ (CGAffineTransform)CGAffineTransformWithString:(NSString *)str;
+ (BOOL)isAlphbelt:(char)c;
+ (BOOL)isAlphbelts:(NSString *)str;

@end
