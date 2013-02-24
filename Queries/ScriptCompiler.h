//
//  ScriptCompiler.h
//  Queries
//
//  Created by yangzexin on 2/24/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScriptCompiler <NSObject>

- (NSString *)compileScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId;

@end
