//
//  LIScrollView.m
//  Queries
//
//  Created by yangzexin on 2/5/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "LIScrollView.h"
#import "LuaObjectManager.h"

@interface LIScrollViewDelegateProxy ()

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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
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
