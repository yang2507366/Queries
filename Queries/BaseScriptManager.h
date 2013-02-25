//
//  BaseScriptManager.h
//  Queries
//
//  Created by yangzexin on 13-2-25.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseScriptManager <NSObject>

- (NSString *)compiledScriptWithScriptName:(NSString *)scriptName bundleId:(NSString *)bundleId;
- (NSString *)scriptWithScriptName:(NSString *)scriptName;

@end
