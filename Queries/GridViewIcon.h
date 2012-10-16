//
//  GridViewIcon.h
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridViewIcon : NSObject

- (id)initWithTitle:(NSString *)title icon:(UIImage *)icon;

@property(nonatomic, copy)NSString *title;
@property(nonatomic, retain)UIImage *icon;

@end
