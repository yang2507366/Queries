//
//  PrefixGrammarChecker.m
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "PrefixGrammarChecker.h"
#import "LuaConstants.h"

@implementation PrefixGrammarChecker

- (NSString *)checkScript:(NSString *)script scriptId:(NSString *)scriptId
{
    NSMutableString *resultScript = [NSMutableString string];
    
    NSRange beginRange = [script rangeOfString:lua_prefix_grammar];
    NSRange endRange = NSMakeRange(0, 0);
    NSRange bracketRange;
    NSRange rightBracketRange;
    while(beginRange.location != NSNotFound){
        [resultScript appendString:[script substringWithRange:NSMakeRange(endRange.location, beginRange.location - endRange.location)]];
        
        beginRange.location += beginRange.length;
        bracketRange = [script rangeOfString:@"("
                                     options:NSCaseInsensitiveSearch
                                       range:NSMakeRange(beginRange.location, script.length - beginRange.location)];
        if(bracketRange.location != NSNotFound){
            rightBracketRange = [script rangeOfString:@")"
                                              options:NSCaseInsensitiveSearch
                                                range:NSMakeRange(bracketRange.location, script.length - bracketRange.location)];
            if(rightBracketRange.location != NSNotFound){
                NSString *methodName = [script substringWithRange:NSMakeRange(beginRange.location, bracketRange.location - beginRange.location)];
                methodName = [methodName stringByReplacingOccurrencesOfString:lua_method_separator withString:@"_"];
                NSString *paramStrings = [script substringWithRange:NSMakeRange(bracketRange.location + 1,
                                                                                rightBracketRange.location - bracketRange.location - 1)];
                BOOL mutipleParams = [paramStrings stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0;
                [resultScript appendFormat:@"%@(%@%@", methodName, lua_self, mutipleParams ? @", " : @""];
                
                endRange.location = bracketRange.location + bracketRange.length;
                endRange.length = script.length - endRange.location;
                beginRange = [script rangeOfString:lua_prefix_grammar options:NSCaseInsensitiveSearch range:endRange];
                continue;
            }
        }
        NSLog(@"PrefixGrammarChecker::checkScript:%@ encounter:%@, but not find '(' left bracket, sytax error?",
              NSStringFromClass(self.class), lua_prefix_grammar);
        return script;
    }
    [resultScript appendString:[script substringWithRange:NSMakeRange(endRange.location, script.length - endRange.location)]];
    return resultScript;
}

@end
