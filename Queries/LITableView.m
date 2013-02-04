//
//  TableView.m
//  Queries
//
//  Created by yangzexin on 11/13/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LITableView.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"
#import <objc/runtime.h>

@interface TableViewDataSourceProxy : NSObject <UITableViewDataSource>

@property(nonatomic, assign)LITableView *targetTableView;

@end

@implementation TableViewDataSourceProxy

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    if(tmp.numberOfRowsInSection.length == 0){
        return 0;
    }
    return [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.numberOfRowsInSection
                                                                    parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
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
    LITableView *tmp = (id)tableView;
    if(tmp.numberOfSections.length == 0){
        return 1;
    }
    return [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.numberOfSections
                                                                    parameters:tmp.objId, nil] intValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    if(tmp.titleForHeaderInSection.length == 0){
        return nil;
    }
    NSString *title = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.titleForHeaderInSection
                                                                              parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil];
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    if(tmp.titleForFooterInSection.length == 0){
        return nil;
    }
    NSString *title = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.titleForFooterInSection
                                                                              parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil];
    return title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    BOOL can = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.canEditRowAtIndexPath
                                                                        parameters:tmp.objId, indexPathId, nil] boolValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return can;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    BOOL can = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.canMoveRowAtIndexPath
                                                                        parameters:tmp.objId, indexPathId, nil] boolValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return can;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    LITableView *tmp = (id)tableView;
    NSString *titleArrayId = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.sectionIndexTitles
                                                                                     parameters:tmp.objId, nil];
    return [LuaObjectManager objectWithId:titleArrayId group:tmp.appId];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    LITableView *tmp = (id)tableView;
    return [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.sectionForSectionIndexTitle
                                                                   parameters:tmp.objId, title, [NSString stringWithFormat:@"%d", index], nil] intValue];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.commitEditingStyle
                                                            parameters:tmp.objId, [NSString stringWithFormat:@"%d", editingStyle], indexPathId, nil];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    LITableView *tmp = (id)tableView;
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
    }else if([selectorName isEqualToString:@"sectionIndexTitlesForTableView:"] && self.targetTableView.sectionIndexTitles.length == 0){
        return NO;
    }
    
    BOOL responds = class_respondsToSelector(self.class, aSelector);
    return responds;
}

@end

@interface TableViewDelegateProxy : NSObject <UITableViewDelegate>

@property(nonatomic, assign)LITableView *targetTableView;

@end

@implementation TableViewDelegateProxy

