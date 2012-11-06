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
#import "LuaAppContext.h"
#import "DialogTools.h"

@interface AppRunnerViewController ()

@property(nonatomic, retain)UITextView *urlTextView;

@end

@implementation AppRunnerViewController

- (void)dealloc
{
    self.urlTextView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"AppRunner";
    self.view.backgroundColor = [UIColor blackColor];
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loadBtn.frame = CGRectMake(5, 5, self.view.frame.size.width - 10, 40);
    [loadBtn setTitle:@"加载软件" forState:UIControlStateNormal];
    [loadBtn addTarget:self action:@selector(onLoadBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];
    self.urlTextView = [[[UITextView alloc] initWithFrame:CGRectMake(5, 50, self.view.frame.size.width - 10, 100)] autorelease];
    _urlTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _urlTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _urlTextView.text = @"http://imyvoaspecial.googlecode.com/files/";
    [self.view addSubview:_urlTextView];
}

- (void)onLoadBtnTapped
{
    OnlineAppBundleLoader *loader = [[[OnlineAppBundleLoader alloc] initWithURLString:_urlTextView.text] autorelease];
    [loader loadWithCompletion:^(NSString *filePath) {
        NSLog(@"%@", filePath);
        if(filePath.length == 0){
            [DialogTools dialogWithTitle:@"" message:@"加载失败，请检查输入的URL地址" completion:nil cancelButtonTitle:@"确定" otherButtonTitleList:nil];
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
        [LuaAppContext runRootApp:app];
    }];
    [ProviderPool addProviderToSharedPool:loader identifier:@"root_app_loader"];
}

@end
