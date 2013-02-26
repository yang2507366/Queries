//
//  NSString+Substring.m
//  Queries
//
//  Created by yangzexin on 11/2/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "NSString+Substring.h"

@implementation NSString (Substring)

- (NSString *)substringWithBeginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex
{
    if(endIndex >= beginIndex){
        return [self substringWithRange:NSMakeRange(beginIndex, endIndex - beginIndex)];
    }
    return nil;
}

- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex reverse:(BOOL)reverse
{
    
    return [self find:str fromIndex:fromInex reverse:reverse isCaseSensitive:NO];
}

- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex reverse:(BOOL)reverse isCaseSensitive:(BOOL)isCaseSensitive
{
    if(fromInex < self.length){
        NSRange range = [self rangeOfString:str
                                    options:reverse ? NSBackwardsSearch : (isCaseSensitive ? NSLiteralSearch : NSCaseInsensitiveSearch)
                                      range:reverse ? NSMakeRange(0, fromInex) :NSMakeRange(fromInex, self.length - fromInex)];
        return range.location == NSNotFound ? -1 : range.location;
    }
    return -1;
}

- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex
{
    return [self find:str fromIndex:fromInex reverse:NO];
}

- (NSInteger)find:(NSString *)str
{
    return [self find:str fromIndex:0];
}

@end
