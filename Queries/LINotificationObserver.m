//
//  NotificationObserver.m
//  Queries
//
//  Created by yangzexin on 11/25/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "NotificationObserver.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface NotificationObserver ()

@property(nonatomic, copy)NSString *func;

@end

@implementation NotificationObserver

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.appId = nil;
    self.objId = nil;
    self.func = nil;
    [super dealloc];
}

- (void)setNotificationName:(NSString *)notificationName func:(NSString *)func
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.func = func;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:notificationName object:nil];
}

- (void)didReceiveNotification:(NSNotification *)notification
{
    NSString *objectId = @"";
    if(notification.object){
        objectId = [LuaObjectManager addObject:notification.object group:self.appId];
    }
    NSString *userInfoId = @"";
    if(notification.userInfo){
        userInfoId = [LuaObjectManager addObject:notification.userInfo group:self.appId];
    }
    [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.func parameters:self.objId, objectId, userInfoId, nil];
    if(objectId.length != 0){
        [LuaObjectManager releaseObjectWithId:objectId group:self.appId];
    }
    if(userInfoId.length != 0){
        [LuaObjectManager releaseObjectWithId:userInfoId group:self.appId];
    }
}

+ (NSString *)create:(NSString *)appId
{
    NotificationObserver *tmp = [[NotificationObserver new] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
