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

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    [super dealloc];
}

+ (NSString *)createWithScriptId:(NSString *)scriptId
                              si:(id<ScriptInteraction>)si
                           title:(NSString *)title
                           frame:(CGRect)frame
                   eventFuncName:(NSString *)eventFuncName
{
    UIButton *button = [ButtonImpl buttonWithType:UIButtonTypeRoundedRect];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    
    NSString *buttonId = [LuaGroupedObjectManager addObject:button group:scriptId];
    // add event
    [button addTarget:[EventProxy sharedInstance] action:@selector(event:) forControlEvents:UIControlEventTouchUpInside];
    [[EventProxy sharedInstance] addEventSource:button scriptInteraction:si funcName:eventFuncName viewId:buttonId];
    return buttonId;
}

+ (NSString *)createWithScriptId:(NSString *)scriptId si:(id<ScriptInteraction>)si type:(UIButtonType)type tappedFunc:(NSString *)tappedFunc
{
    UIButton *button = [UIButton buttonWithType:type];
    
    NSString *buttonId = [LuaGroupedObjectManager addObject:button group:scriptId];
    
    [button addTarget:[EventProxy sharedInstance] action:@selector(event:) forControlEvents:UIControlEventTouchUpInside];
    [[EventProxy sharedInstance] addEventSource:button scriptInteraction:si funcName:tappedFunc viewId:buttonId];
    
    return buttonId;
}

@end
