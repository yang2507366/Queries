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

@property(nonatomic, copy)NSString *mainScriptName;

@end

@implementation ApplicationScriptBundle

- (void)dealloc
{
    self.mainScriptName = nil;
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

- (id)initWithMainScriptName:(NSString *)scriptName
{
    self = [super init];
    
    self.mainScriptName = scriptName;
    
    return self;
}

- (NSString *)bundleId
{
    return @"ApplicationScriptBundle";
}

- (NSString *)bundleVersion
{
    return @"0.0.0";
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
    if(self.mainScriptName.length == 0){
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
    }else{
        NSString *scriptName = self.mainScriptName;
        if(![scriptName hasSuffix:@".lua"]){
            scriptName = [NSString stringWithFormat:@"%@.lua", scriptName];
        }
        return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:scriptName ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    }
    return nil;
}

- (NSData *)resourceWithName:(NSString *)resName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resName ofType:nil];
    
    return [NSData dataWithContentsOfFile:filePath];
}

- (BOOL)resourceExistsWithName:(NSString *)resName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resName ofType:nil];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

@end
