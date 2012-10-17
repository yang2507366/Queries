//
//  GridViewTableViewHelper.h
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridViewTableViewHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (id)initWithNumberOfColumns:(NSInteger)columns;

@property(nonatomic, retain)NSArray *gridViewIcons;

@end
