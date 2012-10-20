//
//  LuaScriptInvokeFilter.h
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LuaScriptInvokeFilter <NSObject>

- (NSString *)filterParameter:(NSString *)parameter;
- (NSString *)filterReturnValue:(NSString *)returnValue;

@end
