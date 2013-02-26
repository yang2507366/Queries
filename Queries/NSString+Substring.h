//
//  NSString+Substring.h
//  Queries
//
//  Created by yangzexin on 11/2/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Substring)

- (NSString *)substringWithBeginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;
- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex reverse:(BOOL)reverse isCaseSensitive:(BOOL)isCaseSensitive;
- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex reverse:(BOOL)reverse;
- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex;
- (NSInteger)find:(NSString *)str;

@end
