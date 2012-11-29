//
//  LocationManager.h
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"

@class MKMapView;

@interface MapkitLocationManager : NSObject <LocationManager> {
    id<LocationManagerDelegate> _delegate;
}

@property(nonatomic, assign)NSTimeInterval timeOutSeconds;

@end
