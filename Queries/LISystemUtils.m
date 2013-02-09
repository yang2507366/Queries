//
//  LISystemUtils.m
//  Queries
//
//  Created by yangzexin on 2/9/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "LISystemUtils.h"

@implementation LISystemUtils

+ (NSString *)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"YES" : @"NO";
}

@end
