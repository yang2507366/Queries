//
//  FiltUtils.m
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "FileUtils.h"
#import "ZipArchive.h"
#import "LuaAppManager.h"

@implementation FileUtils

+ (void)moveFileWithSourcePath:(NSString *)srcPath destinationPath:(NSString *)desPath
{
    [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:desPath error:nil];
}

+ (NSString *)readString:(NSString *)path
{
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (void)upzipFile:(NSString *)zipFilePath
           toPath:(NSString *)path
        overWrite:(BOOL)overWrite
            appId:(NSString *)appId
            objId:(NSString *)objId
     completeFunc:(NSString *)completeFunc
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZipArchive *zip = [[ZipArchive new] autorelease];
        [zip UnzipOpenFile:zipFilePath];
        [zip UnzipFileTo:path overWrite:overWrite];
        [zip UnzipCloseFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LuaAppManager scriptInteractionWithAppId:appId] callFunction:completeFunc parameters:objId, nil];
        });
    });
}

@end
