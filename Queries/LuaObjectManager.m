//
//  GroupedObjectManager.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaObjectManager.h"
#import "ObjectWrapper.h"
#import "LuaConstants.h"

@interface LuaObjectManager ()

@property(nonatomic, retain)NSMutableDictionary *groupDictionary;

@end

@implementation LuaObjectManager

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
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(!objectDictionary){
        objectDictionary = [NSMutableDictionary dictionary];
        [self.groupDictionary setObject:objectDictionary forKey:group];
    }
    NSString *containObjectId = [self containsObject:object group:group];
    if(containObjectId.length != 0){
        D_Log(@"%@ exists", containObjectId);
        return containObjectId;
    }else{
//        D_Log(@"add object:%d:%@, group:%@", (NSInteger)object, object, group);
        NSString *objectId = [self idForObject:object];
        [objectDictionary setObject:[ObjectWrapper newObjectWrapperWithObject:object] forKey:objectId];
        NSLog(@"add object count:%d", [self statisticObjectCount]);
        return objectId;
    }
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
    NSLog(@"remove object count:%d", [self statisticObjectCount]);
}

- (NSString *)containsObject:(id)object group:(NSString *)group
{
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(objectDictionary){
        NSString *objectId = [self idForObject:object];
        ObjectWrapper *tmp = [objectDictionary objectForKey:objectId];
        return tmp == nil ? nil : objectId;
    }
    return nil;
}

- (id)objectWithId:(NSString *)objectId group:(NSString *)group
{
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(objectDictionary){
        ObjectWrapper *tmp = [objectDictionary objectForKey:objectId];
        if(!tmp){
            D_Log(@"%@ not exists", objectId);
        }
        return tmp.object;
    }
    return nil;
}

- (void)retainObjectWithId:(NSString *)objectId group:(NSString *)group
{
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(objectDictionary){
        ObjectWrapper *tmp = [objectDictionary objectForKey:objectId];
        if(tmp){
            ++tmp.referenceCount;
            D_Log(@"retain object:%@, %@, retainCount:%d", tmp.object, objectId, tmp.referenceCount);
        }
    }
}

- (BOOL)releaseObjectWithId:(NSString *)objectId group:(NSString *)group
{
    NSMutableDictionary *objectDictionary = [self.groupDictionary objectForKey:group];
    if(objectDictionary){
        ObjectWrapper *tmp = [objectDictionary objectForKey:objectId];
        if(tmp){
            --tmp.referenceCount;
            D_Log(@"release object:%@, %@, retainCount:%d", tmp.object, objectId, tmp.referenceCount);
            if(tmp.referenceCount == 0){
                D_Log(@"remove object for release:%@", objectId);
                [self removeObjectWithId:objectId group:group];
                return YES;
            }
        }
    }
    return NO;
}

- (NSInteger)statisticObjectCount
{
    NSInteger i = 0;
    NSArray *allKeys = [self.groupDictionary allKeys];
    for(NSString *group in allKeys){
        NSDictionary *tmpDict = [self.groupDictionary objectForKey:group];
        NSArray *allObjectKeys = [tmpDict allKeys];
        for(NSString *objectKey in allObjectKeys){
            ++i;
            D_Log(@"statis item:%@", [[tmpDict objectForKey:objectKey] object]);
        }
    }
    return i;
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

+ (void)retainObjectWithId:(NSString *)objectId group:(NSString *)group
{
    [[self sharedInstance] retainObjectWithId:objectId group:group];
}

+ (BOOL)releaseObjectWithId:(NSString *)objectId group:(NSString *)group
{
    return [[self sharedInstance] releaseObjectWithId:objectId group:group];
}

@end
