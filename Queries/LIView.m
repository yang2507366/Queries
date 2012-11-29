//
//  View.m
//  Queries
//
//  Created by yangzexin on 11/19/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIView.h"
#import "LuaObjectManager.h"

@implementation LIView

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

+ (NSString *)create:(NSString *)appId
{
    LIView *tmp = [[LIView new] autorelease];
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:tmp.appId];
    
    return tmp.objId;
}

@end
