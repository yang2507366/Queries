//
//  BestLocationManager.h
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

@interface PreciseLocationManager : NSObject <LocationManager> {
    id<LocationManagerDelegate> _delegate;
    
    CLLocationManager *_locationManager;
}

@end
