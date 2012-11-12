//
//  UIAlertViewImpl.m
//  Queries
//
//  Created by yangzexin on 11/12/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "UIAlertViewImpl.h"
#import "LuaObjectManager.h"
#import "LuaAppRunner.h"
#import "ScriptInteraction.h"

@interface UIAlertViewDelegateProxy : NSObject <UIAlertViewDelegate>

@end

@implementation UIAlertViewDelegateProxy

+ (id)sharedInstance
{
    static UIAlertViewDelegateProxy *instance = nil;
    if(instance == nil){
        instance = [[UIAlertViewDelegateProxy alloc] init];
    }
    return instance;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertViewImpl *tmp = (id)alertView;
    if(tmp.clickedButtonAtIndex.length != 0){
        id<ScriptInteraction> si = [LuaAppRunner scriptInteractionWithAppId:tmp.appId];
        [si callFunction:tmp.clickedButtonAtIndex parameters:tmp.objId, [NSString stringWithFormat:@"%d", buttonIndex], nil];
    }
}

//- (void)alertViewCancel:(UIAlertView *)alertView
//{
//}
//
//- (void)willPresentAlertView:(UIAlertView *)alertView
//{
//}
//
//- (void)didPresentAlertView:(UIAlertView *)alertView
//{
//}
//
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//}
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//}

//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
//{
//    return YES;
//}

@end

@implementation UIAlertViewImpl

@synthesize appId;
@synthesize objId;

@synthesize clickedButtonAtIndex;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    [super dealloc];
}

+ (NSString *)create:(NSString *)appId
{
    UIAlertViewImpl *alert = [[[UIAlertViewImpl alloc] init] autorelease];
    alert.delegate = [UIAlertViewDelegateProxy sharedInstance];
    alert.appId = appId;
    alert.objId = [LuaObjectManager addObject:alert group:appId];
    
    return alert.objId;
}

@end