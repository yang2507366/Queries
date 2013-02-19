//
//  FileUtils.m
//  Queries
//
//  Created by yangzexin on 2/19/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

+ (void)enumerateWithDirectoryPath:(NSString *)dirPath filePathBlock:(void(^)(NSString *filePath, BOOL isDirectory))filePathBlock
{
    NSMutableArray *folderList = [NSMutableArray arrayWithObject:dirPath];
    while(folderList.count != 0){
        NSString *lastFolderPath = [[[folderList lastObject] retain] autorelease];
        [folderList removeLastObject];
        NSArray *fileNameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:lastFolderPath error:nil];
        for(NSString *fileName in fileNameList){
            NSString *tmpFilePath = [lastFolderPath stringByAppendingPathComponent:fileName];
            BOOL isDir;
            if([[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath isDirectory:&isDir] && isDir){
                [folderList addObject:tmpFilePath];
            }
            filePathBlock(tmpFilePath, isDir);
        }
    }
}

@end
