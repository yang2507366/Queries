//
//  UIAlertViewImpl.m
//  Queries
//
//  Created by yangzexin on 11/12/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "UIAlertViewImpl.h"
#import "LuaObjectManager.h"

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
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return YES;
}

@end

@implementation UIAlertViewImpl

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    [super dealloc];
}

+ (NSString *)create:(NSString *)appId
{
    UIAlertViewImpl *alert = [[[UIAlertViewImpl alloc] init] autorelease];
    alert.appId = appId;
    alert.delegate = [UIAlertViewDelegateProxy sharedInstance];
    alert.objId = [LuaObjectManager addObject:alert group:appId];
    
    return alert.objId;
}

@end