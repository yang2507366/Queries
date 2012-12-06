//
//  BestLocationManager.m
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PreciseLocationManager.h"

@interface PreciseLocationManager () <CLLocationManagerDelegate>

@property(nonatomic, retain)CLLocationManager *locationManager;

@end

@implementation PreciseLocationManager

@synthesize delegate = _delegate;

@synthesize locationManager = _locationManager;

- (void)dealloc
{
    _locationManager.delegate = nil; [_locationManager release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    return self;
}

- (void)startUpdatingLocation
{
    if(self.locationManager){
        self.locationManager.delegate = nil;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        [self notifyError:[NSError errorWithDomain:NSStringFromClass(self.class)
                                              code:-1
                                          userInfo:[NSDictionary dictionaryWithObject:@"kCLAuthorizationStatusDenied"
                                                                               forKey:NSLocalizedDescriptionKey]]];
        return;
    }
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
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

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSTimeInterval timeInterval = fabs([newLocation.timestamp timeIntervalSinceNow]);
    if(timeInterval < 10){
//        VLog(@"precise location timestamp:%f", timeInterval);
        if([self.delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:)]){
            [self.delegate locationManager:self didUpdateToLocation:newLocation];
            self.delegate = nil;
        }
        [manager stopUpdatingLocation];
    }else{
//        VLog(@"skip location cache data");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self notifyError:error];
}

@end
