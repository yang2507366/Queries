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

@interface LILocationManager () <LocationManagerDelegate>

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
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.delegate = self;
    
    return self;
}

#pragma mark - LocationManagerDelegate
- (void)locationManager:(id)locationManager didUpdateToLocation:(CLLocation *)location
{
    if(self.didUpdateToLocation.length != 0){
        CLLocationCoordinate2D coordinate = location.coordinate;
        [[LuaAppManager scriptInteractionWithAppId:self.appId]
         callFunction:self.didUpdateToLocation parameters:self.objId,
         [NSString stringWithFormat:@"%f", coordinate.latitude], [NSString stringWithFormat:@"%f", coordinate.longitude], nil];
    }
}

- (void)locationManager:(id)locationManager didFailWithError:(NSError *)error
{
    if(self.didFailWithError.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.didFailWithError parameters:self.objId, nil];
    }
}

+ (NSString *)create:(NSString *)appId
{
    LILocationManager *tmp = [[LILocationManager new] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:tmp.appId];
    
    return tmp.objId;
}

@end
