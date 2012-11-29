//
//  LIGeocoder.h
//  Queries
//
//  Created by yangzexin on 11/29/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExtremeGeocoder.h"
#import "LuaImplentatable.h"

@interface LIGeocoder : ExtremeGeocoder <LuaImplentatable>

@property(nonatomic, copy)NSString *didRecieveLocality;
@property(nonatomic, copy)NSString *didFailWithError;

@end
