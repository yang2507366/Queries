//
//  LIGestureRecognizer.m
//  Queries
//
//  Created by yangzexin on 2/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "LIGestureRecognizer.h"
#import "LuaObjectManager.h"
#import <objc/runtime.h>
#import "LuaAppManager.h"

static char *objIdKey = "objId";
static char *appIdKey = "appId";
static char *callbackFuncKey = "callbackKey";

@interface LIGestureRecognizerEventProxy : NSObject <UIGestureRecognizerDelegate>

@end

@implementation LIGestureRecognizerEventProxy

+ (id)sharedInstance
{
    static id instance = nil;
    if(instance == nil){
        instance = [[self.class alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    
    return self;
}

- (void)eventAction:(UIGestureRecognizer *)gr
{
    NSString *objId = objc_getAssociatedObject(gr, objIdKey);
    NSString *appId = objc_getAssociatedObject(gr, appIdKey);
    NSString *funcName = objc_getAssociatedObject(gr, callbackFuncKey);
    if(funcName.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:appId] callFunction:funcName parameters:objId, nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

@implementation LIGestureRecognizer

+ (NSString *)create:(NSString *)appId
{
    return nil;
}

+ (NSString *)create:(NSString *)appId className:(NSString *)className
{
    Class targetClass = NSClassFromString(className);
    if(targetClass){
        UIGestureRecognizer *gr = [[[targetClass alloc] initWithTarget:[LIGestureRecognizerEventProxy sharedInstance] action:@selector(eventAction:)] autorelease];
        gr.delegate = [LIGestureRecognizerEventProxy sharedInstance];
        NSString *objId = [LuaObjectManager addObject:gr group:appId];
        objc_setAssociatedObject(gr, objIdKey, objId, OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(gr, appIdKey, appId, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        return objId;
    }
    return @"";
}

+ (void)setCallbackFuncNameForGR:(id)gr funcName:(NSString *)funcName
{
    objc_setAssociatedObject(gr, callbackFuncKey, funcName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
