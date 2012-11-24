//
//  AppRunnerViewController.m
//  Queries
//
//  Created by yangzexin on 11/6/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "AppRunnerViewController.h"
#import "OnlineAppBundleLoader.h"
#import "LuaApp.h"
#import "ZipArchive.h"
#import "LocalAppBundle.h"
#import "LuaAppManager.h"
#import "DialogTools.h"
#import "Waiting.h"
#import <QuartzCore/QuartzCore.h>

@interface AppRunnerViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property(nonatomic, retain)NSDictionary *appDict;
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)UITextView *urlTextView;

@end

@implementation AppRunnerViewController

- (void)dealloc
{
    self.tableView = nil;
    self.urlTextView = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.appDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"http://imyvoaspecial.googlecode.com/files/quires1.1.zip", @"快捷查询",
                    @"http://imyvoaspecial.googlecode.com/files/t2.1.zip", @"Google翻译",
                    nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"AppRunner";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 180)] autorelease];
    self.tableView.tableHeaderView = headerView;
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loadBtn.frame = CGRectMake(5, 5, self.view.frame.size.width - 10, 40);
    [loadBtn setTitle:@"加载软件" forState:UIControlStateNormal];
    [loadBtn addTarget:self action:@selector(loadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:loadBtn];
    self.urlTextView = [[[UITextView alloc] initWithFrame:CGRectMake(5, 50, self.view.frame.size.width - 10, 100)] autorelease];
    _urlTextView.backgroundColor = [UIColor darkGrayColor];
    _urlTextView.textColor = [UIColor whiteColor];
    _urlTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _urlTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _urlTextView.text = @"http://imyvoaspecial.googlecode.com/files/";
    _urlTextView.font = [UIFont boldSystemFontOfSize:16.0f];
    _urlTextView.delegate = self;
    _urlTextView.layer.cornerRadius = 7.0f;
    [headerView addSubview:_urlTextView];
}

#pragma mark - private methods
- (void)loadWithURLString:(NSString *)urlString
{
    [Waiting showWaiting:YES inView:self.view];
    OnlineAppBundleLoader *loader = [[[OnlineAppBundleLoader alloc] initWithURLString:urlString] autorelease];
    [loader loadWithCompletion:^(NSString *filePath) {
        [Waiting showWaiting:NO inView:self.view];
        if(filePath.length == 0){
            [DialogTools showWithTitle:@"" message:@"加载失败，请检查输入的URL地址" completion:nil cancelButtonTitle:@"确定" otherButtonTitleList:nil];
            return;
        }
        ZipArchive *zipAr = [[[ZipArchive alloc] init] autorelease];
        [zipAr UnzipOpenFile:filePath];
        NSString *targetPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [filePath lastPathComponent]];
        [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:NO attributes:nil error:nil];
        [zipAr UnzipFileTo:targetPath overWrite:YES];
        [zipAr UnzipCloseFile];
        LocalAppBundle *appBundle = [[[LocalAppBundle alloc] initWithDirectory:targetPath] autorelease];
        LuaApp *app = [[[LuaApp alloc] initWithScriptBundle:appBundle baseWindow:nil] autorelease];
        app.relatedViewController = self;
        [LuaAppManager runRootApp:app];
    }];
    [ProviderPool addProviderToSharedPool:loader identifier:@"root_app_loader"];
}

#pragma mark - events
- (void)closeKeyboardButtonTapped
{
    [self.urlTextView resignFirstResponder];
}

- (void)loadButtonTapped
{
    [self loadWithURLString:_urlTextView.text];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(closeKeyboardButtonTapped)] autorelease];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self loadWithURLString:[self.appDict objectForKey:[[self.appDict allKeys] objectAtIndex:indexPath.row]]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = [[self.appDict allKeys] objectAtIndex:indexPath.row];
    return cell;
}

@end
