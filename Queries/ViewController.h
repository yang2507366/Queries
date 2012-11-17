//
//  ViewController.h
//  Queries
//
//  Created by yangzexin on 11/17/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"

@interface ViewController : UIViewController <LuaImplentatable>

@property(nonatomic, copy)NSString *_loadView;
@property(nonatomic, copy)NSString *_viewDidLoad;
@property(nonatomic, copy)NSString *_viewWillAppear;
@property(nonatomic, copy)NSString *_viewDidAppear;
@property(nonatomic, copy)NSString *_viewWillDisappear;
@property(nonatomic, copy)NSString *_viewDidDisappear;
@property(nonatomic, copy)NSString *_viewDidPop;
@property(nonatomic, copy)NSString *_didReceiveMemoryWarning;
@property(nonatomic, copy)NSString *_shouldAutorotate;
@property(nonatomic, copy)NSString *_supportedInterfaceOrientations;

@end
