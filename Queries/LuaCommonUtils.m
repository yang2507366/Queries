//
//  LuaCommonUtils.m
//  Queries
//
//  Created by yangzexin on 12-11-5.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "LuaCommonUtils.h"
#import "NSString+Substring.h"

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
                NSInteger commentBeginIndex = [script find:@"--[[" fromIndex:endIndex reverse:YES];
                if(commentBeginIndex != -1){
                    NSInteger commentEndIndex = [script find:@"]]" fromIndex:endIndex];
                    if(commentEndIndex != -1){
                        NSLog(@"main function in comments");
                        return NO;
                    }else{
                        NSLog(@"comment has no end");
                    }
                }else{
                    return YES;
                }
            }
            beginIndex = [script find:@"function" fromIndex:endIndex + 2];
        }else{
            break;
        }
    }
    return NO;
}

@end
