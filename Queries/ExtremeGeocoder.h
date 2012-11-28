//
//  ExtremeGeocoder.h
//  GWV2
//
//  Created by yangzexin on 12-10-11.
//
//

#import <Foundation/Foundation.h>
#import "Geocoder.h"

@interface ExtremeGeocoder : NSObject <Geocoder>

- (id)initWithGeocoderList:(NSArray *)pGeocoderList;

@end
