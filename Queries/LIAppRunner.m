//
//  AppRunImpl.m
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIAppRunner.h"
#import "LuaConstants.h"
#import "LocalAppBundle.h"
#import "LuaApp.h"
#import "LuaAppManager.h"
#import "LuaObjectManager.h"
#import "LuaCommonUtils.h"

@implementation LIAppRunner

+ (void)runWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId params:(NSString *)params relatedViewControllerId:(NSString *)rvcId
{
    if([LuaCommonUtils isObjCObject:params]){
        params = [LuaObjectManager objectWithId:params group:appId];
    }
    NSString *appDir = [lua_app_bundle_dir stringByAppendingPathComponent:targetAppId];
    LocalAppBundle *appBundle = [[[LocalAppBundle alloc] initWithDirectory:appDir] autorelease];
    LuaApp *app = [[[LuaApp alloc] initWithScriptBundle:appBundle baseWindow:nil] autorelease];
    app.relatedViewController = [LuaObjectManager objectWithId:rvcId group:appId];
    [LuaAppManager runApp:app params:params];
}

+ (void)destoryAppWithAppId:(NSString *)appId targetAppId:(NSString *)targetAppId
{
    
}

@end
