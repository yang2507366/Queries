//
//  Button.m
//  Queries
//
//  Created by yangzexin on 11/17/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "Button.h"
#import "LuaObjectManager.h"

@implementation Button

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    [super dealloc];
}

- (void)tapped
{
    NSLog(@"tapped");
}

+ (NSString *)create:(NSString *)appId
{
    return [self create:appId type:UIButtonTypeRoundedRect];
}

+ (NSString *)create:(NSString *)appId type:(UIButtonType)buttonType
{
    Button *btn = [Button buttonWithType:UIButtonTypeRoundedRect];
    btn.appId = appId;
    btn.objId = [LuaObjectManager addObject:btn group:appId];
    [btn addTarget:btn action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    
    return btn.objId;
}

@end
