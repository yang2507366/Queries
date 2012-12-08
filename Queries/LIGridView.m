//
//  LIGridView.m
//  Queries
//
//  Created by yangzexin on 12-12-7.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "LIGridView.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"
#import "GridViewWrapper.h"

@interface LIGridView () <GridViewWrapperDelegate>

@property(nonatomic, retain)GridViewWrapper *gridViewWrapper;

@end

@implementation LIGridView

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    self.numberOfItemsInGridViewWrapper = nil;
    self.configureViewAtIndex = nil;
    self.viewItemDidTappedAtIndex = nil;
    self.gridViewWrapper = nil;
    [super dealloc];
}

- (void)setNumberOfColumns:(NSInteger)pNumberOfColumns
{
    _numberOfColumns = pNumberOfColumns;
    self.gridViewWrapper = [[[GridViewWrapper alloc] initWithNumberOfColumns:_numberOfColumns] autorelease];
    self.gridViewWrapper.delegate = self;
    self.dataSource = self.gridViewWrapper;
}

#pragma mark - GridViewWrapper
- (void)gridViewWrapper:(GridViewWrapper *)gridViewWrapper configureView:(UIView *)view atIndex:(NSInteger)index
{
    if(self.configureViewAtIndex.length != 0){
        NSString *viewId = [LuaObjectManager addObject:view group:self.appId];
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.configureViewAtIndex
                                                                 parameters:self.objId, viewId, [NSString stringWithFormat:@"%d", index], nil];
        [LuaObjectManager releaseObjectWithId:viewId group:self.appId];
    }
}

- (NSInteger)numberOfItemsInGridViewWrapper:(GridViewWrapper *)gridViewWrapper
{
    if(self.numberOfItemsInGridViewWrapper.length != 0){
        NSInteger num = [[[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.numberOfItemsInGridViewWrapper
                                                                                  parameters:self.objId, nil] intValue];
        return num;
    }
    return 0;
}

- (void)gridViewWrapper:(GridViewWrapper *)gridViewWrapper viewItemTappedAtIndex:(NSInteger)index
{
    if(self.viewItemDidTappedAtIndex.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.viewItemDidTappedAtIndex
                                                                 parameters:self.objId, [NSString stringWithFormat:@"%d", index], nil];
    }
}

+ (NSString *)create:(NSString *)appId
{
    LIGridView *tmp = [[[LIGridView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] autorelease];
    tmp.separatorStyle = UITableViewCellSeparatorStyleNone;
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
