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
#import "LuaSystemContext.h"
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
    [LuaSystemContext currentWindow].rootViewController = vc;
}

+ (void)addSubViewWithViewId:(NSString *)viewId viewControllerId:(NSString *)viewControllerId scriptId:(NSString *)scriptId
{
    UIViewController *targetVC = [self getObjectWithObjectId:viewControllerId group:scriptId];
    if([targetVC isKindOfClass:[UIViewController class]]){
        UIView *targetView = [self getObjectWithObjectId:viewId group:scriptId];
        [targetVC.view addSubview:targetView];
    }else{
        D_Log(@"not UIViewController:%@", viewControllerId);
    }
}

+ (void)pushViewControlerToNaviationControllerWithScriptId:(NSString *)scriptId
                                          viewControllerId:(NSString *)vcId
                                    navigationControllerId:(NSString *)ncId
                                                  animated:(BOOL)animated
{
    UIViewController *vc = [LuaGroupedObjectManager objectWithId:vcId group:scriptId];
    UINavigationController *nc= [LuaGroupedObjectManager objectWithId:ncId group:scriptId];
    if([vc isKindOfClass:[UIViewController class]] && [nc isKindOfClass:[UINavigationController class]]){
        [nc pushViewController:vc animated:animated];
    }
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

+ (CGRect)boundsOfViewWithViewId:(NSString *)viewId scriptId:(NSString *)scriptId
{
    UIView *view = [self getObjectWithObjectId:viewId group:scriptId];
    return view.bounds;
}

+ (NSString *)viewForTagWithScriptId:(NSString *)scriptId viewId:(NSString *)viewId tag:(NSInteger)tag
{
    UIView *view = [self getObjectWithObjectId:viewId group:scriptId];
    
    if([view isKindOfClass:[UIView class]]){
        UIView *targetView = [view viewWithTag:tag];
        if(targetView){
            return [LuaGroupedObjectManager addObject:targetView group:scriptId];
        }
    }
    
    return @"";
}

+ (void)addSubviewToViewWithScriptId:(NSString *)scriptId viewId:(NSString *)viewId toViewId:(NSString *)toViewId
{
    UIView *view = [self getObjectWithObjectId:viewId group:scriptId];
    UIView *toView = [self getObjectWithObjectId:toViewId group:scriptId];
    if(view && toView && [view isKindOfClass:[UIView class]] && [toView isKindOfClass:[UIView class]]){
        [toView addSubview:view];
    }
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName
{
    [DialogTools dialogWithTitle:title message:msg completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        if(funcName.length != 0){
            [si callFunction:funcName callback:nil parameters:nil];
        }
    } cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end
