//
//  GroupedObjectManager.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaGroupedObjectManager.h"
#import "ObjectWrapper.h"

@interface LuaGroupedObjectManager ()

@property(nonatomic, retain)NSMutableDictionary *groupDictionary;

@end

@implementation LuaGroupedObjectManager

- (void)dealloc
{
    self.groupDictionary = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.groupDictionary = [NSMutableDictionary dictionary];
    
    return self;
}

#pragma mark - instance methods
- (NSString *)addObject:(id)object group:(NSString *)group
{
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(!objectDictionary){
        objectDictionary = [NSMutableDictionary dictionary];
        [self.groupDictionary setObject:objectDictionary forKey:group];
    }
    NSString *objectId = [NSString stringWithFormat:@"%d", (NSInteger)object];
    [objectDictionary setObject:[ObjectWrapper newObjectWrapperWithObject:object] forKey:objectId];
    
    return objectId;
}

- (void)removeGroup:(NSString *)group
{
    [self.groupDictionary removeObjectForKey:group];
}

- (id)getObjectWithId:(NSString *)objectId group:(NSString *)group
{
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(objectDictionary){
        ObjectWrapper *tmp = [objectDictionary objectForKey:objectId];
        return tmp.object;
    }
    return nil;
}

#pragma mark - class methods
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

+ (NSString *)addObject:(id)object group:(NSString *)group
{
    NSLog(@"add object:%d, group:%@", (NSInteger)object, group);
    return [[self sharedInstance] addObject:object group:group];
}

+ (void)removeGroup:(NSString *)group
{
    [[self sharedInstance] removeGroup:group];
}

+ (NSString *)getObjectWithId:(NSString *)objectId group:(NSString *)group
{
    NSLog(@"get with object id:%@, group:%@", objectId, group);
    return [[self sharedInstance] getObjectWithId:objectId group:group];
}

@end
