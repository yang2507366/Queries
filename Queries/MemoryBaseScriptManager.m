//
//  FileBaseScriptManager.m
//  Queries
//
//  Created by yangzexin on 13-2-25.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MemoryBaseScriptManager.h"
#import "LuaScriptCompiler.h"
#import "FileUtils.h"

@interface MemoryBaseScriptManager ()

@property(nonatomic, retain)id<ScriptCompiler> scriptCompiler;
@property(nonatomic, retain)NSDictionary *scriptDictionary;
@property(nonatomic, retain)NSMutableDictionary *compiledScriptDictionary;

@end

@implementation MemoryBaseScriptManager

- (void)dealloc
{
    self.scriptDictionary = nil;
    self.compiledScriptDictionary = nil;
    [super dealloc];
}

- (id)initWithBaseScriptsDirectory:(NSString *)dir
{
    self = [super init];
    
    self.scriptCompiler = [LuaScriptCompiler defaultScriptCompiler];
    self.compiledScriptDictionary = [NSMutableDictionary dictionary];
    NSDictionary *unitBaseScriptDictionary = [self.class generateUnitBaseScriptDictionaryWithBaseScrptsDirectory:dir];
    NSMutableDictionary *tmpScriptDictionary = [NSMutableDictionary dictionaryWithDictionary:unitBaseScriptDictionary];
    [FileUtils enumerateWithDirectoryPath:dir filePathBlock:^(NSString *filePath, BOOL isDirectory) {
        if(!isDirectory){
            [tmpScriptDictionary setObject:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]
                                    forKey:[filePath lastPathComponent]];
        }
    }];
    self.scriptDictionary = tmpScriptDictionary;
    
    return self;
}

- (NSString *)compiledScriptWithScriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    NSString *script = [self.compiledScriptDictionary objectForKey:scriptName];
    if(script.length == 0){
        script = [self scriptWithScriptName:scriptName];
        if(script){
            script = [self.scriptCompiler compileScript:script scriptName:scriptName bundleId:bundleId];
            [self.compiledScriptDictionary setObject:script forKey:scriptName];
        }
    }
    return script;
}

- (NSString *)scriptWithScriptName:(NSString *)scriptName
{
    return [self.scriptDictionary objectForKey:scriptName];
}

+ (NSString *)generateUnitScriptWithFolderPath:(NSString *)folderPath
{
    NSArray *subFileNameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSMutableString *requireString = [NSMutableString string];
    for(NSString *subFileName in subFileNameList){
        if([subFileName hasSuffix:@".lua"]){
            [requireString appendFormat:@"require \"%@\"\n", subFileName];
        }
    }
    NSString *tmpPath = [NSString stringWithFormat:@"%@/Library/UnitScripts/", NSHomeDirectory()];
    if(![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *tmpScriptPath = [tmpPath stringByAppendingPathComponent:[folderPath lastPathComponent]];
    [requireString writeToFile:tmpScriptPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    return tmpScriptPath;
}

+ (NSDictionary *)generateUnitBaseScriptDictionaryWithBaseScrptsDirectory:(NSString *)bundleRootPath
{
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    NSMutableArray *folderList = [NSMutableArray arrayWithObject:bundleRootPath];
    while(folderList.count != 0){
        NSString *lastFolder = [[[folderList lastObject] retain] autorelease];
        [folderList removeLastObject];
        
        NSArray *subFileNameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:lastFolder error:nil];
        for(NSString *subFileName in subFileNameList){
            NSString *subFilePath = [lastFolder stringByAppendingPathComponent:subFileName];
            BOOL isDir = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:subFilePath isDirectory:&isDir];
            if(isDir){
                [folderList addObject:subFilePath];
                if([lastFolder isEqualToString:bundleRootPath]){
                    [tmpDict setObject:[NSString stringWithContentsOfFile:[self generateUnitScriptWithFolderPath:subFilePath]
                                                                 encoding:NSUTF8StringEncoding
                                                                    error:nil]
                                forKey:[NSString stringWithFormat:@"%@.lua", subFileName]];
                }
            }
        }
    }
    return tmpDict;
}

@end
