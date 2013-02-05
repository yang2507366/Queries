//
//  FiltUtils.m
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

+ (void)moveFileWithSourcePath:(NSString *)srcPath destinationPath:(NSString *)desPath
{
    [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:desPath error:nil];
}

+ (NSString *)readString:(NSString *)path
{
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
