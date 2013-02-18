//
//  TabCharReplaceChecker.m
//  Queries
//
//  Created by yangzexin on 13-2-18.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "TabCharReplaceChecker.h"

@implementation TabCharReplaceChecker

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    script = [script stringByReplacingOccurrencesOfString:@"\\t" withString:@"[__t]"];
    script = [script stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
    script = [script stringByReplacingOccurrencesOfString:@"[__t]" withString:@"\\t"];
    return script;
}

@end
