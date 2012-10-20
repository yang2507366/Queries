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

@interface EventObject : NSObject

@property(nonatomic, retain)id<ScriptInteraction> si;
@property(nonatomic, copy)NSString *funcName;
@property(nonatomic, copy)NSString *viewId;

@end

@implementation EventObject

- (void)dealloc
{
    self.si = nil;
    self.funcName = nil;
    self.viewId = nil;
    [super dealloc];
}

@end

@interface EventProxy : Singleton

@property(nonatomic, retain)NSMutableDictionary *eventDict;
- (void)event:(id)source;

@end

@implementation EventProxy

@synthesize eventDict;

- (void)dealloc
{
    self.eventDict = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.eventDict = [NSMutableDictionary dictionary];
    
    return self;
}

- (NSString *)identifierForObject:(NSString *)obj
{
    return [NSString stringWithFormat:@"%d", (NSInteger)obj];
}

- (void)addEventSource:(id)eventSource scriptInteraction:(id<ScriptInteraction>)si funcName:(NSString *)funcName viewId:(NSString *)viewId
{
    EventObject *eo = [[[EventObject alloc] init] autorelease];
    eo.si = si;
    eo.funcName = funcName;
    eo.viewId = viewId;
    [self.eventDict setObject:eo forKey:[self identifierForObject:eventSource]];
}

- (void)event:(id)source
{
    EventObject *eo = [self.eventDict objectForKey:[self identifierForObject:source]];
    [eo.si callFunction:eo.funcName callback:nil parameters:eo.viewId, nil];
}

@end

@implementation LuaUIRelatedImpl

+ (NSMutableDictionary *)controlPool
{
    static NSMutableDictionary *instance = nil;
    
    @synchronized(self.class){
        if(instance == nil){
            instance = [[NSMutableDictionary dictionary] retain];
        }
    }
    
    return instance;
}

+ (NSString *)rootViewControllerId
{
    NSString *tmpId = @"rootViewController";
    if(![[self controlPool] objectForKey:tmpId]){
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        UIViewController *rootVC = window.rootViewController;
        
        [[self controlPool] setObject:rootVC forKey:tmpId];
    }
    
    return tmpId;
}

+ (void)addSubViewWithViewId:(NSString *)viewId viewControllerId:(NSString *)viewControllerId
{
    UIViewController *targetVC = [[self controlPool] objectForKey:viewControllerId];
    [targetVC.view addSubview:[[self controlPool] objectForKey:viewId]];
}

+ (void)pushViewControllerWithId:(NSString *)viewControllerId sourceViewControllerId:(NSString *)sourceViewControllerId
{
    
}

+ (NSString *)createViewControllerWithTitle:(NSString *)title
{
    return nil;
}

+ (NSString *)createButtonWithTitle:(NSString *)title scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button.frame = CGRectMake(0, 20, 80, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:[EventProxy sharedInstance] action:@selector(event:) forControlEvents:UIControlEventTouchUpInside];
    NSString *buttonId = [NSString stringWithFormat:@"%d", (NSInteger)button];
    [[EventProxy sharedInstance] addEventSource:button scriptInteraction:si funcName:funcName viewId:buttonId];
    [[self controlPool] setObject:button forKey:buttonId];
    return buttonId;
}

+ (void)setViewFrameWithViewId:(NSString *)viewId frame:(NSString *)frame
{
    UIView *view = [[self controlPool] objectForKey:viewId];
    NSArray *frameInfo = [frame componentsSeparatedByString:@","];
    if(view && frameInfo.count == 4){
        CGRect tmpRect = CGRectMake([frameInfo[0] floatValue], [frameInfo[1] floatValue], [frameInfo[2] floatValue], [frameInfo[3] floatValue]);
        view.frame = tmpRect;
    }
}

+ (CGRect)frameOfViewWithViewId:(NSString *)viewId
{
    UIView *view = [[self controlPool] objectForKey:viewId];
    return view.frame;
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)msg scriptInteraction:(id<ScriptInteraction>)si callbackFuncName:(NSString *)funcName
{
    [DialogTools dialogWithTitle:title message:msg completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        [si callFunction:funcName callback:nil parameters:nil];
    } cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end
