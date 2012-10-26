//
//  NavigationControllerImpl.m
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "NavigationControllerImpl.h"
#import "LuaGroupedObjectManager.h"
#import "ViewControllerImpl.h"

@interface NavigationControllerImpl ()

@property(nonatomic, copy)NSString *scriptId;

@end

@implementation NavigationControllerImpl

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    self.scriptId = nil;
    [super dealloc];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *viewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
    if([viewController isKindOfClass:[ViewControllerImpl class]]){
        ViewControllerImpl *impl = (id)viewController;
        [impl viewDidPopFromNavigationController];
    }
    return [super popViewControllerAnimated:animated];
}

+ (NSString *)createNavigationControllerWithScriptId:(NSString *)scriptId
                                                  si:(id<ScriptInteraction>)si
                                rootViewControllerId:(NSString *)rootViewControllerId
{
    id rootViewController = [LuaGroupedObjectManager objectWithId:rootViewControllerId group:scriptId];
    if(rootViewController){
        NavigationControllerImpl *impl = [[[NavigationControllerImpl alloc] initWithRootViewController:rootViewController] autorelease];
        impl.scriptId = scriptId;
        return [LuaGroupedObjectManager addObject:impl group:scriptId];
    }else{
        D_Log(@"create navigationController error, null rootViewController:%@", rootViewControllerId);
    }
    return nil;
}

@end
