//
//  ViewControllerManager.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaUIRelatedImpl.h"
#import "Singleton.h"
#import "DialogTools.h"
#import "ViewControllerImpl.h"
#import "LuaApplication.h"
#import "LuaRelatedObjectManager.h"
#import "EventProxy.h"

@implementation LuaUIRelatedImpl

+ (NSString *)addControl:(id)control
{
    return [LuaRelatedObjectManager addObject:control];
}

+ (id)controlWithId:(NSString *)controlId
{
    return [LuaRelatedObjectManager objectForId:controlId];
}

+ (void)setRootViewControllerWithId:(NSString *)viewControllerId
{
    UIViewController *vc = [self controlWithId:viewControllerId];
    [LuaApplication window].rootViewController = vc;
}

+ (void)addSubViewWithViewId:(NSString *)viewId viewControllerId:(NSString *)viewControllerId
{
    UIViewController *targetVC = [self controlWithId:viewControllerId];
    [targetVC.view addSubview:[self controlWithId:viewId]];
}

+ (void)pushViewControllerWithId:(NSString *)viewControllerId sourceViewControllerId:(NSString *)sourceViewControllerId
{
    
}

+ (NSString *)createViewControllerWithTitle:(NSString *)title
                          scriptInteraction:(id<ScriptInteraction>)si
                            viewDidLoadFunc:(NSString *)viewDidLoadFunc
                         viewWillAppearFunc:(NSString *)viewWillAppearFunc
{
    ViewControllerImpl *vc = [[[ViewControllerImpl alloc] init] autorelease];
    NSString *cid = [self addControl:vc];
    vc.viewDidLoadBlock = ^(void){
        [si callFunction:viewDidLoadFunc callback:nil parameters:cid, nil];
    };
    vc.viewWillAppearBlock = ^(void){
        [si callFunction:viewWillAppearFunc callback:nil parameters:cid, nil];
    };
    return cid;
}

+ (NSString *)createButtonWithTitle:(NSString *)title scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button.frame = CGRectMake(0, 0, 80, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:[EventProxy sharedInstance] action:@selector(event:) forControlEvents:UIControlEventTouchUpInside];
    NSString *buttonId = [self addControl:button];
    [[EventProxy sharedInstance] addEventSource:button scriptInteraction:si funcName:funcName viewId:buttonId];
    return buttonId;
}

+ (void)setViewFrameWithViewId:(NSString *)viewId frame:(NSString *)frame
{
    UIView *view = [self controlWithId:viewId];
    NSArray *frameInfo = [frame componentsSeparatedByString:@","];
    if(view && frameInfo.count == 4){
        CGRect tmpRect = CGRectMake([frameInfo[0] floatValue], [frameInfo[1] floatValue], [frameInfo[2] floatValue], [frameInfo[3] floatValue]);
        view.frame = tmpRect;
    }
}

+ (CGRect)frameOfViewWithViewId:(NSString *)viewId
{
    UIView *view = [self controlWithId:viewId];
    return view.frame;
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName
{
    [DialogTools dialogWithTitle:title message:msg completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        [si callFunction:funcName callback:nil parameters:nil];
    } cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end
