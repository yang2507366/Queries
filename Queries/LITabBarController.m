//
//  LITabViewController.m
//  Queries
//
//  Created by yangzexin on 1/17/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "LITabBarController.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface LITabBarController () <UITabBarControllerDelegate>

@end

@implementation LITabBarController

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    self.shouldSelectViewController = nil;
    self.didSelectViewController = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.delegate = self;
    
    return self;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(self.didSelectViewController.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.didSelectViewController parameters:self.objId, nil];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(self.shouldSelectViewController.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.shouldSelectViewController parameters:self.objId, nil] boolValue];
    }
    return YES;
}

+ (NSString *)create:(NSString *)appId
{
    LITabBarController *tmp = [[LITabBarController new] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
