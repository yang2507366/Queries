//
//  ViewControllerManager.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "UIRelatedImpl.h"
#import "Singleton.h"
#import "DialogTools.h"
#import "LuaApplication.h"
#import "EventProxy.h"
#import "LuaGroupedObjectManager.h"

@implementation UIRelatedImpl

+ (NSString *)addObject:(id)object group:(NSString *)group
{
    return [LuaGroupedObjectManager addObject:object group:group];
}

+ (id)getObjectWithObjectId:(NSString *)objectId group:(NSString *)group
{
    return [LuaGroupedObjectManager objectWithId:objectId group:group];
}

+ (void)setRootViewControllerWithId:(NSString *)viewControllerId scriptId:(NSString *)scriptId
{
    UIViewController *vc = [self getObjectWithObjectId:viewControllerId group:scriptId];
    [LuaApplication window].rootViewController = vc;
}

+ (void)addSubViewWithViewId:(NSString *)viewId viewControllerId:(NSString *)viewControllerId scriptId:(NSString *)scriptId
{
    UIViewController *targetVC = [self getObjectWithObjectId:viewControllerId group:scriptId];
    [targetVC.view addSubview:[self getObjectWithObjectId:viewId group:scriptId]];
}

+ (void)pushViewControllerWithId:(NSString *)viewControllerId sourceViewControllerId:(NSString *)sourceViewControllerId scriptId:(NSString *)scriptId
{
    
}

+ (void)setViewFrameWithViewId:(NSString *)viewId frame:(NSString *)frame scriptId:(NSString *)scriptId
{
    UIView *view = [self getObjectWithObjectId:viewId group:scriptId];
    NSArray *frameInfo = [frame componentsSeparatedByString:@","];
    if(view && frameInfo.count == 4){
        CGRect tmpRect = CGRectMake([frameInfo[0] floatValue], [frameInfo[1] floatValue], [frameInfo[2] floatValue], [frameInfo[3] floatValue]);
        view.frame = tmpRect;
    }
}

+ (CGRect)frameOfViewWithViewId:(NSString *)viewId scriptId:(NSString *)scriptId
{
    UIView *view = [self getObjectWithObjectId:viewId group:scriptId];
    return view.frame;
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName
{
    [DialogTools dialogWithTitle:title message:msg completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        [si callFunction:funcName callback:nil parameters:nil];
    } cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end
