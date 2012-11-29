//
//  CustomLocationManager.h
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

@class MapkitLocationManager;
@class PreciseLocationManager;

@interface CustomLocationManager : NSObject <LocationManager> {
    id<LocationManagerDelegate> _delegate;
    
    MapkitLocationManager *_mapkitLocationMgr;
    PreciseLocationManager *_preciseLocationMgr;
    
    CLLocation *_preciseLocation;
}

@end
