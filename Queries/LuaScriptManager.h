//
//  LuaScriptManager.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaScriptManager : NSObject

+ (id)sharedManager;

- (NSString *)scriptForIdentifier:(NSString *)identifier;
- (void)addScript:(NSString *)script;

@end
