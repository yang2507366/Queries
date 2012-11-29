//
//  GeocoderProvider.m
//  GWV2
//
//  Created by gewara on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppleGeocoder.h"
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MKPlacemark.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationDescription.h"

@interface AppleGeocoder ()

@property(nonatomic, retain)CLGeocoder *geocoder;

- (void)notifySucceed:(NSString *)locality;
- (void)notifyFailed:(NSError *)error;

@end

@implementation AppleGeocoder

@synthesize delegate = _delegate;
@synthesize geocoder = _geocoder;

- (void)dealloc
{
    [_geocoder cancelGeocode]; [_geocoder release];
    [super dealloc];
}

- (void)geocodeWithLatitude:(double)latitude longitude:(double)longitude
{
    self.geocoder = [[[CLGeocoder alloc] init] autorelease];
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:latitude 
                                                      longitude:longitude] autorelease];
    [self.geocoder reverseGeocodeLocation:location 
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if(error){
                                [self notifyFailed:error];
                            }else{
                                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                [self notifySucceed:placemark.locality];
                            }
                        }];
}
- (void)cancel
{
    [self.geocoder cancelGeocode];
    self.delegate = nil;
}
- (void)notifySucceed:(NSString *)locality
{
    if([self.delegate respondsToSelector:@selector(geocoder:didRecieveLocality:)]){
        LocationDescription *info = [[[LocationDescription alloc] init] autorelease];
        info.locality = locality;
        [self.delegate geocoder:self didRecieveLocality:info];
    }
}
- (void)notifyFailed:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(geocoder:didError:)]){
        [self.delegate geocoder:self didError:error];
    }
}

- (NSString *)description
{
    return @"AppleGeocoderProvider";
}
@end
