//
//  ViewControllerManager.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIUIRelated.h"
#import "ConfirmDialog.h"
#import "LuaAppManager.h"
#import "LuaObjectManager.h"

@implementation LIUIRelated

+ (void)setRootViewControllerWithId:(NSString *)viewControllerId scriptId:(NSString *)scriptId
{
    UIViewController *vc = [LuaObjectManager objectWithId:viewControllerId group:scriptId];
    [LuaAppManager currentWindow].rootViewController = vc;
}

+ (NSString *)relatedViewControllerForAppId:(NSString *)appId
{
    id vc = [LuaAppManager appForId:appId].relatedViewController;
    if(vc){
        return [LuaObjectManager addObject:vc group:appId];
    }
    return nil;
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName
{
    [ConfirmDialog showWithTitle:title message:msg completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        if(funcName.length != 0){
            [si callFunction:funcName callback:nil parameters:nil];
        }
    } cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end
