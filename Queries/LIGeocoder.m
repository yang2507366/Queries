//
//  LIGeocoder.m
//  Queries
//
//  Created by yangzexin on 11/29/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIGeocoder.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"
#import "LocationDescription.h"
#import "GoogleGeocoder.h"
#import "AppleGeocoder.h"

@interface LIGeocoder () <GeocoderDelegate>

@end

@implementation LIGeocoder

@synthesize appId;
@synthesize objId;
@synthesize didRecieveLocality;
@synthesize didFailWithError;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    self.didRecieveLocality = nil;
    self.didFailWithError = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.delegate = self;
    
    return self;
}

- (void)geocoder:(id)geocoder didRecieveLocality:(LocationDescription *)info
{
    if(self.didRecieveLocality.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.didRecieveLocality parameters:self.objId, info.locality, info.address, nil];
    }
}

- (void)geocoder:(id)geocoder didError:(NSError *)error
{
    if(self.didFailWithError.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.didFailWithError parameters:self.objId, nil];
    }
}

+ (NSString *)create:(NSString *)appId
{
    LIGeocoder *tmp = [[[LIGeocoder alloc] initWithGeocoderList:[NSArray arrayWithObjects:
                                                                 [[GoogleGeocoder new] autorelease],
                                                                 [[AppleGeocoder new] autorelease],
                                                                 nil]] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
