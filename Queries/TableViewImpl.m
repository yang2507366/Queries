//
//  TableViewImpl.m
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "TableViewImpl.h"
#import "LuaGroupedObjectManager.h"

@interface TableViewImpl () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TableViewImpl

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    self.dataSource = self;
    self.delegate = self;
    
    return self;
}

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    self.numberOfRowsBlock = nil;
    self.wrapCellBlock = nil;
    self.didSelectCellBlock = nil;
    [super dealloc];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.didSelectCellBlock){
        self.didSelectCellBlock(indexPath.row);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.numberOfRowsBlock){
        return self.numberOfRowsBlock();
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    if(self.wrapCellBlock){
        self.wrapCellBlock(cell, indexPath.row);
    }
    return cell;
}

+ (NSString *)createTableViewWithScriptId:(NSString *)scriptId
                                       si:(id<ScriptInteraction>)si
                                    frame:(CGRect)frame
                         numberOfRowsFunc:(NSString *)numberOfRowsFunc
                             wrapCellFunc:(NSString *)wrapCellFunc
                            didSelectFunc:(NSString *)didSelectFunc
{
    TableViewImpl *impl = [[[TableViewImpl alloc] initWithFrame:frame style:UITableViewStylePlain] autorelease];
    impl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [impl setNumberOfRowsBlock:^NSInteger{
        NSString *numOfRows = [si callFunction:numberOfRowsFunc parameters:nil];
        return [numOfRows intValue];
    }];
    [impl setWrapCellBlock:^(UITableViewCell *cell, NSInteger index) {
        NSString *cellId = [LuaGroupedObjectManager containsObject:cell group:scriptId];
        if(!cellId){
            cellId = [LuaGroupedObjectManager addObject:cell group:scriptId];
        }
        [si callFunction:wrapCellFunc parameters:cellId, [NSString stringWithFormat:@"%d", index], nil];
    }];
    [impl setDidSelectCellBlock:^(NSInteger index) {
        [si callFunction:didSelectFunc parameters:[NSString stringWithFormat:@"%d", index], nil];
    }];
    
    return [LuaGroupedObjectManager addObject:impl group:scriptId];
}

@end
