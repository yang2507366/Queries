//
//  Location.m
//  GoogleMapLocation
//
//  Created by gewara on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationDescription.h"

@implementation LocationDescription

@synthesize locality;
@synthesize address;
@synthesize coordinate;

- (void)dealloc
{
    [locality release];
    [address release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %f, %f", locality, address, coordinate.latitude, coordinate.longitude];
}

@end
