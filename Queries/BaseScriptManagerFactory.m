//
//  BaseScriptManagerFactory.m
//  Queries
//
//  Created by yangzexin on 13-2-25.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "BaseScriptManagerFactory.h"
#import "MemoryBaseScriptManager.h"

@implementation BaseScriptManagerFactory

+ (id)defaultBaseScriptManagerWithBaseScriptsBundlePath:(NSString *)bundlePath
{
    return [[[MemoryBaseScriptManager alloc] initWithBaseScriptsDirectory:bundlePath] autorelease];
}

@end
