//
//  NavigationController.m
//  Queries
//
//  Created by yangzexin on 11/17/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LINavigationController.h"
#import "LuaObjectManager.h"

@implementation LINavigationController

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    [super dealloc];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    id viewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
    if([viewController respondsToSelector:@selector(viewDidPop)]){
        [viewController performSelector:@selector(viewDidPop)];
    }
    return [super popViewControllerAnimated:animated];
}

+ (NSString *)create:(NSString *)appId
{
    LINavigationController *nc = [[LINavigationController new] autorelease];
    nc.appId = appId;
    nc.objId = [LuaObjectManager addObject:nc group:appId];
    
    return nc.objId;
}

@end
