//
//  Button.h
//  Queries
//
//  Created by yangzexin on 11/17/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"

@interface LIButton : UIButton

@end

@interface UIButton (GlobalCallbackSupport)

@property(nonatomic, copy)NSString *globalCallbackFuncName;
@property(nonatomic, copy)NSString *globalCallbackFuncCategory;


@end
