//
//  GridViewTableViewHelper.h
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GridViewWrapper;

@protocol GridViewWrapperDelegate <NSObject>

- (NSInteger)numberOfItemsInGridViewWrapper:(GridViewWrapper *)gridViewWrapper;
- (void)gridViewWrapper:(GridViewWrapper *)gridViewWrapper configureView:(UIView *)view atIndex:(NSInteger)index;
@optional
- (void)gridViewWrapper:(GridViewWrapper *)gridViewWrapper viewItemTappedAtIndex:(NSInteger)index;

@end

@interface GridViewWrapper : NSObject <UITableViewDataSource>

@property(nonatomic, assign)id<GridViewWrapperDelegate> delegate;
@property(nonatomic, readonly)NSInteger numberOfColumns;

- (id)initWithNumberOfColumns:(NSInteger)columns;

@end
