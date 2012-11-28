//
//  Location.h
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDescription : NSObject {
    NSString *locality;
    NSString *address;
    CLLocationCoordinate2D coordinate;
}

@property(nonatomic, copy)NSString *locality;
@property(nonatomic, copy)NSString *address;
@property(nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
