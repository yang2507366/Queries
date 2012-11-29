//
//  Button.m
//  Queries
//
//  Created by yangzexin on 11/17/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "Button.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface ButtonImplData : NSObject

@property(nonatomic, copy)NSString *appId;
@property(nonatomic, copy)NSString *objId;
@property(nonatomic, copy)NSString *tapped;

@end

@implementation ButtonImplData

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    self.tapped = nil;
    [super dealloc];
}

@end

@interface ButtonEventProxy : NSObject

@property(nonatomic, retain)NSMutableDictionary *buttonDict;

@end

@implementation ButtonEventProxy

+ (id)shardInstance
{
    static id instance = nil;
    if(instance == nil){
        instance = [ButtonEventProxy new];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    
    self.buttonDict = [NSMutableDictionary dictionary];
    
    return self;
}

- (NSString *)identifierForButton:(id)button
{
    return [NSString stringWithFormat:@"%d", (NSInteger)button];
}

- (void)setTargetButton:(id)button implData:(ButtonImplData *)implData
{
    NSString *buttonId = [self identifierForButton:button];
    [self.buttonDict setObject:implData forKey:buttonId];
}

- (void)removeButton:(id)button
{
    [self.buttonDict removeObjectForKey:[NSString stringWithFormat:@"%d", (NSInteger)button]];
}

- (void)attachTappedEvent:(id)button func:(NSString *)func
{
    NSString *buttonId = [self identifierForButton:button];
    ButtonImplData *implData = [self.buttonDict objectForKey:buttonId];
    implData.tapped = func;
}

- (void)tapped:(UIButton *)button
{
    NSString *buttonId = [self identifierForButton:button];
    ButtonImplData *implData = [self.buttonDict objectForKey:buttonId];
    if(implData.tapped.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:implData.appId] callFunction:implData.tapped parameters:implData.objId, nil];
    }
}

@end

@implementation Button

+ (NSString *)create:(NSString *)appId
{
    return [self create:appId type:UIButtonTypeRoundedRect];
}

+ (NSString *)create:(NSString *)appId type:(UIButtonType)buttonType
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ButtonImplData *data = [[ButtonImplData new] autorelease];
    data.appId = appId;
    data.objId = [LuaObjectManager addObject:btn group:appId];
    [[ButtonEventProxy shardInstance] setTargetButton:btn implData:data];
    [btn addTarget:[ButtonEventProxy shardInstance] action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return data.objId;
}

+ (void)remove:(id)button;
{
    [[ButtonEventProxy shardInstance] removeButton:button];
}

+ (void)attachTappedEvent:(id)button func:(NSString *)func
{
    [[ButtonEventProxy shardInstance] attachTappedEvent:button func:func];
}

@end
