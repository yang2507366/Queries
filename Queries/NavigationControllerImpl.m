//
//  NavigationControllerImpl.m
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "NavigationControllerImpl.h"
#import "LuaGroupedObjectManager.h"

@implementation NavigationControllerImpl

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    [super dealloc];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    
    return viewController;
}

+ (NSString *)createNavigationControllerWithScriptId:(NSString *)scriptId
                                                  si:(id<ScriptInteraction>)si
                                rootViewControllerId:(NSString *)rootViewControllerId
{
    id rootViewController = [LuaGroupedObjectManager objectWithId:rootViewControllerId group:scriptId];
    if(rootViewController){
        NavigationControllerImpl *impl = [[[NavigationControllerImpl alloc] initWithRootViewController:rootViewController] autorelease];
        
        return [LuaGroupedObjectManager addObject:impl group:scriptId];
    }else{
        D_Log(@"create navigationController error, null rootViewController:%@", rootViewControllerId);
    }
    return nil;
}

@end
