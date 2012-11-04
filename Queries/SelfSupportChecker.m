//
//  SelfSupportChecker.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "SelfSupportChecker.h"
#import "LuaConstants.h"
#import "NSString+Substring.h"

@implementation SelfSupportChecker

- (BOOL)scriptIsMainScript:(NSString *)script
{
    NSInteger beginIndex = [script find:@"function"];
    NSInteger endIndex = 0;
    while(beginIndex != -1){
        endIndex = [script find:@"(" fromIndex:beginIndex];
        if(endIndex != -1){
            NSString *funcName = [script substringWithBeginIndex:beginIndex + 8 endIndex:endIndex];
            funcName = [funcName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(funcName.length == 4 && [funcName isEqualToString:@"main"]){
                return YES;
            }
            beginIndex = [script find:@"function" fromIndex:endIndex + 2];
        }else{
            break;
        }
    }
    return NO;
}

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName  bundleId:(NSString *)bundleId
{
    if([self scriptIsMainScript:script]){
        script = [NSString stringWithFormat:@"%@\nfunction %@\n\treturn \"%@\";\nend\n", script, script_id_function_name, bundleId];
    }
    script = [script stringByReplacingOccurrencesOfString:lua_self withString:script_id_function_name];
    return script;
}

@end
