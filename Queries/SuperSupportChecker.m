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
    return script;
}

@end
