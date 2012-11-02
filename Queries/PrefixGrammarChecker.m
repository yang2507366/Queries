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

- (NSString *)prefixGrammarCheck:(NSString *)script
{
    NSMutableString *resultScript = [NSMutableString string];
    
    NSRange beginRange = [script rangeOfString:lua_method_separator];
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
        D_Log(@"PrefixGrammarChecker::checkScript:%@ encounter:%@, but not find '(' left bracket, sytax error?",
              NSStringFromClass(self.class), lua_prefix_grammar);
        return script;
    }
    [resultScript appendString:[script substringWithRange:NSMakeRange(endRange.location, script.length - endRange.location)]];
    return resultScript;
}

- (NSString *)methodPrefixGrammarCheck:(NSString *)script
{
    NSMutableString *resultString = [NSMutableString string];
    NSRange beginRange = [script rangeOfString:lua_method_separator];
    NSRange endRange = NSMakeRange(0, 0);
    NSRange leftBracketRange = NSMakeRange(0, 0);
    NSRange rightBracketRange = NSMakeRange(0, 0);
    while(beginRange.location != NSNotFound){
        NSString *code = [script substringWithRange:NSMakeRange(endRange.location, beginRange.location - endRange.location)];
        [resultString appendString:code];
        beginRange.location += beginRange.length;
        endRange.location = beginRange.location;
        leftBracketRange = [script rangeOfString:@"("
                                         options:NSCaseInsensitiveSearch
                                           range:NSMakeRange(beginRange.location, script.length - beginRange.location)];
        if(leftBracketRange.location != NSNotFound){
            leftBracketRange.location += leftBracketRange.length;
            rightBracketRange = [script rangeOfString:@")"
                                              options:NSCaseInsensitiveSearch
                                                range:NSMakeRange(leftBracketRange.location, script.length - leftBracketRange.location)];
            if(rightBracketRange.location != NSNotFound){
                NSString *methodParams = [script substringWithRange:NSMakeRange(leftBracketRange.location,
                                                                                rightBracketRange.location - leftBracketRange.location)];;
                BOOL hasParams = [methodParams stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0;
                [resultString appendString:@"_"];
                NSString *methodName = [script substringWithRange:NSMakeRange(beginRange.location, leftBracketRange.location - beginRange.location)];
                [resultString appendString:methodName];
                [resultString appendString:hasParams ? [NSString stringWithFormat:@"%@, ", lua_self] : lua_self];
                
                endRange.location = leftBracketRange.location;
                endRange.length = script.length - endRange.location;
                beginRange = [script rangeOfString:lua_method_separator
                                           options:NSCaseInsensitiveSearch
                                             range:endRange];
            }
        }
    }
    [resultString appendString:[script substringWithRange:NSMakeRange(endRange.location, script.length - endRange.location)]];
    return resultString;
}

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    return [self methodPrefixGrammarCheck:script];
}

@end
