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

@interface LIGeocoderEventProxy : NSObject <GeocoderDelegate>

@property(nonatomic, assign)LIGeocoder *liGeocoder;

@end

@implementation LIGeocoderEventProxy

- (void)dealloc
{
    [super dealloc];
}

- (void)geocoder:(id)geocoder didRecieveLocality:(LocationDescription *)info
{
    if(self.liGeocoder.didRecieveLocality.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.liGeocoder.appId] callFunction:self.liGeocoder.didRecieveLocality
                                                                            parameters:self.liGeocoder.objId, info.locality, info.address, nil];
    }
}

- (void)geocoder:(id)geocoder didError:(NSError *)error
{
    if(self.liGeocoder.didFailWithError.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.liGeocoder.appId] callFunction:self.liGeocoder.didFailWithError
                                                                            parameters:self.liGeocoder.objId, nil];
    }
}

@end

@interface LIGeocoder () <GeocoderDelegate>

@property(nonatomic, retain)LIGeocoderEventProxy *eventProxy;

@end

@implementation LIGeocoder

@synthesize appId;
@synthesize objId;
@synthesize didRecieveLocality;
@synthesize didFailWithError;

@synthesize eventProxy;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    self.didRecieveLocality = nil;
    self.didFailWithError = nil;
    
    self.eventProxy = nil;
    [super dealloc];
}

- (id)initWithGeocoderList:(NSArray *)pGeocoderList
{
    self = [super initWithGeocoderList:pGeocoderList];
    
    self.eventProxy = [[LIGeocoderEventProxy new] autorelease];
    self.eventProxy.liGeocoder = self;
    self.delegate = self.eventProxy;
    
    return self;
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
