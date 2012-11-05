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
                BOOL noComment = YES;
                NSInteger commentBeginIndex = [script find:@"--[[" fromIndex:endIndex reverse:YES];
                if(commentBeginIndex != -1){
                    // find --[[ comment
                    NSInteger commentEndIndex = [script find:@"]]" fromIndex:endIndex];
                    if(commentEndIndex != -1){
                        // finded
                        NSLog(@"main function in comments --[[");
                        noComment = NO;
                    }
                }
                if(noComment){
                    // find -- comment
                    NSInteger newLineIndex = [script find:@"\n" fromIndex:endIndex reverse:YES];
                    if(newLineIndex == -1){
                        newLineIndex = 0;
                    }else{
                        ++newLineIndex;
                    }
                    NSString *innerStr = [script substringWithBeginIndex:newLineIndex endIndex:endIndex];
                    if([innerStr find:@"--"] != -1){
                        // finded
                        NSLog(@"main function in comments --");
                        noComment = NO;
                    }
                }
                return noComment;
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

@end
