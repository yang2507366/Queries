//
//  ScriptBoundle.h
//  Queries
//
//  Created by yangzexin on 11/2/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScriptBundle <NSObject>

- (NSString *)bundleId;
- (NSString *)scriptWithScriptName:(NSString *)scriptName;
- (NSString *)mainScript;

@end
