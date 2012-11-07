//
//  OnlineAppBundle.m
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LocalAppBundle.h"
#import "NSString+Substring.h"
#import "LuaCommonUtils.h"

@interface LocalAppBundle ()

@property(nonatomic, copy)NSString *dirPath;

@end

@implementation LocalAppBundle

- (void)dealloc
{
    self.dirPath = nil;
    [super dealloc];
}

- (id)initWithDirectory:(NSString *)dirPath
{
    self = [super init];
    
    self.dirPath = dirPath;
    
    return self;
}

- (NSString *)bundleId
{
    return [self.dirPath lastPathComponent];
}

- (NSString *)scriptWithScriptName:(NSString *)scriptName
{
    if(![scriptName hasSuffix:@".lua"]){
        scriptName = [NSString stringWithFormat:@"%@.lua", scriptName];
    }
    NSString *filePath = [[self.dirPath stringByAppendingPathComponent:@"src"] stringByAppendingPathComponent:scriptName];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    return script;
}

- (NSData *)resourceWithName:(NSString *)resName
{
    NSString *filePath = [[self.dirPath stringByAppendingPathComponent:@"res"] stringByAppendingPathComponent:resName];
    return [NSData dataWithContentsOfFile:filePath];
}

- (NSArray *)allScriptFileNames
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *subfiles = [fileMgr contentsOfDirectoryAtPath:[self.dirPath stringByAppendingPathComponent:@"src"] error:nil];
    NSMutableArray *filteredFiles = [NSMutableArray array];
    for(NSString *fileName in subfiles){
        if([fileName hasSuffix:@".lua"]){
            [filteredFiles addObject:fileName];
        }
    }
    return filteredFiles;
}

- (NSString *)mainScript
{
    NSArray *scriptList = [self allScriptFileNames];
    for(NSString *file in scriptList){
        NSString *filePath = [[self.dirPath stringByAppendingPathComponent:@"src"] stringByAppendingPathComponent:file];
        NSString *script = [NSString stringWithContentsOfFile:filePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
        if([LuaCommonUtils scriptIsMainScript:script]){
            NSLog(@"%@ find main script in file:%@", self.bundleId, file);
            return script;
        }
    }
    return nil;
}

- (NSString *)boundleVersion
{
    return @"0.0.0";
}

@end
