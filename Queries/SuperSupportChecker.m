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

- (NSString *)findSuperClassNameWithScript:(NSString *)script adIndex:(NSInteger)index
{
    NSString *func = @"function ";
    NSInteger functionBeignIndex = [script find:func fromIndex:index reverse:YES];
    if(functionBeignIndex != -1){
        functionBeignIndex += func.length;
        NSInteger endIndex = [script find:@"(" fromIndex:functionBeignIndex];
        NSString *funcName = [script substringWithBeginIndex:functionBeignIndex endIndex:endIndex];
        NSArray *arr = [funcName componentsSeparatedByString:@":"];
        if(arr.count == 2){
            return [[arr objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        return nil;
    }
    return nil;
}

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    NSInteger lastFindIndex = 0;
    NSInteger beginIndex = 0;
    NSMutableString *resultString = [NSMutableString string];
    while((beginIndex = [script find:@"super" fromIndex:lastFindIndex]) != -1){
        const unichar rightChar = [script characterAtIndex:beginIndex + 5];
        unichar leftChar = '#';
        if(beginIndex != 0){
            leftChar = [script characterAtIndex:beginIndex - 1];
        }
        NSString *parentClassName = [self findSuperClassNameWithScript:script adIndex:beginIndex];
        if([LuaCommonUtils isAlphbelt:leftChar] || [LuaCommonUtils isAlphbelt:rightChar]){
            [resultString appendString:[script substringWithBeginIndex:lastFindIndex endIndex:beginIndex + 5]];
            lastFindIndex = beginIndex + 5;
        }else if(parentClassName.length != 0){
            // right value
            BOOL selfSyntax = rightChar == ':';
            [resultString appendString:[script substringWithBeginIndex:lastFindIndex endIndex:beginIndex]];
            [resultString appendFormat:@"getmetatable(%@)", parentClassName];
            if(selfSyntax){
                [resultString appendString:@"."];
                NSInteger endIndex = [script find:@"(" fromIndex:beginIndex];
                if(endIndex == -1){
                    // error syntax
                    return script;
                }
                NSString *invokeFuncName = [script substringWithBeginIndex:beginIndex + 6 endIndex:endIndex];
                [resultString appendString:invokeFuncName];
                NSInteger rightBracketIndex = [script find:@")" fromIndex:endIndex];
                [resultString appendString:@"(self"];
                NSString *innerParams = [self getFuncInnerParams:[script substringWithBeginIndex:beginIndex endIndex:rightBracketIndex + 1]];
                BOOL hasParams = [innerParams stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0;
                if(hasParams){
                    [resultString appendString:@", "];
                }
                lastFindIndex = endIndex + 1;
            }else{
                lastFindIndex = beginIndex + 5;
            }
        }
    }
    if(lastFindIndex != -1 && lastFindIndex < script.length){
        [resultString appendString:[script substringWithBeginIndex:lastFindIndex endIndex:script.length]];
    }
    return resultString;
}

@end
