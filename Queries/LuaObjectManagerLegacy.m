//
//  LuaRelatedObjectManager.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaObjectManagerLegacy.h"

@interface ObjectWrapper : NSObject

@property(nonatomic, assign)NSInteger referenceCount;
@property(nonatomic, retain)NSObject *object;

@end

@implementation ObjectWrapper

- (void)dealloc
{
    NSLog(@"recycle object:%d", (NSInteger)self.object);
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

@end

@implementation LuaObjectManagerLegacy

+ (NSMutableDictionary *)objectPool
{
    static NSMutableDictionary *instance = nil;
    
    @synchronized(self.class){
        if(instance == nil){
            instance = [[NSMutableDictionary dictionary] retain];
        }
    }
    
    return instance;
}

+ (ObjectWrapper *)objectWrapperWithObjectId:(NSString *)objectId
{
    ObjectWrapper *tmpWrapper = [[self objectPool] objectForKey:objectId];
    return tmpWrapper;
}

+ (NSString *)addObject:(id)object
{
    NSString *controlId = [NSString stringWithFormat:@"%d", (NSInteger)object];
    ObjectWrapper *objectWrapper = [[[ObjectWrapper alloc] init] autorelease];
    objectWrapper.object = object;
    [[self objectPool] setObject:objectWrapper forKey:controlId];
    
    return controlId;
}

+ (void)removeObjectWithObjectId:(NSString *)objectId
{
    ObjectWrapper *tmpWrapper = [self objectWrapperWithObjectId:objectId];
    tmpWrapper.referenceCount = 0;
}

+ (id)objectForId:(NSString *)objectId
{
    ObjectWrapper *tmpWrapper = [self objectWrapperWithObjectId:objectId];
    if(!tmpWrapper){
        return nil;
    }
    if(tmpWrapper.referenceCount == 0){
        NSLog(@"try to get dealloc object:%@", tmpWrapper.object);
    }
    return [self objectWrapperWithObjectId:objectId].object;
}

@end
