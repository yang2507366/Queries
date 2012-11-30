//
//  LILocationManager.m
//  Queries
//
//  Created by yangzexin on 11/29/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LILocationManager.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface LILocationManagerDelegateProxy : NSObject <LocationManagerDelegate>

@property(nonatomic, assign)LILocationManager *liLocationMgr;

@end

@implementation LILocationManagerDelegateProxy

- (void)locationManager:(id)locationManager didUpdateToLocation:(CLLocation *)location
{
    if(self.liLocationMgr.didUpdateToLocation.length != 0){
        CLLocationCoordinate2D coordinate = location.coordinate;
        [[LuaAppManager scriptInteractionWithAppId:self.liLocationMgr.appId]
         callFunction:self.liLocationMgr.didUpdateToLocation parameters:self.liLocationMgr.objId,
         [NSString stringWithFormat:@"%f", coordinate.latitude], [NSString stringWithFormat:@"%f", coordinate.longitude], nil];
    }
}

- (void)locationManager:(id)locationManager didFailWithError:(NSError *)error
{
    if(self.liLocationMgr.didFailWithError.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.liLocationMgr.appId] callFunction:self.liLocationMgr.didFailWithError
                                                                               parameters:self.liLocationMgr.objId, nil];
    }
}

@end

@interface LILocationManager () <LocationManagerDelegate>

@property(nonatomic, retain)LILocationManagerDelegateProxy *delegateProxy;

@end

@implementation LILocationManager

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    self.didUpdateToLocation = nil;
    self.didFailWithError = nil;
    self.delegateProxy = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.delegateProxy = [[LILocationManagerDelegateProxy new] autorelease];
    self.delegateProxy.liLocationMgr = self;
    self.delegate = self.delegateProxy;
    
    return self;
}

+ (NSString *)create:(NSString *)appId
{
    LILocationManager *tmp = [[LILocationManager new] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:tmp.appId];
    
    return tmp.objId;
}

@end
