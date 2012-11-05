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
#import "LuaAppContext.h"
#import "LuaGroupedObjectManager.h"

@implementation AppRunImpl

+ (void)runWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId relatedViewControllerId:(NSString *)rvcId
{
    NSString *appDir = [lua_app_bundle_dir stringByAppendingPathComponent:targetAppId];
    LocalAppBundle *appBundle = [[[LocalAppBundle alloc] initWithDirectory:appDir] autorelease];
    LuaApp *app = [[[LuaApp alloc] initWithScriptBundle:appBundle baseWindow:nil] autorelease];
    app.relatedViewController = [LuaGroupedObjectManager objectWithId:rvcId group:appId];
    [LuaAppContext runRootApp:app];
}

+ (void)destoryAppWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId
{
    
}

@end
