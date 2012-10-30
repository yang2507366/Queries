//
//  AutoreleasePoolChecker.m
//  Queries
//
//  Created by yangzexin on 12-10-30.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "AutoreleasePoolChecker.h"

@interface NSString (Substring)

- (NSString *)substringWithBeginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;
- (NSInteger)find:(NSString *)str fromInex:(NSInteger)fromInex reverse:(BOOL)reverse;
- (NSInteger)find:(NSString *)str fromInex:(NSInteger)fromInex;
- (NSInteger)find:(NSString *)str;

@end

@implementation NSString (Substring)

- (NSString *)substringWithBeginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex
{
    if(endIndex > beginIndex){
        return [self substringWithRange:NSMakeRange(endIndex, beginIndex)];
    }
    return nil;
}

- (NSInteger)find:(NSString *)str fromInex:(NSInteger)fromInex reverse:(BOOL)reverse
{
    NSRange range = [self rangeOfString:str
                                options:reverse ? NSBackwardsSearch : NSCaseInsensitiveSearch
                                  range:NSMakeRange(fromInex, self.length - fromInex)];
    return range.location == NSNotFound ? -1 : range.location;
}

- (NSInteger)find:(NSString *)str fromInex:(NSInteger)fromInex
{
    return [self find:str fromInex:fromInex reverse:NO];
}

- (NSInteger)find:(NSString *)str
{
    return [self find:str fromInex:0];
}

@end

@implementation AutoreleasePoolChecker

- (NSString *)checkScript:(NSString *)script scriptId:(NSString *)scriptId
{
    NSString *lua_function_str = @"function";
    NSString *lua_end_str = @"end";
    
    NSArray *searchList = [NSArray arrayWithObjects:lua_function_str, @"while", @"do", @"if", @"for", nil];
    
    
    return script;
}

@end
