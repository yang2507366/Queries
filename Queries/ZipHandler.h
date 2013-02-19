//
//  ZipHandler.h
//  Queries
//
//  Created by yangzexin on 13-2-19.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZipHandler <NSObject>

- (void)unzipWithFilePath:(NSString *)filePath toDirectoryPath:(NSString *)dirPath;
- (void)zipWithDirectoryPath:(NSString *)directoryPath toFilePath:(NSString *)filePath;

@end
