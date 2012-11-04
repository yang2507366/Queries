//
//  OnlineAppBundle.m
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LocalAppBundle.h"
#import "NSString+Substring.h"

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
        NSInteger beginIndex = [script find:@"function"];
        NSInteger endIndex = 0;
        while(beginIndex != -1){
            endIndex = [script find:@"(" fromIndex:beginIndex];
            if(endIndex != -1){
                NSString *funcName = [script substringWithBeginIndex:beginIndex + 8 endIndex:endIndex];
                funcName = [funcName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if(funcName.length == 4 && [funcName isEqualToString:@"main"]){
                    return [self scriptWithScriptName:file];
                }
                beginIndex = [script find:@"function" fromIndex:endIndex + 2];
            }else{
                break;
            }
        }
    }
    return nil;
}

@end
