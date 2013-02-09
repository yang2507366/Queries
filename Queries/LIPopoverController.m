//
//  LIPopoverController.m
//  Queries
//
//  Created by yangzexin on 2/9/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "LIPopoverController.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface LIPopoverController () <UIPopoverControllerDelegate>

@end

@implementation LIPopoverController

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    self.shouldDismiss = nil;
    self.didDismiss = nil;
    [super dealloc];
}

- (id)initWithContentViewController:(UIViewController *)viewController
{
    self = [super initWithContentViewController:viewController];
    
    self.delegate = self;
    
    return self;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    if(self.shouldDismiss.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.shouldDismiss parameters:self.objId, nil];
    }
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if(self.didDismiss.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.didDismiss parameters:self.objId, nil];
    }
}

+ (NSString *)create:(NSString *)appId
{
    return nil;
}

+ (NSString *)create:(NSString *)appId contentViewController:(UIViewController *)contentViewController
{
    LIPopoverController *tmp = [[[LIPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
