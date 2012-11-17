//
//  ViewController.m
//  Queries
//
//  Created by yangzexin on 11/17/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ViewController.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@implementation ViewController

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    self._loadView = nil;
    self._viewDidLoad = nil;
    self._viewWillAppear = nil;
    self._viewDidAppear = nil;
    self._viewWillDisappear = nil;
    self._viewDidDisappear = nil;
    self._viewDidPop = nil;
    self._didReceiveMemoryWarning = nil;
    self._shouldAutorotate = nil;
    self._supportedInterfaceOrientations = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    if(self._loadView.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._loadView parameters:self.objId, nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self._viewDidLoad.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._viewDidLoad parameters:self.objId, nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self._viewWillAppear.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._viewWillAppear parameters:self.objId, nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self._viewDidAppear.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._viewDidAppear parameters:self.objId, nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self._viewWillDisappear.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._viewWillDisappear parameters:self.objId, nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(self._viewDidDisappear.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._viewDidDisappear parameters:self.objId, nil];
    }
}

- (void)viewDidPop
{
    if(self._viewDidPop.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._viewDidPop parameters:self.objId, nil];
    }
}

- (void)didReceiveMemoryWarning
{
    if(self._didReceiveMemoryWarning.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._didReceiveMemoryWarning parameters:self.objId, nil];
    }
}

- (BOOL)shouldAutorotate
{
    if(self._shouldAutorotate.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self._shouldAutorotate parameters:self.objId, nil] boolValue];
    }
    return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if(self._supportedInterfaceOrientations.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.appId]
                 callFunction:self._supportedInterfaceOrientations parameters:self.objId, nil] intValue];
    }
    return [super supportedInterfaceOrientations];
}

+ (NSString *)create:(NSString *)appId
{
    ViewController *vc = [[[ViewController alloc] init] autorelease];
    vc.appId = appId;
    vc.objId = [LuaObjectManager addObject:vc group:appId];
    
    return vc.objId;
}

@end
