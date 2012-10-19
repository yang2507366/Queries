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
@property(nonatomic, assign)BOOL forceSquare;
@property(nonatomic, assign)CGFloat iconWidth;
@property(nonatomic, assign)CGFloat iconHeight;

@end

@implementation GridViewTableViewHelper

- (void)dealloc
{
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
    
    self.forceSquare = YES;
    _numberOfColumns = columns;
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
    self.identifier = [NSString stringWithFormat:@"%@%@", self, self.identifier];
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
    if([self.delegate respondsToSelector:@selector(numberOfItemsOfGridViewTableViewHelper:)]){
        NSInteger numberOfIcons = [self.delegate numberOfItemsOfGridViewTableViewHelper:self];
        if(_iconWidth == 0){
            _iconWidth = CGRectGetWidth(tableView.frame) / self.numberOfColumns;
        }
        if(self.forceSquare){
            _iconWidth = CGRectGetWidth(tableView.frame) / self.numberOfColumns;
            _iconHeight = _iconWidth;
        }
        NSInteger numberOfRows = numberOfIcons / self.numberOfColumns;
        if(numberOfIcons % self.numberOfColumns != 0){
            ++numberOfRows;
        }
        return numberOfRows;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.multipleTouchEnabled = NO;
        
        CGFloat spacingWidth = 0;
        if(!self.forceSquare && _numberOfColumns > 1){
            spacingWidth = (CGRectGetWidth(tableView.frame) - _numberOfColumns * _iconWidth) / (_numberOfColumns - 1);
        }
        
        for(NSInteger i = 0; i < self.numberOfColumns; ++i){
            UIView *view = [[[UIView alloc] init] autorelease];
            view.frame = CGRectMake((spacingWidth + _iconWidth) * i, 0, _iconWidth, _iconHeight);
            view.backgroundColor = [UIColor clearColor];
            view.tag = i;
            
            [cell.contentView addSubview:view];
        }
    }
    NSInteger tmpNumOfColumns = _numberOfColumns;
    if([self.delegate respondsToSelector:@selector(gridViewTableViewHelper:configureView:atIndex:)]){
        if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1
           && [self.delegate numberOfItemsOfGridViewTableViewHelper:self] % _numberOfColumns != 0){
            tmpNumOfColumns = [self.delegate numberOfItemsOfGridViewTableViewHelper:self] % _numberOfColumns;
        }
        NSArray *subviews = [cell.contentView subviews];
        for(NSInteger i = 0; i < tmpNumOfColumns; ++i){
            UIView *view = [subviews objectAtIndex:i];
            view.hidden = NO;
            [self.delegate gridViewTableViewHelper:self configureView:view atIndex:indexPath.row * _numberOfColumns + view.tag];
        }
        if(tmpNumOfColumns < _numberOfColumns){
            for(NSInteger i = tmpNumOfColumns; i < _numberOfColumns; ++i){
                UIView *view = [subviews objectAtIndex:i];
                view.hidden = YES;
            }
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
