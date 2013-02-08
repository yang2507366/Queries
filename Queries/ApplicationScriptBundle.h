//
//  ApplicationScriptBundle.h
//  Queries
//
//  Created by yangzexin on 11/2/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptBundle.h"

@interface ApplicationScriptBundle : NSObject <ScriptBundle>

- (id)initWithMainScriptName:(NSString *)scriptName;

@end
