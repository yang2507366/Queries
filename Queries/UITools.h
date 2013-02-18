//
//  UITools.h
//  imyvoa
//
//  Created by yzx on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITools : NSObject

+ (UIImage *)createPureColorImageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)createPureColorImageWithColor:(UIColor *)color size:(CGSize)size text:(NSString *)text font:(UIFont *)font;
+ (UIImage *)createPureColorRoundImageWithColor:(UIColor *)color size:(CGSize)size roundSize:(CGFloat)roundSize;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIImage *)clipImage:(UIImage *)img clipRect:(CGRect)clipRect;
+ (NSString *)generateWalaImageParameterWithImage:(UIImage *)image;

@end
