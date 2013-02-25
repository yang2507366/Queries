//
//  TimeCostTracer.m
//  GewaraSport
//
//  Created by yangzexin on 13-2-25.
//  Copyright (c) 2013年 gewara. All rights reserved.
//

#import "TimeCostTracer.h"

@interface TimeCostTracer ()

@property(nonatomic, retain)NSMutableDictionary *markDictionary;

@end

@implementation TimeCostTracer

+ (id)sharedInstance
{
    static id instance = nil;
    @synchronized(self.class){
        if(instance == nil){
            instance = [self.class new];
        }
    }
    return instance;
}

- (void)dealloc
{
    self.markDictionary = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.markDictionary = [NSMutableDictionary dictionary];
    
    return self;
}

+ (NSString *)identifierForObject:(id)object
{
    return [NSString stringWithFormat:@"%@", object];
}

+ (void)markWithIdentifier:(id)identifier
{
    [[[self sharedInstance] markDictionary] setObject:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]]
                                               forKey:[self identifierForObject:identifier]];
}

+ (NSTimeInterval)timeCostWithIdentifier:(id)identifier
{
    return [self.class timeCostWithIdentifier:identifier print:NO];
}

+ (NSTimeInterval)timeCostWithIdentifier:(id)identifier print:(BOOL)print
{
    NSNumber *num = [[[self sharedInstance] markDictionary] objectForKey:[self identifierForObject:identifier]];
    if(num){
        NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate] - [num doubleValue];
        if(print){
            NSLog(@"%@ cost:%f", identifier, interval);
        }
        return interval;
    }
    return NSNotFound;
}

@end
