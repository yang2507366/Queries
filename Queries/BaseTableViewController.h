//
//  BaseTableViewController.h
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain)UITableView *tableView;

- (UITableViewStyle)tableViewStyle;

@end
