//
//  GridViewTableViewHelper.m
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "GridViewTableViewHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface GridViewTableViewHelper ()

@property(nonatomic, copy)NSString *identifier;

@end

@implementation GridViewTableViewHelper

- (void)dealloc
{
    self.gridViewIcons = nil;
    self.identifier = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)init
{
    self = [self initWithNumberOfColumns:4];
    
    return self;
}

- (id)initWithNumberOfColumns:(NSInteger)columns
{
    self = [super init];
    
    self.numberOfColumns = columns;
    [self updateIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    return self;
}

- (void)updateIdentifier
{
    static NSString *identifierForLandscapeScreen = @"landscape";
    static NSString *identifierForPortrait = @"portrait";
    self.identifier = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? identifierForLandscapeScreen : identifierForPortrait;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_iconHeight == 0){
        _iconHeight = 80.0f;
    }
    return _iconHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_iconWidth == 0){
        _iconWidth = CGRectGetWidth(tableView.frame) / self.numberOfColumns;
    }
    if(self.forceSquare){
        _iconWidth = CGRectGetWidth(tableView.frame) / self.numberOfColumns;
        _iconHeight = _iconWidth;
    }
    NSInteger numberOfRows = self.gridViewIcons.count / self.numberOfColumns;
    if(self.gridViewIcons.count % self.numberOfColumns != 0){
        ++numberOfRows;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat spacingWidth = 0;
        if(!self.forceSquare && _numberOfColumns > 1){
            spacingWidth = (CGRectGetWidth(tableView.frame) - _numberOfColumns * _iconWidth) / (_numberOfColumns - 1);
        }
        
        for(NSInteger i = 0; i < self.numberOfColumns; ++i){
            UIView *view = [[[UIView alloc] init] autorelease];
            view.frame = CGRectMake((spacingWidth + _iconWidth) * i, 0, _iconWidth, _iconHeight);
            view.layer.borderWidth = 1.0f;
            view.layer.borderColor = [UIColor whiteColor].CGColor;
            view.backgroundColor = [UIColor blackColor];
            
            [cell.contentView addSubview:view];
        }
    }
    
    return cell;
}

#pragma mark - events
- (void)deviceOrientationDidChangeNotification:(NSNotification *)n
{
    if([UIDevice currentDevice].orientation != UIDeviceOrientationPortraitUpsideDown){
        [self updateIdentifier];
    }
}

@end
