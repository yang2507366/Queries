//
//  BaseScriptManagerFactory.h
//  Queries
//
//  Created by yangzexin on 13-2-25.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseScriptManagerFactory : NSObject

+ (id)defaultBaseScriptManagerWithBaseScriptsBundlePath:(NSString *)bundlePath;

@end
