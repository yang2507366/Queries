//
//  CustomLocationManager.m
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomLocationManager.h"
#import "MapkitLocationManager.h"
#import "PreciseLocationManager.h"

@interface CustomLocationManager () <LocationManagerDelegate>

@property(nonatomic, retain)MapkitLocationManager *mapkitLocationMgr;
@property(nonatomic, retain)PreciseLocationManager *preciseLocationMgr;

@property(nonatomic, retain)CLLocation *preciseLocation;

@end

@implementation CustomLocationManager

@synthesize delegate = _delegate;

@synthesize mapkitLocationMgr = _mapkitLocationMgr;
@synthesize preciseLocationMgr = _preciseLocationMgr;

@synthesize preciseLocation = _preciseLocation;

- (void)dealloc
{
    [_mapkitLocationMgr cancel]; [_mapkitLocationMgr release];
    [_preciseLocationMgr cancel]; [_preciseLocationMgr release];
    
    [_preciseLocation release];
    [super dealloc];
}

- (void)startUpdatingLocation
{
    self.preciseLocationMgr = [[[PreciseLocationManager alloc] init] autorelease];
    self.preciseLocationMgr.delegate = self;
    [self.preciseLocationMgr startUpdatingLocation];
}

- (void)cancel
{
    self.delegate = nil;
}

#pragma mark - private methods
- (void)notifySucceed:(CLLocation *)location
{
    if([self.delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:)]){
        [self.delegate locationManager:self didUpdateToLocation:location];
    }
}

- (void)notifyError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(locationManager:didFailWithError:)]){
        [self.delegate locationManager:self didFailWithError:error];
    }
}

#pragma mark - LocationManagerDelegate
- (void)locationManager:(id)locationManager didUpdateToLocation:(CLLocation *)location
{
//    NSLog(@"Accuracy:%f, %f", location.horizontalAccuracy, location.verticalAccuracy);
    if(locationManager == self.preciseLocationMgr){
//        VLog(@"preciseCoordinate:%f, %f", location.coordinate.latitude, location.coordinate.longitude);
        self.preciseLocation = location;
        self.mapkitLocationMgr = [[[MapkitLocationManager alloc] init] autorelease];
        self.mapkitLocationMgr.delegate = self;
        [self.mapkitLocationMgr startUpdatingLocation];
    }else if(locationManager == self.mapkitLocationMgr){
//        VLog(@"mapkitCoordinate:%f, %f", location.coordinate.latitude, location.coordinate.longitude);
        [self notifySucceed:location];
    }
}

- (void)locationManager:(id)locationManager didFailWithError:(NSError *)error
{
    if(locationManager == self.preciseLocationMgr){
        [self notifyError:error];
    }else if(locationManager == self.mapkitLocationMgr){
        if(CLLocationCoordinate2DIsValid(self.preciseLocation.coordinate)){
            [self notifySucceed:self.preciseLocation];
        }else{
            [self notifyError:error];
        }
    }
}

@end
