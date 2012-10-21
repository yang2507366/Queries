//
//  EventProxy.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "EventProxy.h"

@implementation EventObject

- (void)dealloc
{
    self.si = nil;
    self.funcName = nil;
    self.viewId = nil;
    [super dealloc];
}

@end

@implementation EventProxy

@synthesize eventDict;

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

- (void)dealloc
{
    self.eventDict = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.eventDict = [NSMutableDictionary dictionary];
    
    return self;
}

- (NSString *)identifierForObject:(NSString *)obj
{
    return [NSString stringWithFormat:@"%d", (NSInteger)obj];
}

- (void)addEventSource:(id)eventSource scriptInteraction:(id<ScriptInteraction>)si funcName:(NSString *)funcName viewId:(NSString *)viewId
{
    EventObject *eo = [[[EventObject alloc] init] autorelease];
    eo.si = si;
    eo.funcName = funcName;
    eo.viewId = viewId;
    [self.eventDict setObject:eo forKey:[self identifierForObject:eventSource]];
}

- (void)event:(id)source
{
    EventObject *eo = [self.eventDict objectForKey:[self identifierForObject:source]];
    [eo.si callFunction:eo.funcName callback:nil parameters:eo.viewId, nil];
}

@end

