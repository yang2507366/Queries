//
//  LILocationManager.h
//  Queries
//
//  Created by yangzexin on 11/29/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"
#import "AccurateLocationManager.h"

@interface LILocationManager : AccurateLocationManager <LuaImplentatable>

@property(nonatomic, copy)NSString *didUpdateToLocation;
@property(nonatomic, copy)NSString *didFailWithError;

@end
