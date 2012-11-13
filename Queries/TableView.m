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

@interface TableViewDataSourceProxy : NSObject <UITableViewDataSource>

@property(nonatomic, assign)TableView *tableView;

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
    BOOL can = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.canEditRowAtIndexPath parameters:tmp.objId, indexPathId, nil] boolValue];
    return can;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSString *selectorName = NSStringFromSelector(aSelector);
    
    if([selectorName isEqualToString:@"tableView:canEditRowAtIndexPath:"] && self.tableView.canEditRowAtIndexPath.length == 0){
        return NO;
    }
    
    return [super respondsToSelector:aSelector];
}

@end

@interface TableView ()

@property(nonatomic, retain)TableViewDataSourceProxy *dataSourceProxy;

@end

@implementation TableView

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    self.dataSourceProxy = nil;
    
    self.numberOfRowsInSection = nil;
    self.cellForRowAtIndexPath = nil;
    self.numberOfSections = nil;
    self.titleForHeaderInSection = nil;
    self.titleForFooterInSection = nil;
    self.canEditRowAtIndexPath = nil;
    self.canMoveRowAtIndexPath = nil;
    self.sectionIndexTitlesForTableView = nil;
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
    self.dataSourceProxy.tableView = self;
    self.dataSource = self.dataSourceProxy;
    
    return self;
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
