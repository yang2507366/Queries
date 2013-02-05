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

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    script = [CodeUtils encodeUnicode:script];
    return script;
}

@end
