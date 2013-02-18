//
//  SuperSupportChecker.m
//  Queries
//
//  Created by yangzexin on 12-11-6.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "SuperSupportChecker.h"
#import "LuaConstants.h"
#import "NSString+Substring.h"
#import "LuaCommonUtils.h"

@implementation SuperSupportChecker

- (NSInteger)findLeftFunctionEdgeIndexWithScript:(NSString *)script index:(NSInteger)index
{
    NSString *func = @"function ";
    NSInteger beginIndex = [script find:func fromIndex:index reverse:YES];
    
    return beginIndex;
}

- (NSString *)findFunctionNameWithScript:(NSString *)script atIndex:(NSInteger)index
{
    NSString *func = @"function ";
    NSInteger beginIndex = [script find:func fromIndex:index];
    if(beginIndex != -1){
        NSInteger endIndex = [script find:@"(" fromIndex:index];
        if(endIndex != -1){
            NSString *funcName = [script substringWithBeginIndex:beginIndex + func.length endIndex:endIndex];
            return [funcName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
    }
    return nil;
}

- (BOOL)isValidSuperableFuncName:(NSString *)funcName
{
    return [funcName find:@":"] != -1;
}

- (NSString *)getVarNameWithSuperableFuncName:(NSString *)funcName
{
    NSArray *arr = [funcName componentsSeparatedByString:@":"];
    if(arr.count == 2){
        NSString *varName = [arr objectAtIndex:0];
        varName = [varName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return varName;
    }
    return nil;
}

- (NSString *)getFunctionNameWithSuperableFuncName:(NSString *)funcName
{
    NSArray *arr = [funcName componentsSeparatedByString:@":"];
    if(arr.count == 2){
        NSString *function = [arr objectAtIndex:1];
        function = [function stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return function;
    }
    return nil;
}

- (NSString *)getFuncInnerParams:(NSString *)func
{
    NSInteger beginIndex = [func find:@"("];
    NSInteger endIndex = [func find:@")"];
    if(beginIndex != -1 && endIndex != -1){
        return [func substringWithBeginIndex:beginIndex + 1 endIndex:endIndex];
    }
    return @"";
}

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    NSInteger lastFindIndex = 0;
    NSInteger beginIndex = 0;
    NSMutableString *resultString = [NSMutableString string];
    while((beginIndex = [script find:@"super:" fromIndex:lastFindIndex]) != -1){
        [resultString appendString:[script substringWithBeginIndex:lastFindIndex endIndex:beginIndex]];
        [resultString appendString:@"getmetatable(getmetatable(self))."];
        NSInteger endIndex = [script find:@"(" fromIndex:beginIndex];
        if(endIndex == -1){
            // error syntax
            return script;
        }
        NSString *funcName = [script substringWithBeginIndex:beginIndex + 6 endIndex:endIndex];
        [resultString appendString:funcName];
        [resultString appendString:@"(self"];
//        NSLog(@"%@", [script substringWithRange:NSMakeRange(beginIndex, endIndex - beginIndex)]);
        NSInteger rightBracketIndex = [script find:@")" fromIndex:endIndex];
        NSString *innerParams = [self getFuncInnerParams:[script substringWithBeginIndex:beginIndex endIndex:rightBracketIndex + 1]];
        BOOL hasParams = [innerParams stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0;
        if(hasParams){
            [resultString appendString:@", "];
        }
        lastFindIndex = endIndex + 1;
    }
    if(lastFindIndex != -1 && lastFindIndex < script.length){
        [resultString appendString:[script substringWithBeginIndex:lastFindIndex endIndex:script.length]];
    }
    return resultString;
}

@end
