//
//  AppLoaderImpl.m
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIAppLoader.h"
#import "OnlineAppBundleLoader.h"
#import "ProviderPool.h"
#import "LuaConstants.h"
#import "ZipHandler.h"
#import "ZipHandlerFactory.h"

@implementation LIAppLoader

+ (void)loadWithAppId:(NSString *)appId
                   si:(id<ScriptInteraction>)si
             loaderId:(NSString *)loaderId
            urlString:(NSString *)urlString
          processFunc:(NSString *)processFunc
         completeFunc:(NSString *)completeFunc
{
    OnlineAppBundleLoader *loader = [[[OnlineAppBundleLoader alloc] initWithURLString:urlString] autorelease];
    [loader loadWithCompletion:^(NSString *filePath) {
        if(filePath.length != 0){
            NSString *bundleId = [filePath lastPathComponent];
            NSString *targetPath = [lua_app_bundle_dir stringByAppendingPathComponent:bundleId];
            [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:NO attributes:nil error:nil];
            id<ZipHandler> zipHandler = [ZipHandlerFactory defaultZipHandler];
            [zipHandler unzipWithFilePath:filePath toDirectoryPath:targetPath];
            [si callFunction:completeFunc parameters:loaderId, @"1", bundleId, nil];
        }else{
            [si callFunction:completeFunc parameters:loaderId, @"0", nil];
        }
    }];
    [ProviderPool addProviderToSharedPool:loader identifier:loaderId];
}

+ (void)cancelLoadWithAppId:(NSString *)appId loaderId:(NSString *)loaderId
{
    [ProviderPool cleanWithIdentifier:loaderId];
}

@end
