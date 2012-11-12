//
//  AppRunImpl.m
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "AppRunImpl.h"
#import "LuaConstants.h"
#import "LocalAppBundle.h"
#import "LuaApp.h"
#import "LuaAppRunner.h"
#import "LuaObjectManager.h"

@implementation AppRunImpl

+ (void)runWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId relatedViewControllerId:(NSString *)rvcId
{
    NSString *appDir = [lua_app_bundle_dir stringByAppendingPathComponent:targetAppId];
    LocalAppBundle *appBundle = [[[LocalAppBundle alloc] initWithDirectory:appDir] autorelease];
    LuaApp *app = [[[LuaApp alloc] initWithScriptBundle:appBundle baseWindow:nil] autorelease];
    app.relatedViewController = [LuaObjectManager objectWithId:rvcId group:appId];
    [LuaAppRunner runRootApp:app];
}

+ (void)destoryAppWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId
{
    
}

@end
