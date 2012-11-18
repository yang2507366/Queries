//
//  BarButtonItem.m
//  Queries
//
//  Created by yangzexin on 11/18/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "BarButtonItem.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@implementation BarButtonItem

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

- (void)onTapped
{
    if(self.tapped.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:self.tapped parameters:self.objId, nil];
    }
}

+ (NSString *)create:(NSString *)appId
{
    BarButtonItem *item = [[BarButtonItem new] autorelease];
    item.style = UIBarButtonItemStyleBordered;
    item.appId = appId;
    item.objId = [LuaObjectManager addObject:item group:appId];
    
    return item.objId;
}

@end
