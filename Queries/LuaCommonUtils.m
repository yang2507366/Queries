//
//  LuaCommonUtils.m
//  Queries
//
//  Created by yangzexin on 12-11-5.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "LuaCommonUtils.h"
#import "NSString+Substring.h"
#import "LuaConstants.h"

@implementation LuaCommonUtils

+ (BOOL)charIndexInCommentBlockWithScript:(NSString *)script index:(NSInteger)index
{
    BOOL noComment = YES;
    NSInteger commentBeginIndex = [script find:@"--[[" fromIndex:index reverse:YES];
    if(commentBeginIndex != -1){
        // find --[[ comment
        NSInteger commentEndIndex = [script find:@"]]" fromIndex:index];
        if(commentEndIndex != -1){
            // finded
            noComment = NO;
        }
    }
    if(noComment){
        // find -- comment
        NSInteger newLineIndex = [script find:@"\n" fromIndex:index reverse:YES];
        if(newLineIndex == -1){
            newLineIndex = 0;
        }else{
            ++newLineIndex;
        }
        NSString *innerStr = [script substringWithBeginIndex:newLineIndex endIndex:index];
        if([innerStr find:@"--"] != -1){
            // finded
            noComment = NO;
        }
    }
    return !noComment;
}

+ (BOOL)scriptIsMainScript:(NSString *)script
{
    NSInteger beginIndex = [script find:@"function"];
    NSInteger endIndex = 0;
    while(beginIndex != -1){
        endIndex = [script find:@"(" fromIndex:beginIndex];
        if(endIndex != -1){
            NSString *funcName = [script substringWithBeginIndex:beginIndex + 8 endIndex:endIndex];
            funcName = [funcName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(funcName.length == 4 && [funcName isEqualToString:@"main"]){
                return ![self charIndexInCommentBlockWithScript:script index:endIndex];
            }
            beginIndex = [script find:@"function" fromIndex:endIndex + 2];
        }else{
            break;
        }
    }
    return NO;
}

+ (BOOL)isObjCObject:(NSString *)objId
{
    return [objId hasPrefix:lua_obj_prefix];
}

+ (NSString *)uniqueString
{
    return [[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]]
            stringByReplacingOccurrencesOfString:@"." withString:@""];
}

+ (CGRect)CGRectWithString:(NSString *)str
{
    NSArray *vl = [str componentsSeparatedByString:@","];
    CGRect tmpRect;
    if(vl.count == 4){
        tmpRect.origin.x = [[vl[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        tmpRect.origin.y = [[vl[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        tmpRect.size.width = [[vl[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        tmpRect.size.height = [[vl[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    }
    return tmpRect;
}

+ (CGSize)CGSizeWithString:(NSString *)str
{
    NSArray *vl = [str componentsSeparatedByString:@","];
    CGSize tmpSize;
    if(vl.count == 2){
        tmpSize.width = [[vl[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        tmpSize.height = [[vl[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    }
    return tmpSize;
}

+ (CGPoint)CGPointWithString:(NSString *)str
{
    NSArray *vl = [str componentsSeparatedByString:@","];
    CGPoint tmpPoint;
    if(vl.count == 2){
        tmpPoint.x = [[vl[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        tmpPoint.y = [[vl[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    }
    return tmpPoint;
}

+ (NSRange)NSRangeWithString:(NSString *)str
{
    NSArray *vl = [str componentsSeparatedByString:@","];
    NSRange tmpRange;
    if(vl.count == 2){
        tmpRange.location = [[vl[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
        tmpRange.length = [[vl[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue];
    }
    return tmpRange;
}

+ (UIEdgeInsets)UIEdgeInsetsWithString:(NSString *)str
{
    NSArray *vl = [str componentsSeparatedByString:@","];
    UIEdgeInsets insets;
    if(vl.count == 4){
        insets.top = [[vl[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        insets.left = [[vl[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        insets.bottom = [[vl[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        insets.right = [[vl[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    }
    return insets;
}

+ (UIOffset)UIOffsetWithString:(NSString *)str
{
    NSArray *vl = [str componentsSeparatedByString:@","];
    UIOffset offset;
    if(vl.count == 2){
        offset.horizontal = [[vl[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        offset.vertical = [[vl[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    }
    return offset;
}

+ (CATransform3D)CATransform3DWithString:(NSString *)str
{
    NSArray *vl = [str componentsSeparatedByString:@","];
    CATransform3D t3d;
    if(vl.count == 16){
        t3d.m11 = [[vl[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m12 = [[vl[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m13 = [[vl[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m14 = [[vl[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m21 = [[vl[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m22 = [[vl[5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m23 = [[vl[6] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m24 = [[vl[7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m31 = [[vl[8] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m32 = [[vl[9] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m33 = [[vl[10] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m34 = [[vl[11] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m41 = [[vl[12] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m42 = [[vl[13] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m43 = [[vl[14] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t3d.m44 = [[vl[15] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    }
    return t3d;
}

+ (CGAffineTransform)CGAffineTransformWithString:(NSString *)str
{
    NSArray *vl = [str componentsSeparatedByString:@","];
    CGAffineTransform t;
    if(vl.count == 6){
        t.a = [[vl[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t.b = [[vl[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t.c = [[vl[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t.d = [[vl[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t.tx = [[vl[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
        t.ty = [[vl[5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    }
    return t;
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

@end
