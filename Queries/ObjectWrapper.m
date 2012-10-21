//
//  ObjectWrapper.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ObjectWrapper.h"

@implementation ObjectWrapper

- (void)dealloc
{
    NSLog(@"ObjectWrapper::recycle object:%d", (NSInteger)self.object);
    self.object = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.referenceCount = 1;
    
    return self;
}

- (BOOL)recyclable
{
    return self.referenceCount == 0;
}

#pragma mark - class methods
+ (id)newObjectWrapperWithObject:(id)object
{
    ObjectWrapper *tmp = [[[ObjectWrapper alloc] init] autorelease];
    tmp.object = object;
    
    return tmp;
}

@end
