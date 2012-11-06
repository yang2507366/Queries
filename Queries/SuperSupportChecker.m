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
    NSString *superStr = lua_super;
    NSInteger beginIndex = [script find:superStr];
    NSInteger lastSeparator = 0;
    NSMutableString *resultScript = [NSMutableString string];
    while(beginIndex != -1){
        NSInteger endIndex = [script find:@";" fromIndex:beginIndex];
        if(endIndex != -1){
            BOOL commented = [LuaCommonUtils charIndexInCommentBlockWithScript:script index:beginIndex];
//            NSLog(@"find%@super:%@", commented ? @" commented " : @" ", [script substringWithBeginIndex:beginIndex endIndex:endIndex + 1]);
            if(!commented){
                NSString *superStatement = [script substringWithBeginIndex:beginIndex endIndex:endIndex];
                NSInteger funcIndex = [self findLeftFunctionEdgeIndexWithScript:script index:endIndex];
                if(funcIndex != -1){
                    [resultScript appendString:[script substringWithBeginIndex:lastSeparator endIndex:funcIndex]];
                    lastSeparator = funcIndex;
                    NSString *funcName = [self findFunctionNameWithScript:script atIndex:funcIndex];
                    if([self isValidSuperableFuncName:funcName]){
                        NSString *varName = [self getVarNameWithSuperableFuncName:funcName];
                        NSString *function = [self getFunctionNameWithSuperableFuncName:funcName];
                        NSString *tmpSuperVar = [NSString stringWithFormat:@"_%@_%@_%@",varName, function, [LuaCommonUtils uniqueString]];
                        [resultScript appendFormat:@"local \n%@ = %@.%@;\n", tmpSuperVar, varName, function];
                        [resultScript appendString:[script substringWithBeginIndex:funcIndex endIndex:beginIndex]];
                        NSString *params = [self getFuncInnerParams:superStatement];
                        params = [params stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if(params.length != 0){
                            params = [NSString stringWithFormat:@"%@, %@", varName, params];
                        }else{
                            params = [NSString stringWithFormat:@"%@", varName];
                        }
                        [resultScript appendFormat:@"%@(%@)", tmpSuperVar, params];
                        lastSeparator = endIndex;
                    }
                }else{
                    NSLog(@"error super cannot find function at left edge");
                }
            }
            beginIndex = [script find:superStr fromIndex:endIndex + 1];
        }else{
            NSLog(@"error, begin widht 'super ' but not found ';' ");
            break;
        }
    }
    [resultScript appendString:[script substringWithBeginIndex:lastSeparator endIndex:script.length]];
//    NSLog(@"%@", resultScript);
    return resultScript;
}

@end
