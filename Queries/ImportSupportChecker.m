//
//  ImportSupportChecker.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ImportSupportChecker.h"
#import "LuaApplication.h"

@interface ImportSupportChecker ()

@property(nonatomic, copy)NSString *sourceScriptId;

@end

@implementation ImportSupportChecker

- (void)dealloc
{
    self.sourceScriptId = nil;
    [super dealloc];
}

- (NSString *)deleteScriptImportBlocks:(NSString *)script
{
    NSRange functionRange = [script rangeOfString:@"function"];
    if(functionRange.location == NSNotFound){
        functionRange.location = script.length;
    }
    NSString *importSentenses = [script substringToIndex:functionRange.location];
    if(importSentenses.length != 0){
        script = [script substringFromIndex:functionRange.location];
    }
    return script;
}

- (NSString *)importWithScriptId:(NSString *)scriptId originalScript:(NSString *)originalScript
{
    NSLog(@"importing:%@", scriptId);
    NSString *importScript = [LuaApplication originalScriptWithScriptId:scriptId];
    if(importScript.length != 0){
        NSLog(@"import success:%@", scriptId);
        importScript = [self check:importScript scriptId:scriptId];
        originalScript = [NSString stringWithFormat:@"%@\n%@", originalScript, importScript];
    }else{
        NSLog(@"import error, not found:%@", scriptId);
    }
    return originalScript;
}

- (NSString *)check:(NSString *)script scriptId:(NSString *)scriptId
{
    NSRange functionRange = [script rangeOfString:@"function"];
    if(functionRange.location == NSNotFound){
        functionRange.location = script.length;
    }
    NSString *importSentenses = [script substringToIndex:functionRange.location];
    if(importSentenses.length != 0){
        script = [script substringFromIndex:functionRange.location];
        
        importSentenses = [importSentenses stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *imports = [importSentenses componentsSeparatedByString:@";"];
        for(NSString *import in imports){
            import = [import stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(import.length != 0){
                import = [import stringByReplacingOccurrencesOfString:@"import" withString:@""];
                NSString *importScriptId = [ import stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if(importScriptId.length != 0){
                    if(![importScriptId isEqualToString:self.sourceScriptId]){
                        script = [self importWithScriptId:importScriptId originalScript:script];
                    }else{
                        NSLog(@"crossing import:%@->%@", scriptId, importScriptId);
                    }
                }
            }
        }
    }
    return script;
}

- (NSString *)checkScript:(NSString *)script scriptId:(NSString *)scriptId
{
    self.sourceScriptId = scriptId;
    return [self check:script scriptId:scriptId];
}

@end
