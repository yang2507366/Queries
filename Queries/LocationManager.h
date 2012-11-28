//
//  LocationManager.h
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@protocol LocationManagerDelegate <NSObject>

@optional
- (void)locationManager:(id)locationManager didUpdateToLocation:(CLLocation *)location;
- (void)locationManager:(id)locationManager didFailWithError:(NSError *)error;

@end

@protocol LocationManager <NSObject>

@property(nonatomic, assign)id<LocationManagerDelegate>delegate;
- (void)startUpdatingLocation;
- (void)cancel;

@end
