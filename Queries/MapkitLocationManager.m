//
//  LocationManager.m
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapkitLocationManager.h"
#import <MapKit/MapKit.h>
#import "DelayController.h"

#define ACCURACY 100.0f
#define MAX_RETRY_COUNT 2

@interface MapkitLocationManager () <MKMapViewDelegate, DelayControllerDelegate>

@property(nonatomic, retain)MKMapView *mapView;

@property(nonatomic, assign)NSInteger retryCount;

@property(nonatomic, retain)DelayController *delayController;

- (void)notifyError:(NSError *)error;

@end

@implementation MapkitLocationManager

@synthesize delegate = _delegate;

@synthesize timeOut;

@synthesize mapView;

@synthesize retryCount;

@synthesize delayController;

- (void)dealloc
{
    [self.delayController cancel]; self.delayController = nil;
    self.mapView.delegate = nil; self.mapView = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.retryCount = 0;
    self.timeOut = 10.0f;
    
    return self;
}

- (void)startUpdatingLocation
{
    if([CLLocationManager locationServicesEnabled]){
        if(self.mapView){
            self.mapView.delegate = nil;
        }
        self.mapView = [[[MKMapView alloc] init] autorelease];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;
        
        if(self.delayController){
            [self.delayController cancel];
        }
        self.delayController = [[[DelayController alloc] initWithInterval:self.timeOut] autorelease];
        self.delayController.delegate = self;
        [self.delayController start];
    }else{
        [self notifyError:[NSError errorWithDomain:@"MapkitLocationManager" 
                                              code:1001 
                                          userInfo:[NSDictionary dictionaryWithObject:@"locationServicesNotEnabled" 
                                                                               forKey:NSLocalizedDescriptionKey]]];
    }
}

- (void)cancel
{
    self.delegate = nil;
}

- (void)notifyError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(locationManager:didFailWithError:)]){
        [self.delegate locationManager:self didFailWithError:error];
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    double timeInterval = fabs([userLocation.location.timestamp timeIntervalSinceNow]);
//    VLog(@"Accuracy:%f, %f, %f", userLocation.location.horizontalAccuracy, userLocation.location.verticalAccuracy, timeInterval);
    
    if(userLocation.location.horizontalAccuracy > ACCURACY && self.retryCount < MAX_RETRY_COUNT){
//        VLog([NSString stringWithFormat:@"update again because accuracy > %f", ACCURACY]);
        ++self.retryCount;
        [self performSelector:@selector(startUpdatingLocation) withObject:nil afterDelay:2.0f];
        return;
    }
    
    // 定位成功
    if([self.delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:)]){
        [self.delegate locationManager:self didUpdateToLocation:userLocation.location];
        self.delegate = nil;
    }
    self.mapView.delegate = nil;
    self.mapView = nil;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self notifyError:error];
    self.mapView.delegate = nil;
    self.mapView = nil;
}

- (void)delayControllerDidFinishedDelay:(DelayController *)controller
{
    [self notifyError:[NSError errorWithDomain:@"MapkitLocationManager" 
                                          code:1002 
                                      userInfo:[NSDictionary dictionaryWithObject:@"time out" 
                                                                           forKey:NSLocalizedDescriptionKey]]];
    self.mapView.delegate = nil;
    self.mapView = nil;
}

@end
