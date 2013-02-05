//
//  BarButtonItem.h
//  Queries
//
//  Created by yangzexin on 11/18/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"

@interface LIBarButtonItem : UIBarButtonItem <LuaImplentatable>

@property(nonatomic, copy)NSString *tapped;

+ (NSString *)createWithAppId:(NSString *)appId systemItem:(NSInteger)systemItem;

@end
