//
//  SelfSupportChecker.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "IdentitySupportChecker.h"
#import "LuaConstants.h"
#import "LuaCommonUtils.h"

@implementation IdentitySupportChecker

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName  bundleId:(NSString *)bundleId
{
    if([LuaCommonUtils scriptIsMainScript:script]){
        script = [NSString stringWithFormat:@"%@\nfunction %@\n\treturn \"%@\";\nend\n", script, script_id_function_name, bundleId];
    }
    script = [script stringByReplacingOccurrencesOfString:lua_self withString:script_id_function_name];
    return script;
}

@end
