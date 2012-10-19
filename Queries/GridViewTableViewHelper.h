//
//  GridViewTableViewHelper.h
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GridViewTableViewHelper;

@protocol GridViewTableViewHelperDelegate <NSObject>

- (NSInteger)numberOfItemsOfGridViewTableViewHelper:(GridViewTableViewHelper *)gridViewTableViewHelper;
- (void)gridViewTableViewHelper:(GridViewTableViewHelper *)gridViewTableViewHelper configureView:(UIView *)view atIndex:(NSInteger)index;

@end

@interface GridViewTableViewHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign)id<GridViewTableViewHelperDelegate> delegate;
@property(nonatomic, readonly)NSInteger numberOfColumns;

- (id)initWithNumberOfColumns:(NSInteger)columns;

@end
