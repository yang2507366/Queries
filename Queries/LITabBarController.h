//
//  LITabViewController.h
//  Queries
//
//  Created by yangzexin on 1/17/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"

@interface LITabBarController : UITabBarController <LuaImplentatable>

@property(nonatomic, copy)NSString *shouldSelectViewController;
@property(nonatomic, copy)NSString *didSelectViewController;

@end
