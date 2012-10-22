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
    NSLog(@"%@ dealloc", self);
    [super dealloc];
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
        NSLog(@"create navigationController error, null rootViewController:%@", rootViewControllerId);
    }
    return nil;
}

@end