- (void)dealloc
{
    [super dealloc];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
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
    LITableView *tmp = (id)tableView;
    if(tmp.willDisplayHeaderView.length != 0){
        NSString *viewId = [LuaObjectManager addObject:view group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.willDisplayHeaderView
                                                                parameters:tmp.objId, viewId, [NSString stringWithFormat:@"%d", section], nil];
        [LuaObjectManager releaseObjectWithId:viewId group:tmp.appId];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    if(tmp.willDisplayFooterView.length != 0){
        NSString *viewId = [LuaObjectManager addObject:view group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.willDisplayFooterView
                                                                parameters:tmp.objId, viewId, [NSString stringWithFormat:@"%d", section], nil];
        [LuaObjectManager releaseObjectWithId:viewId group:tmp.appId];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    if(tmp.didEndDisplayingCell.length != 0){
        NSString *cellId = [LuaObjectManager addObject:cell group:tmp.appId];
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.didEndDisplayingCell parameters:tmp.objId, cellId, indexPathId, nil];
        [LuaObjectManager releaseObjectWithId:cellId group:tmp.appId];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    if(tmp.didEndDisplayingHeaderView.length != 0){
        NSString *viewId = [LuaObjectManager addObject:view group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.didEndDisplayingHeaderView
                                                                parameters:tmp.objId, viewId, [NSString stringWithFormat:@"%d", section], nil];
        [LuaObjectManager releaseObjectWithId:viewId group:tmp.appId];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    if(tmp.didEndDisplayingFooterView.length != 0){
        NSString *viewId = [LuaObjectManager addObject:view group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.didEndDisplayingFooterView
                                                                parameters:tmp.objId, viewId, [NSString stringWithFormat:@"%d", section], nil];
        [LuaObjectManager releaseObjectWithId:viewId group:tmp.appId];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    CGFloat height = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.heightForRowAtIndexPath
                                                                             parameters:tmp.objId, indexPathId, nil] floatValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    CGFloat height = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId]
                       callFunction:tmp.heightForHeaderInSection parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil] floatValue];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    CGFloat height = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId]
                       callFunction:tmp.heightForFooterInSection parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil] floatValue];
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    NSString *viewId = [[LuaAppManager scriptInteractionWithAppId:tmp.appId]
                        callFunction:tmp.viewForHeaderInSection parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil];
    UIView *view = [[LuaObjectManager objectWithId:viewId group:tmp.appId] retain];
    [LuaObjectManager releaseObjectWithId:viewId group:tmp.appId];
    
    return [view autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LITableView *tmp = (id)tableView;
    NSString *viewId = [[LuaAppManager scriptInteractionWithAppId:tmp.appId]
                        callFunction:tmp.viewForFooterInSection parameters:tmp.objId, [NSString stringWithFormat:@"%d", section], nil];
    UIView *view = [[LuaObjectManager objectWithId:viewId group:tmp.appId] retain];
    [LuaObjectManager releaseObjectWithId:viewId group:tmp.appId];
    
    return [view autorelease];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    if(tmp.accessoryButtonTappedForRowWithIndexPath.length != 0){
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.accessoryButtonTappedForRowWithIndexPath
                                                                 parameters:tmp.objId, indexPathId, nil] floatValue];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    BOOL should = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.shouldHighlightRowAtIndexPath
                                                                           parameters:tmp.objId, indexPathId, nil] boolValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return should;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    if(tmp.didHighlightRowAtIndexPath.length != 0){
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.didHighlightRowAtIndexPath
                                                                 parameters:tmp.objId, indexPathId, nil] boolValue];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    if(tmp.didUnhighlightRowAtIndexPath.length != 0){
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.didUnhighlightRowAtIndexPath
                                                                 parameters:tmp.objId, indexPathId, nil] boolValue];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    NSString *newIndexPathId = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.willSelectRowAtIndexPath
                                                                                       parameters:tmp.objId, indexPathId, nil];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    NSIndexPath *newIndexPath = [[LuaObjectManager objectWithId:newIndexPathId group:tmp.appId] retain];
    [LuaObjectManager releaseObjectWithId:newIndexPathId group:tmp.appId];
    
    return [newIndexPath autorelease];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    NSString *newIndexPathId = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.willDeselectRowAtIndexPath
                                                                                       parameters:tmp.objId, indexPathId, nil];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    NSIndexPath *newIndexPath = [[LuaObjectManager objectWithId:newIndexPathId group:tmp.appId] retain];
    [LuaObjectManager releaseObjectWithId:newIndexPathId group:tmp.appId];
    
    return [newIndexPath autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    if(tmp.didSelectRowAtIndexPath.length != 0){
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.didSelectRowAtIndexPath
                                                                 parameters:tmp.objId, indexPathId, nil];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    if(tmp.didDeselectRowAtIndexPath.length != 0){
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.didDeselectRowAtIndexPath
                                                                 parameters:tmp.objId, indexPathId, nil];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    NSInteger editingStyle = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.editingStyleForRowAtIndexPath
                                                                                     parameters:tmp.objId, indexPathId, nil] intValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return editingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    NSString *title = [[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.titleForDeleteConfirmationButtonForRowAtIndexPath
                                                                                      parameters:tmp.objId, indexPathId, nil];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return title;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    BOOL should = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.shouldIndentWhileEditingRowAtIndexPath
                                                                           parameters:tmp.objId, indexPathId, nil] boolValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return should;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    if(tmp.willBeginEditingRowAtIndexPath.length != 0){
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.willBeginEditingRowAtIndexPath
                                                                 parameters:tmp.objId, indexPathId, nil] boolValue];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    if(tmp.didEndEditingRowAtIndexPath.length != 0){
        NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
        [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.didEndEditingRowAtIndexPath
                                                                 parameters:tmp.objId, indexPathId, nil] boolValue];
        [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    LITableView *tmp = (id)tableView;
    NSString *sourceIndexPathId = [LuaObjectManager addObject:sourceIndexPath group:tmp.appId];
    NSString *destinationIndexPathId = [LuaObjectManager addObject:proposedDestinationIndexPath group:tmp.appId];
    NSString *resultIndexPathId = [[LuaAppManager scriptInteractionWithAppId:tmp.appId]
                                   callFunction:tmp.targetIndexPathForMoveFromRowAtIndexPath parameters:tmp.objId, sourceIndexPathId, destinationIndexPathId, nil];
    [LuaObjectManager releaseObjectWithId:sourceIndexPathId group:tmp.appId];
    [LuaObjectManager releaseObjectWithId:destinationIndexPathId group:tmp.appId];
    NSIndexPath *resultIndexPath = [[LuaObjectManager objectWithId:resultIndexPathId group:tmp.appId] retain];
    [LuaObjectManager releaseObjectWithId:resultIndexPathId group:tmp.objId];
    return [resultIndexPath autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    NSInteger indentationLevel = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.indentationLevelForRowAtIndexPath
                                                                                      parameters:tmp.objId, indexPathId, nil] intValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return indentationLevel;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LITableView *tmp = (id)tableView;
    NSString *indexPathId = [LuaObjectManager addObject:indexPath group:tmp.appId];
    BOOL should = [[[LuaAppManager scriptInteractionWithAppId:tmp.appId] callFunction:tmp.shouldShowMenuForRowAtIndexPath
                                                                           parameters:tmp.objId, indexPathId, nil] boolValue];
    [LuaObjectManager releaseObjectWithId:indexPathId group:tmp.appId];
    return should;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSString *selectorName = NSStringFromSelector(aSelector);
    if([selectorName isEqualToString:@"tableView:heightForRowAtIndexPath:"] && self.targetTableView.heightForRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:heightForHeaderInSection:"] && self.targetTableView.heightForHeaderInSection.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:heightForFooterInSection:"] && self.targetTableView.heightForFooterInSection.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:viewForFooterInSection:"] && self.targetTableView.viewForFooterInSection.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:viewForHeaderInSection:"] && self.targetTableView.viewForHeaderInSection.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:shouldHighlightRowAtIndexPath:"] && self.targetTableView.shouldHighlightRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:willSelectRowAtIndexPath:"] && self.targetTableView.willSelectRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:willDeselectRowAtIndexPath:"] && self.targetTableView.willDeselectRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:editingStyleForRowAtIndexPath:"]
             && self.targetTableView.editingStyleForRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:"]
             && self.targetTableView.titleForDeleteConfirmationButtonForRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:shouldIndentWhileEditingRowAtIndexPath:"]
             && self.targetTableView.shouldIndentWhileEditingRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:"]
             && self.targetTableView.targetIndexPathForMoveFromRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:indentationLevelForRowAtIndexPath:"]
             && self.targetTableView.indentationLevelForRowAtIndexPath.length == 0){
        return NO;
    }else if([selectorName isEqualToString:@"tableView:shouldShowMenuForRowAtIndexPath:"]
             && self.targetTableView.shouldShowMenuForRowAtIndexPath.length == 0){
        return NO;
    }
    BOOL responds = class_respondsToSelector(self.class, aSelector);
    return responds;
}

@end

@interface LITableView ()

@property(nonatomic, retain)TableViewDataSourceProxy *dataSourceProxy;
@property(nonatomic, retain)TableViewDelegateProxy *delegateProxy;

@end

@implementation LITableView

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
    LITableView *tmp = [[LITableView alloc] initWithFrame:CGRectZero style:style];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

+ (NSString *)create:(NSString *)appId
{
    return [self create:appId style:UITableViewStylePlain];
}

@end
