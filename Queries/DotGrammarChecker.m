//
//  DotGrammarChecker.m
//  Queries
//
//  Created by yangzexin on 10/24/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "DotGrammarChecker.h"
#import "LuaConstants.h"

@implementation DotGrammarChecker

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    NSRange beginRange = [script rangeOfString:lua_dot_grammar];
    NSRange endRange = NSMakeRange(0, 0);
    while(beginRange.location != NSNotFound){
        NSString *tmpString = [script substringWithRange:NSMakeRange(endRange.location, beginRange.location - endRange.location)];
        NSLog(@"%@", tmpString);
    }
    return script;
}

@end
