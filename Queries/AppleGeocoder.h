//
//  GeocoderProvider.h
//  GWV2
//
//  Created by gewara on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Geocoder.h"

@class MKReverseGeocoder;
@class CLGeocoder;

@interface AppleGeocoder : NSObject <Geocoder> {
    id<GeocoderDelegate> _delegate;
    
    CLGeocoder *_geocoder;
}

@end
