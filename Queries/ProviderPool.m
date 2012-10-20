//
//  ProviderPool.m
//  GWV2
//
//  Created by gewara on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProviderPool.h"

@interface ProviderPool ()

@property(nonatomic, retain)NSMutableArray *providerList;
- (void)releaseAllProvider;

@end

@implementation ProviderPool

@synthesize providerList;

- (void)dealloc
{
    [self releaseAllProvider];
    self.providerList = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.providerList = [NSMutableArray array];
    
    return self;
}

- (void)addProvider:(id<ProviderPoolable>)provider
{
    [self.providerList addObject:provider];
}

- (void)tryToReleaseProvider
{
    NSMutableArray *wantReleaseList = [NSMutableArray array];
    for(id<ProviderPoolable> provider in self.providerList){
        if([provider providerShouldBeRemoveFromPool]){
            [provider providerWillRemoveFromPool];
            [wantReleaseList addObject:provider];
        }
    }
    for(id<ProviderPoolable> provider in wantReleaseList){
        [self providerDidRemove:provider];
        [self.providerList removeObject:provider];
    }
}

- (void)releaseAllProvider
{
    for(id<ProviderPoolable> provider in self.providerList){
        [self providerDidRemove:provider];
        [provider providerWillRemoveFromPool];
    }
    [self.providerList removeAllObjects];
}

- (void)providerDidRemove:(id<ProviderPoolable>)provider
{
    NSLog(@"%@", provider);
}

#pragma mark - SharedPool
+ (ProviderPool *)sharedPool
{
    static ProviderPool *instance = nil;
    if(instance == nil){
        @synchronized(self.class){
            instance = [[ProviderPool alloc] init];
        }
    }
    
    return instance;
}

+ (NSMutableDictionary *)sharedPoolDictionary
{
    static NSMutableDictionary *dictionary = nil;
    if(dictionary == nil){
        @synchronized(self.class){
            dictionary = [[NSMutableDictionary dictionary] retain];
        }
    }
    return dictionary;
}

+ (NSString *)identifierForObj:(id)obj
{
    return [NSString stringWithFormat:@"id_%@", obj];
}

+ (void)addProviderToSharedPool:(id<ProviderPoolable>)provider identifier:(id)identifier
{
    @synchronized(self.class){
        ProviderPool *pool = [self sharedPool];
        [[self sharedPoolDictionary] setObject:provider forKey:[self identifierForObj:identifier]];
        [pool addProvider:provider];
        if(pool.providerList.count > 5){
            [pool tryToReleaseProvider];
        }
    }
}

+ (void)cleanWithIdentifier:(id)identifier
{
    @synchronized(self.class){
        ProviderPool *pool = [self sharedPool];
        id<ProviderPoolable> provider = [[self sharedPoolDictionary] objectForKey:[self identifierForObj:identifier]];
        if(provider){
            [provider providerWillRemoveFromPool];
            [pool.providerList removeObject:provider];
        }
        [pool tryToReleaseProvider];
    }
}

@end
