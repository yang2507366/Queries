//
//  Singleton.m
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+ (id)sharedInstance
{
    static id instance = nil;
    
    @synchronized(instance){
        if(instance == nil){
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (oneway void)release
{
    
}

- (id)retain
{
    return self;
}

- (id)autorelease
{
    return self;
}

@end
