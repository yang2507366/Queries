//
//  TableView.m
//  Queries
//
//  Created by yangzexin on 11/13/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "TableView.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"
#import <objc/runtime.h>

@interface TableViewDataSourceProxy : NSObject <UITableViewDataSource>

@property(nonatomic, assign)TableView *targetTableView;

@end

@implementation TableViewDataSourceProxy

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TableView *tmp = (id)tableView;
    if(tmp.numberOfRowsInSection.length == 0){
        return 0;
    }
    return [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.numberOfRowsInSection
                                                                    parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableView *tmp = (id)tableView;
    if(tmp.cellForRowAtIndexPath.length == 0){
        return nil;
    }
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    NSString *cellId = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.cellForRowAtIndexPath
                                                                               parameters:tmp.objId, indexPathId, nil];
    id cell = [LuaObjectManager objectWithId:cellId group:tmp.appId];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    [LuaObjectManager releaseObjectWithId:cellId group:tmp.appId];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    TableView *tmp = (id)tableView;
    if(tmp.numberOfSections.length == 0){
        return 1;
    }
    return [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.numberOfSections
                                                                    parameters:tmp.objId, nil] intValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TableView *tmp = (id)tableView;
    if(tmp.titleForHeaderInSection.length == 0){
        return nil;
    }
    NSString *title = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.titleForHeaderInSection
                                                                              parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil];
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    TableView *tmp = (id)tableView;
    if(tmp.titleForFooterInSection.length == 0){
        return nil;
    }
    NSString *title = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.titleForFooterInSection
                                                                              parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil];
    return title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    BOOL can = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.canEditRowAtIndexPath
                                                                        parameters:tmp.objId, indexPathId, nil] boolValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return can;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    BOOL can = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.canMoveRowAtIndexPath
                                                                        parameters:tmp.objId, indexPathId, nil] boolValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return can;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    TableView *tmp = (id)tableView;
    NSString *titleArrayId = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.sectionIndexTitles
                                                                                     parameters:tmp.objId, nil];
    return [LuaObjectManager objectWithId:titleArrayId group:tmp.appId];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    TableView *tmp = (id)tableView;
    return [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.sectionForSectionIndexTitle
                                                                   parameters:tmp.objId, title, [NSString stringWithFormat:@"%d", index], nil] intValue];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.commitEditingStyle
                                                            parameters:tmp.objId, [NSString stringWithFormat:@"%d", editingStyle], indexPathId, nil];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    TableView *tmp = (id)tableView;
    NSString *sourceIndexPathId = [LuaObjectManager addObject:sourceIndexPath group:tmp.appId];
    NSString *destinationIndexPathId = [LuaObjectManager addObject:destinationIndexPath group:tmp.appId];
    [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.moveRowAtIndexPath
                                                            parameters:tmp.objId, sourceIndexPathId, destinationIndexPathId, nil];
    [LuaObjectManager releaseObjectWithId:sourceIndexPathId group:tmp.appId];
    [LuaObjectManager releaseObjectWithId:destinationIndexPathId group:tmp.appId];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSString *selectorName = NSStringFromSelector(aSelector);
    
    if([selectorName isEqualToString:@"tableView:canEditRowAtIndexPath:"] && self.targetTableView.canEditRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:canMoveRowAtIndexPath:"] && self.targetTableView.canMoveRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:moveRowAtIndexPath:toIndexPath:"] && self.targetTableView.moveRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:sectionForSectionIndexTitle:atIndex:"] && self.targetTableView.sectionForSectionIndexTitle.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:commitEditingStyle:forRowAtIndexPath:"] && self.targetTableView.commitEditingStyle.length == 0){
        return NO;
    }
    
    BOOL responds = class_respondsToSelector(self.class, aSelector);
//    NSLog(@"%@ %@", selectorName, responds ? @"responds" : @"not responds");
    return responds;
}

@end

@interface TableViewDelegateProxy : NSObject <UITableViewDelegate>

@property(nonatomic, assign)TableView *targetTableView;

@end

@implementation TableViewDelegateProxy

