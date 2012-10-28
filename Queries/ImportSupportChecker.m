//
//  ImportSupportChecker.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ImportSupportChecker.h"
#import "LuaApplication.h"
#import "LuaConstants.h"

@interface ImportSupportChecker ()

@property(nonatomic, copy)NSString *sourceScriptId;
@property(nonatomic, retain)NSMutableArray *fileListImported;
@property(nonatomic, assign)BOOL hasObjectLua;

@end

@implementation ImportSupportChecker

- (void)dealloc
{
    self.sourceScriptId = nil;
    self.fileListImported = nil;
    
    [super dealloc];
}

- (NSString *)importWithScriptId:(NSString *)scriptId originalScript:(NSString *)originalScript
{
    if([self.fileListImported indexOfObject:scriptId] != NSNotFound){
        D_Log(@"script:%@ already imported", scriptId);
        return originalScript;
    }
    D_Log(@"importing:%@", scriptId);
    NSString *importScript = [LuaApplication originalScriptWithScriptId:scriptId];
    if(importScript.length != 0){
        D_Log(@"import success:%@", scriptId);
        importScript = [self check:importScript scriptId:scriptId];
        if([scriptId isEqualToString:lua_object_file]){
            self.hasObjectLua = YES;
        }else{
            originalScript = [NSString stringWithFormat:@"\n-- ********** %@\n%@\n%@", scriptId, importScript, originalScript];
            [self.fileListImported addObject:scriptId];
        }
        
    }else{
        D_Log(@"import error, not found:%@", scriptId);
    }
    return originalScript;
}

- (NSString *)check:(NSString *)script scriptId:(NSString *)scriptId
{
    NSRange functionRange = [script rangeOfString:@"import" options:NSBackwardsSearch];
    if(functionRange.location != NSNotFound){
        functionRange = [script rangeOfString:@";"
                                      options:NSCaseInsensitiveSearch
                                        range:NSMakeRange(functionRange.location, script.length - functionRange.location)];
        if(functionRange.location != NSNotFound){
            functionRange.location += 1;
        }else{
            functionRange = NSMakeRange(0, 0);
        }
    }else{
        functionRange = NSMakeRange(0, 0);
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
                        D_Log(@"crossing import:%@->%@", scriptId, importScriptId);
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
    self.fileListImported = [NSMutableArray array];
    NSString *resultScript = [self check:script scriptId:scriptId];
    if(self.hasObjectLua){
        NSString *objectLuaSource = [LuaApplication originalScriptWithScriptId:lua_object_file];
        resultScript = [NSString stringWithFormat:@"%@\n%@", objectLuaSource, resultScript];
        self.fileListImported = [NSMutableArray array];
        resultScript = [self check:resultScript scriptId:scriptId];
    }
    
    return resultScript;
}

@end
