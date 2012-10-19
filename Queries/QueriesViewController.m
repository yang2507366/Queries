//
//  QueriesViewController.m
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "QueriesViewController.h"
#import "GridViewTableViewHelper.h"

@interface QueriesViewController () <GridViewTableViewHelperDelegate>

@property(nonatomic, retain)GridViewTableViewHelper *gridHelper;
@property(nonatomic, retain)GridViewTableViewHelper *gridHelperLandscape;

@end

@implementation QueriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridHelper = [[[GridViewTableViewHelper alloc] initWithNumberOfColumns:2] autorelease];
    self.gridHelper.delegate = self;
    
    self.gridHelperLandscape = [[[GridViewTableViewHelper alloc] initWithNumberOfColumns:3] autorelease];
    self.gridHelperLandscape.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[[UIView alloc] init] autorelease];
    self.tableView.multipleTouchEnabled = NO;
}

- (BOOL)shouldAutorotate
{
    if([UIDevice currentDevice].orientation != UIDeviceOrientationPortraitUpsideDown){
        self.tableView.delegate = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.gridHelperLandscape : self.gridHelper;
        self.tableView.dataSource = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.gridHelperLandscape : self.gridHelper;
        [self.tableView reloadData];
    }

    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - events
- (void)onBtnTapped:(UIButton *)btn
{
    NSLog(@"%@", btn.currentTitle);
}

#pragma mark - GridViewTableViewHelperDelegate
- (NSInteger)numberOfItemsOfGridViewTableViewHelper:(GridViewTableViewHelper *)gridViewTableViewHelper
{
    return 30000;
}

- (void)gridViewTableViewHelper:(GridViewTableViewHelper *)gridViewTableViewHelper configureView:(UIView *)view atIndex:(NSInteger)index
{
    UILabel *label = (id)[view viewWithTag:1001];
    UIButton *btn = (id)[view viewWithTag:1002];
    if(!label){
        label = [[[UILabel alloc] init] autorelease];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.frame = CGRectMake(0, 0, view.frame.size.width, label.font.lineHeight);
        label.tag = 1001;
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        btn.tag = 1002;
        [btn addTarget:self action:@selector(onBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
        [view addSubview:btn];
    }
    label.text = [NSString stringWithFormat:@"%d", index + 1];
    [btn setTitle:label.text forState:UIControlStateNormal];
}

@end
