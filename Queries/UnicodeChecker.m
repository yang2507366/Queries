//
//  UnicodeChecker.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "UnicodeChecker.h"
#import "CodeUtils.h"

@implementation UnicodeChecker

- (NSString *)checkScript:(NSString *)script scriptId:(NSString *)scriptId
{
    return [CodeUtils encodeUnicode:script];
}

@end
