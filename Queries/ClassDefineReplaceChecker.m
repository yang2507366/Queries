//
//  ClassDefineReplaceChecker.m
//  Queries
//
//  Created by yangzexin on 13-2-22.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "ClassDefineReplaceChecker.h"
#import "NSString+Substring.h"

@implementation ClassDefineReplaceChecker

- (BOOL)paramValid:(NSString *)param className:(NSString **)className baseClassName:(NSString **)baseClassName
{
    BOOL valid = NO;
    NSArray *arr = [param componentsSeparatedByString:@","];
    if(arr.count == 2){
        valid = YES;
        *className = [[arr objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        *baseClassName = [[arr objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }else if(arr.count == 1){
        NSString *tmpClassName = [arr objectAtIndex:0];
        tmpClassName = [tmpClassName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(tmpClassName.length != 0){
            valid = YES;
            *className = tmpClassName;
            *baseClassName = @"Object";
        }
    }
    return valid;
}

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    NSString *classDefinition =@"$class = {};$class.__index = $class;setmetatable($class, $baseClass)";
    NSInteger lastEndIndex = 0;
    NSInteger beginIndex = 0;
    NSInteger endIndex = 0;
    NSMutableString *resultString = [NSMutableString string];
    while((beginIndex = [script find:@"class" fromIndex:endIndex]) != -1){
        NSInteger leftBracketLocation = [script find:@"(" fromIndex:beginIndex + 5];
        endIndex = [script find:@")" fromIndex:beginIndex + 5];
        if(leftBracketLocation != -1 && endIndex != -1){
            NSString *leftInnerText = [script substringWithBeginIndex:beginIndex + 5 endIndex:leftBracketLocation];
            leftInnerText = [leftInnerText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *paramText = [script substringWithBeginIndex:leftBracketLocation + 1 endIndex:endIndex];
            NSString *className = nil;
            NSString *baseClassName = nil;
            if(leftInnerText.length == 0 && [self paramValid:paramText className:&className baseClassName:&baseClassName]){
                [resultString appendString:[script substringWithBeginIndex:lastEndIndex endIndex:beginIndex]];
                NSString *tmpClassDefinition = [classDefinition stringByReplacingOccurrencesOfString:@"$class" withString:className];
                tmpClassDefinition = [tmpClassDefinition stringByReplacingOccurrencesOfString:@"$baseClass" withString:baseClassName];
                [resultString appendString:tmpClassDefinition];
                lastEndIndex = endIndex + 1;
            }else{
                break;
            }
        }else{
            break;
        }
    }
    [resultString appendString:[script substringWithBeginIndex:lastEndIndex endIndex:script.length]];
    return resultString;
}

@end
