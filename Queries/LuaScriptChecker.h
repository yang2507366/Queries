//
//  LuaScriptChecker.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

@protocol LuaScriptChecker <NSObject>

- (NSString *)checkScript:(NSString *)script scriptId:(NSString *)scriptId;

@end
