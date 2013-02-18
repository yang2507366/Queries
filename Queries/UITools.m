//
//  UITools.m
//  imyvoa
//
//  Created by yzx on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITools.h"

@implementation UITools

+ (UIImage *)createPureColorImageWithColor:(UIColor *)color size:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, 
                                                 width, 
                                                 height, 
                                                 8, 
                                                 4 * width, 
                                                 colorSpace, 
                                                 kCGImageAlphaPremultipliedFirst);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return img;
}

+ (UIImage *)createPureColorImageWithColor:(UIColor *)color size:(CGSize)size text:(NSString *)text font:(UIFont *)font
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, 
                                                 size.width, 
                                                 size.height, 
                                                 8, 
                                                 4 * size.width, 
                                                 colorSpace, 
                                                 kCGImageAlphaPremultipliedLast);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    float textWidth = [text sizeWithFont:font].width;
    float textHeight = font.pointSize;
    float textX = (size.width - textWidth) / 2;
    float textY = (size.height - textHeight) / 2;
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSelectFont(context, "Helvetica", font.pointSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    CGContextShowTextAtPoint(context, textX, textY + 2, [text UTF8String], text.length);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return img;
}

static void AddRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)

{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM (context, CGRectGetMinX(rect),
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    
    CGContextRestoreGState(context);
}

+ (UIImage *)createPureColorRoundImageWithColor:(UIColor *)color size:(CGSize)size roundSize:(CGFloat)roundSize
{
    CGFloat paintRoundSize = roundSize;
    if([UIScreen mainScreen].scale > 1){
        size = CGSizeMake(size.width * 2, size.height * 2);
        paintRoundSize *= 2;
    }
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    AddRoundedRectToPath(context, CGRectMake(0, 0, size.width, size.height), paintRoundSize, paintRoundSize);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    resultImage = [UIImage imageWithCGImage:resultImage.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    resultImage = [resultImage stretchableImageWithLeftCapWidth:roundSize topCapHeight:0];
    UIGraphicsEndImageContext();
    return resultImage;
}

     
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString ] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIImage *)clipImage:(UIImage *)img clipRect:(CGRect)clipRect
{
    CGFloat imgWidth = clipRect.size.width * img.scale;
    CGFloat imgHeight = clipRect.size.height * img.scale;
    if(imgWidth == 0 || imgHeight == 0){
        return nil;
    }
    
    CGRect tmpRect = clipRect;
    tmpRect.origin.y = img.size.height - (tmpRect.origin.y + tmpRect.size.height);
    clipRect = tmpRect;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imgWidth,
                                                 imgHeight,
                                                 8,
                                                 4 * imgWidth,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    CGContextBeginPath(context);
    CGContextAddRect(context, CGRectMake(0, 0, clipRect.size.width * img.scale, clipRect.size.height * img.scale));
    CGContextClip(context);
    
    CGContextDrawImage(context,
                       CGRectMake(-clipRect.origin.x * img.scale,
                                  -clipRect.origin.y * img.scale,
                                  img.size.width * img.scale,
                                  img.size.height * img.scale),
                       img.CGImage);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *resultImg = [UIImage imageWithCGImage:imgRef scale:img.scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    
    return resultImg;
}

+ (UIImage *)scaleWalaImage:(UIImage *)image
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGFloat newWidth, newHeight;
    
    if(width < 800 && height < 800)
    {
        newWidth = width;
        newHeight = height;
    }
    else
    {
        if (width >= height)
        {
            newWidth = 800;
            newHeight = 800 * height / width;
        }
        else {
            newHeight = 800;
            newWidth = 800 * width / height;
        }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)generateWalaImageParameterWithImage:(UIImage *)image
{
    if(image){
        image = [self scaleWalaImage:image];
        NSString *imageHex = [UIImageJPEGRepresentation(image, 0.70f) description];
        imageHex = [imageHex substringWithRange:NSMakeRange(1, [imageHex length] - 2)];
        imageHex = [imageHex stringByReplacingOccurrencesOfString:@" " withString:@""];
        return imageHex;
    }
    return nil;
}

@end
