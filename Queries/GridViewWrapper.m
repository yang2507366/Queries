//
//  GridViewTableViewHelper.m
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "GridViewWrapper.h"
#import <QuartzCore/QuartzCore.h>

@interface UITapGestureRecognizerBlocked : UITapGestureRecognizer

@property(nonatomic, copy)void(^callback)(UITapGestureRecognizerBlocked *);

@end

@implementation UITapGestureRecognizerBlocked

@synthesize callback;

- (void)dealloc
{
    self.callback = nil;
    [super dealloc];
}

- (id)initWithCallback:(void(^)(UITapGestureRecognizerBlocked *))pCallback
{
    self = [super initWithTarget:nil action:nil];
    
    self.callback = pCallback;
    
    [self addTarget:self action:@selector(tapped:)];
    
    return self;
}

- (void)tapped:(UITapGestureRecognizerBlocked *)tapGestureRecognizerBlocked
{
    if(self.callback){
        self.callback(self);
    }
}

@end

@interface GridViewWrapper ()

@property(nonatomic, copy)NSString *identifier;
@property(nonatomic, assign)BOOL forceSquare;
@property(nonatomic, assign)CGFloat iconWidth;
@property(nonatomic, assign)CGFloat iconHeight;

@end

@implementation GridViewWrapper

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.delegate respondsToSelector:@selector(numberOfItemsInGridViewWrapper:)]){
        NSInteger numberOfIcons = [self.delegate numberOfItemsInGridViewWrapper:self];
        if(_iconWidth == 0){
            _iconWidth = CGRectGetWidth(tableView.frame) / self.numberOfColumns;
        }
        if(self.forceSquare){
            _iconWidth = CGRectGetWidth(tableView.frame) / self.numberOfColumns;
            _iconHeight = _iconWidth;
        }
        tableView.rowHeight = _iconHeight;
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
    if([self.delegate respondsToSelector:@selector(gridViewWrapper:configureView:atIndex:)]){
        if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1
           && [self.delegate numberOfItemsInGridViewWrapper:self] % _numberOfColumns != 0){
            tmpNumOfColumns = [self.delegate numberOfItemsInGridViewWrapper:self] % _numberOfColumns;
        }
        NSArray *subviews = [cell.contentView subviews];
        for(NSInteger i = 0; i < tmpNumOfColumns; ++i){
            UIView *view = [subviews objectAtIndex:i];
            NSInteger index = indexPath.row * _numberOfColumns + view.tag;
            view.hidden = NO;
            for(UIGestureRecognizer *tmp in view.gestureRecognizers){
                [view removeGestureRecognizer:tmp];
            }
            __block typeof(self) bself = self;
            [view addGestureRecognizer:[[[UITapGestureRecognizerBlocked alloc] initWithCallback:^(UITapGestureRecognizerBlocked *tapGe) {
                if([bself.delegate respondsToSelector:@selector(gridViewWrapper:viewItemTappedAtIndex:)]){
                    [bself.delegate gridViewWrapper:bself viewItemTappedAtIndex:index];
                }
            }] autorelease]];
            [self.delegate gridViewWrapper:self configureView:view atIndex:index];
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
