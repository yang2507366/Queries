//
//  LuaScriptCompiler.h
//  Queries
//
//  Created by yangzexin on 2/24/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptCompiler.h"

@interface LuaScriptCompiler : NSObject <ScriptCompiler>

+ (id)defaultScriptCompiler;

@end
