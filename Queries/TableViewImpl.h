//
//  TableViewImpl.h
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface TableViewImpl : UITableView

@property(nonatomic, copy)NSInteger(^numberOfRowsBlock)();
@property(nonatomic, copy)void(^wrapCellBlock)(UITableViewCell *cell, NSInteger index);
@property(nonatomic, copy)void(^didSelectCellBlock)(NSInteger index);

+ (NSString *)createTableViewWithScriptId:(NSString *)scriptId
                                       si:(id<ScriptInteraction>)si
                                    frame:(CGRect)frame
                         numberOfRowsFunc:(NSString *)numberOfRowsFunc
                             wrapCellFunc:(NSString *)wrapCellFunc
                            didSelectFunc:(NSString *)didSelectFunc;

@end
