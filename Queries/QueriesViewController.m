//
//  QueriesViewController.m
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "QueriesViewController.h"
#import "GridViewTableViewHelper.h"
#import "GridViewIcon.h"

@implementation QueriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GridViewTableViewHelper *gridHelper = [[GridViewTableViewHelper alloc] initWithNumberOfColumns:4];
    NSArray *gridViewIcons = [NSArray arrayWithObjects:[[[GridViewIcon alloc] initWithTitle:@"Grid1" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid2" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid3" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid4" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid5" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid1" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid1" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid1" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid1" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid1" icon:nil] autorelease],
                              [[[GridViewIcon alloc] initWithTitle:@"Grid1" icon:nil] autorelease],
                              nil];
    gridHelper.gridViewIcons = gridViewIcons;
    gridHelper.iconWidth = 50.0f;
    gridHelper.forceSquare = NO;
    
    self.tableView.delegate = gridHelper;
    self.tableView.dataSource = gridHelper;
}

- (BOOL)shouldAutorotate
{
    if([UIDevice currentDevice].orientation != UIDeviceOrientationPortraitUpsideDown){
        [self.tableView reloadData];
    }
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
