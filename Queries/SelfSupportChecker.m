//
//  SelfSupportChecker.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "SelfSupportChecker.h"
#import "LuaConstants.h"

@implementation SelfSupportChecker

- (NSString *)checkScript:(NSString *)script scriptId:(NSString *)scriptId
{
    script = [NSString stringWithFormat:@"%@\nfunction %@\n\treturn \"%@\";\nend\n", script, script_id_function_name, scriptId];
    script = [script stringByReplacingOccurrencesOfString:lua_self withString:script_id_function_name];
    return script;
}

@end
