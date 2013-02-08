//
//  BarButtonItem.m
//  Queries
//
//  Created by yangzexin on 11/18/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIBarButtonItem.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@implementation LIBarButtonItem

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    self.tapped = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.target = self;
    self.action = @selector(onTapped);
    
    return self;
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action
{
    self = [super initWithBarButtonSystemItem:systemItem target:self action:@selector(onTapped)];
    
    return self;
}

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    self = [super initWithImage:image style:style target:self action:@selector(onTapped)];
    
    return self;
}

- (void)onTapped
{
    if(self.tapped.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.tapped parameters:self.objId, nil];
    }
}

+ (NSString *)create:(NSString *)appId
{
    LIBarButtonItem *item = [[LIBarButtonItem new] autorelease];
    item.style = UIBarButtonItemStyleBordered;
    item.appId = appId;
    item.objId = [LuaObjectManager addObject:item group:appId];
    
    return item.objId;
}

+ (NSString *)createWithAppId:(NSString *)appId systemItem:(NSInteger)systemItem
{
    LIBarButtonItem *tmp = [[LIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:nil action:nil];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

+ (NSString *)createWithAppId:(NSString *)appId image:(UIImage *)img
{
    LIBarButtonItem *tmp = [[LIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:nil action:nil];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
