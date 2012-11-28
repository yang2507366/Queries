//
//  GeocoderProvider.h
//  GWV2
//
//  Created by gewara on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationDescription;

@protocol GeocoderDelegate <NSObject>

@optional
- (void)geocoder:(id)geocoder didRecieveLocality:(LocationDescription *)info;
- (void)geocoder:(id)geocoder didError:(NSError *)error;

@end

@protocol Geocoder <NSObject>

@property(nonatomic, assign)id<GeocoderDelegate> delegate;

- (void)geocodeWithLatitude:(double)latitude longitude:(double)longitude;
- (void)cancel;

@end
