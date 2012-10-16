//
//  GridViewIcon.m
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "GridViewIcon.h"

@implementation GridViewIcon

- (id)initWithTitle:(NSString *)title icon:(UIImage *)icon
{
    self = [super init];
    
    self.title = title;
    self.icon = icon;
    
    return self;
}

- (void)dealloc
{
    self.title = nil;
    self.icon = nil;
    [super dealloc];
}

@end
