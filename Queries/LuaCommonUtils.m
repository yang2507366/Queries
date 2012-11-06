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

@end
