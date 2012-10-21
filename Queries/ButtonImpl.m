//
//  ButtonImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ButtonImpl.h"
#import "LuaGroupedObjectManager.h"
#import "EventProxy.h"

@implementation ButtonImpl

+ (NSString *)createButtonWithTitle:(NSString *)title
                  scriptInteraction:(id<ScriptInteraction>)si
                   callbackFuncName:(NSString *)funcName
                           scriptId:(NSString *)scriptId
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button.frame = CGRectMake(0, 0, 80, 40);
    [button setTitle:title forState:UIControlStateNormal];
    
    NSString *buttonId = [LuaGroupedObjectManager addObject:button group:scriptId];
    // add event
    [button addTarget:[EventProxy sharedInstance] action:@selector(event:) forControlEvents:UIControlEventTouchUpInside];
    [[EventProxy sharedInstance] addEventSource:button scriptInteraction:si funcName:funcName viewId:buttonId];
    return buttonId;
}

+ (NSString *)createWithScriptId:(NSString *)scriptId
                              si:(id<ScriptInteraction>)si
                           title:(NSString *)title
                           frame:(CGRect)frame
                   eventFuncName:(NSString *)eventFuncName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    
    NSString *buttonId = [LuaGroupedObjectManager addObject:button group:scriptId];
    // add event
    [button addTarget:[EventProxy sharedInstance] action:@selector(event:) forControlEvents:UIControlEventTouchUpInside];
    [[EventProxy sharedInstance] addEventSource:button scriptInteraction:si funcName:eventFuncName viewId:buttonId];
    return buttonId;
}

@end
