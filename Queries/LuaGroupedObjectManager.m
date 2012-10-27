//
//  GroupedObjectManager.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaGroupedObjectManager.h"
#import "ObjectWrapper.h"
#import "LuaConstants.h"

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
- (NSString *)idForObject:(id)object
{
    return [NSString stringWithFormat:@"%@%d", lua_obj_prefix,(NSInteger)object];
}

- (NSString *)addObject:(id)object group:(NSString *)group
{
    D_Log(@"add object:%d, group:%@", (NSInteger)object, group);
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(!objectDictionary){
        objectDictionary = [NSMutableDictionary dictionary];
        [self.groupDictionary setObject:objectDictionary forKey:group];
    }
    NSString *objectId = [self idForObject:object];
    if([self containsObject:object group:group].length != 0){
        D_Log(@"%@ exists", objectId);
    }
    [objectDictionary setObject:[ObjectWrapper newObjectWrapperWithObject:object] forKey:objectId];
    return objectId;
}

- (void)removeGroup:(NSString *)group
{
    [self.groupDictionary removeObjectForKey:group];
}

- (void)removeObjectWithId:(NSString *)objectId group:(NSString *)group
{
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(objectDictionary){
        [objectDictionary removeObjectForKey:objectId];
        D_Log(@"removeObjectWithId:%@", objectId);
    }
}

- (NSString *)containsObject:(id)object group:(NSString *)group
{
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(objectDictionary){
        NSString *objectId = [self idForObject:object];
        ObjectWrapper *tmp = [objectDictionary objectForKey:objectId];
        return tmp == nil ? nil : objectId;
    }
    return NO;
}

- (id)objectWithId:(NSString *)objectId group:(NSString *)group
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
    return [[self sharedInstance] addObject:object group:group];
}

+ (void)removeGroup:(NSString *)group
{
    [[self sharedInstance] removeGroup:group];
}

+ (void)removeObjectWithId:(NSString *)objectId group:(NSString *)group
{
    [[self sharedInstance] removeObjectWithId:objectId group:group];
}

+ (NSString *)containsObject:(id)object group:(NSString *)group
{
    return [[self sharedInstance] containsObject:object group:group];
}

+ (NSString *)objectWithId:(NSString *)objectId group:(NSString *)group
{
    D_Log(@"get with object id:%@, group:%@", objectId, group);
    return [[self sharedInstance] objectWithId:objectId group:group];
}

@end
