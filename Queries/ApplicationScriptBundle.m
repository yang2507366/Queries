//
//  ApplicationScriptBundle.m
//  Queries
//
//  Created by yangzexin on 11/2/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ApplicationScriptBundle.h"
#import "LuaConstants.h"
#import "LuaCommonUtils.h"

@interface ApplicationScriptBundle ()

@end

@implementation ApplicationScriptBundle

- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
//    NSString *appPath = [[NSBundle mainBundle] bundlePath];
//    NSInteger fileCount = 0;
//    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appPath error:nil];
//    for(NSString *fileName in fileNames){
//        if([fileName hasSuffix:@".lua"]){
//            NSLog(@"%@", fileName);
//            ++fileCount;
//        }
//    }
//    NSLog(@"script file count:%d", fileCount);
    
    return self;
}

- (NSString *)bundleId
{
    return @"main_bundle";
}

- (NSString *)scriptWithScriptName:(NSString *)scriptName
{
    if(![scriptName hasSuffix:@".lua"]){
        scriptName = [NSString stringWithFormat:@"%@.lua", scriptName];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:scriptName ofType:nil];
    
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)mainScript
{
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appPath error:nil];
    for(NSString *fileName in fileNames){
        if([fileName hasSuffix:@".lua"]){
            NSString *script = [NSString stringWithContentsOfFile:[appPath stringByAppendingPathComponent:fileName]
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil];
            if([LuaCommonUtils scriptIsMainScript:script]){
                NSLog(@"%@ find main script in file:%@", self.bundleId, fileName);
                return script;
            }
        }
    }
    return nil;
}

- (NSData *)resourceWithName:(NSString *)resName
{
    return nil;
}

@end
