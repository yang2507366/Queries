//
//  ClassDefineReplaceChecker.h
//  Queries
//
//  Created by yangzexin on 13-2-22.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaScriptChecker.h"

@interface ClassDefineReplaceChecker : NSObject <LuaScriptChecker>

+ (BOOL)paramValid:(NSString *)param className:(NSString **)className baseClassName:(NSString **)baseClassName;

@end
