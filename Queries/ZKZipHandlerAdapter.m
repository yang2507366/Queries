//
//  ZKZipHandlerAdapter.m
//  Queries
//
//  Created by yangzexin on 13-2-19.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "ZKZipHandlerAdapter.h"
#import "ZKFileArchive.h"
#import "ZipArchive.h"

@implementation ZKZipHandlerAdapter

- (void)unzipWithFilePath:(NSString *)filePath toDirectoryPath:(NSString *)dirPath
{
    ZipArchive *zip = [[ZipArchive new] autorelease];
    [zip UnzipOpenFile:filePath];
    [zip UnzipFileTo:dirPath overWrite:YES];
    [zip UnzipCloseFile];
}

- (void)zipWithDirectoryPath:(NSString *)directoryPath toFilePath:(NSString *)toFilePath
{
    NSString *dirFatherPath = [directoryPath stringByDeletingLastPathComponent];
    ZKFileArchive *fileArchive = [ZKFileArchive archiveWithArchivePath:toFilePath];
    [fileArchive deflateDirectory:directoryPath relativeToPath:dirFatherPath usingResourceFork:NO];
}

@end
