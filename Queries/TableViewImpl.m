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
    self.heightForRowBlock = nil;
    [super dealloc];
}

//- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
//{
//    id cell = [super dequeueReusableCellWithIdentifier:identifier];
//    NSLog(@"cell:%@, %@", identifier, cell);
//    return cell;
//}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.didSelectCellBlock){
        self.didSelectCellBlock(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.heightForRowBlock){
        return self.heightForRowBlock(indexPath.row);
    }
    return tableView.rowHeight;
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
    if(self.wrapCellBlock){
        return self.wrapCellBlock(indexPath.row);
    }
    static NSString *identifier = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    return cell;
}

+ (NSString *)createTableViewWithScriptId:(NSString *)scriptId
                                       si:(id<ScriptInteraction>)si
                                    frame:(CGRect)frame
                         numberOfRowsFunc:(NSString *)numberOfRowsFunc
                             wrapCellFunc:(NSString *)wrapCellFunc
                            didSelectFunc:(NSString *)didSelectFunc
                         heightForRowFunc:(NSString *)heightForRowFunc
{
    TableViewImpl *impl = [[[TableViewImpl alloc] initWithFrame:frame style:UITableViewStylePlain] autorelease];
    impl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSString *tableViewId = [LuaGroupedObjectManager addObject:impl group:scriptId];
    [impl setNumberOfRowsBlock:^NSInteger{
        NSString *numOfRows = [si callFunction:numberOfRowsFunc parameters:tableViewId, nil];
        return [numOfRows intValue];
    }];
    [impl setWrapCellBlock:^UITableViewCell *(NSInteger index) {
        NSString *cellId = [si callFunction:wrapCellFunc parameters:tableViewId, [NSString stringWithFormat:@"%d", index], nil];;
        
        return [LuaGroupedObjectManager objectWithId:cellId group:scriptId];
    }];
    [impl setDidSelectCellBlock:^(NSInteger index) {
        [si callFunction:didSelectFunc parameters:tableViewId, [NSString stringWithFormat:@"%d", index], nil];
    }];
    [impl setHeightForRowBlock:^CGFloat(NSInteger index) {
        NSString *height = [si callFunction:heightForRowFunc parameters:tableViewId, [NSString stringWithFormat:@"%d", index], nil];
        CGFloat hei = [height floatValue];

        return hei;
    }];
    
    return tableViewId;
}

@end