- (void)dealloc
{
    [super dealloc];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableView *tmp = (id)tableView;
    if(tmp.willDisplayCell.length != 0){
        NSString *cellId = [LuaObjectManager addObject:cell group:tmp.appId];
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.willDisplayCell parameters:tmp.objId, cellId, indexPathId, nil];
        [LuaObjectManager releaseObjectWithId:cellId group:tmp.appId];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    TableView *tmp = (id)tableView;
    if(tmp.willDisplayHeaderView.length != 0){
        NSString *viewId = [LuaObjectManager addObject:view group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.willDisplayHeaderView
                                                                parameters:tmp.objId, viewId, [NSString stringWithFormat:@"%d", section], nil];
        [LuaObjectManager releaseObjectWithId:viewId group:tmp.appId];
    }
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleNone;
//}

@end

@interface TableView ()

@property(nonatomic, retain)TableViewDataSourceProxy *dataSourceProxy;
@property(nonatomic, retain)TableViewDelegateProxy *delegateProxy;

@end

@implementation TableView

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    self.dataSourceProxy = nil;
    self.delegateProxy = nil;
    
    self.numberOfRowsInSection = nil;
    self.cellForRowAtIndexPath = nil;
    self.numberOfSections = nil;
    self.titleForHeaderInSection = nil;
    self.titleForFooterInSection = nil;
    self.canEditRowAtIndexPath = nil;
    self.canMoveRowAtIndexPath = nil;
    self.sectionIndexTitles = nil;
    self.sectionForSectionIndexTitle = nil;
    self.commitEditingStyle = nil;
    self.moveRowAtIndexPath = nil;
    
    self.willDisplayCell = nil;
    self.willDisplayHeaderView = nil;
    self.willDisplayFooterView = nil;
    self.didEndDisplayingCell = nil;
    self.didEndDisplayingHeaderView = nil;
    self.didEndDisplayingFooterView = nil;
    self.heightForRowAtIndexPath = nil;
    self.heightForHeaderInSection = nil;
    self.heightForFooterInSection = nil;
    self.viewForHeaderInSection = nil;
    self.viewForFooterInSection = nil;
    self.accessoryTypeForRowWithIndexPath = nil;
    self.accessoryButtonTappedForRowWithIndexPath = nil;
    self.shouldHighlightRowAtIndexPath = nil;
    self.didHighlightRowAtIndexPath = nil;
    self.didUnhighlightRowAtIndexPath = nil;
    self.willSelectRowAtIndexPath = nil;
    self.willDeselectRowAtIndexPath = nil;
    self.didSelectRowAtIndexPath = nil;
    self.didDeselectRowAtIndexPath = nil;
    self.editingStyleForRowAtIndexPath = nil;
    self.titleForDeleteConfirmationButtonForRowAtIndexPath = nil;
    self.shouldIndentWhileEditingRowAtIndexPath = nil;
    self.willBeginEditingRowAtIndexPath = nil;
    self.didEndEditingRowAtIndexPath = nil;
    self.targetIndexPathForMoveFromRowAtIndexPath = nil;
    self.indentationLevelForRowAtIndexPath = nil;
    self.shouldShowMenuForRowAtIndexPath = nil;
    self.canPerformAction = nil;
    self.performAction = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    self.dataSourceProxy = [[TableViewDataSourceProxy new] autorelease];
    self.dataSourceProxy.targetTableView = self;
    self.delegateProxy = [[TableViewDelegateProxy new] autorelease];
    self.delegateProxy.targetTableView = self;
    
    return self;
}

- (void)updateDelegate
{
    self.dataSource = self.dataSourceProxy;
    self.delegate = self.delegateProxy;
}

- (void)reloadData
{
    [self updateDelegate];
    [super reloadData];
}

+ (NSString *)create:(NSString *)appId style:(UITableViewCellStyle)style
{
    TableView *tmp = [[TableView alloc] initWithFrame:CGRectZero style:style];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

+ (NSString *)create:(NSString *)appId
{
    return [self create:appId style:UITableViewStylePlain];
}

@end
