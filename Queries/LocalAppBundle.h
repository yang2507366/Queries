//
//  OnlineAppBundle.h
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptBundle.h"

@interface LocalAppBundle : NSObject <ScriptBundle>

- (id)initWithDirectory:(NSString *)dirPath;
- (id)initWithPackageFile:(NSString *)packageFile;

@end
