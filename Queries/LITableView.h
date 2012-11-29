//
//  TableView.h
//  Queries
//
//  Created by yangzexin on 11/13/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"

@interface LITableView : UITableView <LuaImplentatable>

+ (NSString *)create:(NSString *)appId style:(UITableViewCellStyle)style;

@property(nonatomic, copy)NSString *numberOfRowsInSection;
@property(nonatomic, copy)NSString *cellForRowAtIndexPath;
@property(nonatomic, copy)NSString *numberOfSections;
@property(nonatomic, copy)NSString *titleForHeaderInSection;
@property(nonatomic, copy)NSString *titleForFooterInSection;
@property(nonatomic, copy)NSString *canEditRowAtIndexPath;
@property(nonatomic, copy)NSString *canMoveRowAtIndexPath;
@property(nonatomic, copy)NSString *sectionIndexTitles;
@property(nonatomic, copy)NSString *sectionForSectionIndexTitle;
@property(nonatomic, copy)NSString *commitEditingStyle;
@property(nonatomic, copy)NSString *moveRowAtIndexPath;

@property(nonatomic, copy)NSString *willDisplayCell;
@property(nonatomic, copy)NSString *willDisplayHeaderView;
@property(nonatomic, copy)NSString *willDisplayFooterView;
@property(nonatomic, copy)NSString *didEndDisplayingCell;
@property(nonatomic, copy)NSString *didEndDisplayingHeaderView;
@property(nonatomic, copy)NSString *didEndDisplayingFooterView;
@property(nonatomic, copy)NSString *heightForRowAtIndexPath;
@property(nonatomic, copy)NSString *heightForHeaderInSection;
@property(nonatomic, copy)NSString *heightForFooterInSection;
@property(nonatomic, copy)NSString *viewForHeaderInSection;
@property(nonatomic, copy)NSString *viewForFooterInSection;
@property(nonatomic, copy)NSString *accessoryTypeForRowWithIndexPath;
@property(nonatomic, copy)NSString *accessoryButtonTappedForRowWithIndexPath;
@property(nonatomic, copy)NSString *shouldHighlightRowAtIndexPath;
@property(nonatomic, copy)NSString *didHighlightRowAtIndexPath;
@property(nonatomic, copy)NSString *didUnhighlightRowAtIndexPath;
@property(nonatomic, copy)NSString *willSelectRowAtIndexPath;
@property(nonatomic, copy)NSString *willDeselectRowAtIndexPath;
@property(nonatomic, copy)NSString *didSelectRowAtIndexPath;
@property(nonatomic, copy)NSString *didDeselectRowAtIndexPath;
@property(nonatomic, copy)NSString *editingStyleForRowAtIndexPath;
@property(nonatomic, copy)NSString *titleForDeleteConfirmationButtonForRowAtIndexPath;
@property(nonatomic, copy)NSString *shouldIndentWhileEditingRowAtIndexPath;
@property(nonatomic, copy)NSString *willBeginEditingRowAtIndexPath;
@property(nonatomic, copy)NSString *didEndEditingRowAtIndexPath;
@property(nonatomic, copy)NSString *targetIndexPathForMoveFromRowAtIndexPath;
@property(nonatomic, copy)NSString *indentationLevelForRowAtIndexPath;
@property(nonatomic, copy)NSString *shouldShowMenuForRowAtIndexPath;
@property(nonatomic, copy)NSString *canPerformAction;
@property(nonatomic, copy)NSString *performAction;

@end
