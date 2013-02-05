//
//  LIScrollView.m
//  Queries
//
//  Created by yangzexin on 2/5/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "LIScrollView.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface LIScrollViewDelegateProxy ()

@property(nonatomic, retain)NSMutableDictionary *scrollViewDict;// hash : scrollViewId
@property(nonatomic, retain)NSMutableDictionary *appDict;// scrollViewId : appId

@property(nonatomic, copy)NSString *scrollViewDidScroll;

@end

@implementation LIScrollViewDelegateProxy

+ (id)sharedInstance
{
    static id instance = nil;
    if(instance == nil){
        instance = [LIScrollViewDelegateProxy new];
    }
    return instance;
}

+ (void)setScrollViewHash:(NSString *)hash scrollViewObjId:(NSString *)scrollViewObjId appId:(NSString *)appId
{
    scrollViewObjId = [scrollViewObjId substringFromIndex:1];
    [[[self sharedInstance] scrollViewDict] setObject:scrollViewObjId forKey:hash];
    [[[self sharedInstance] appDict] setObject:appId forKey:scrollViewObjId];
}

+ (void)removeDelegateWithHash:(NSString *)hash
{
    NSString *scrollViewObjId = [[[self sharedInstance] scrollViewDict] objectForKey:hash];
    if(scrollViewObjId.length != 0){
        [[[self sharedInstance] scrollViewDict] removeObjectForKey:hash];
        [[[self sharedInstance] appDict] removeObjectForKey:scrollViewObjId];
    }
}

+ (void)setScrollViewDidScrollFunc:(NSString *)func
{
    [[self sharedInstance] setScrollViewDidScroll:func];
}

- (void)dealloc
{
    self.scrollViewDict = nil;
    self.appDict = nil;
    self.scrollViewDidScroll = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.scrollViewDict = [NSMutableDictionary dictionary];
    self.appDict = [NSMutableDictionary dictionary];
    
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *hash = [NSString stringWithFormat:@"%d", [scrollView hash]];
    NSString *scrollViewObjId = [self.scrollViewDict objectForKey:hash];
    NSString *appId = [self.appDict objectForKey:scrollViewObjId];
    if(scrollViewObjId.length != 0 && appId.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:appId] callFunction:self.scrollViewDidScroll parameters:scrollViewObjId, nil];
    }
}

@end

@implementation LIScrollView

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    [super dealloc];
}

+ (NSString *)create:(NSString *)appId
{
    LIScrollView *tmp = [[LIScrollView new] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
