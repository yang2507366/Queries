//
//  UIBarButtonItemImpl.m
//  Queries
//
//  Created by yangzexin on 10/24/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "UIBarButtonItemImpl.h"
#import "EventProxy.h"
#import "LuaGroupedObjectManager.h"

@interface UIBarButtonItemImpl ()

@property(nonatomic, copy)void(^tapEventBlock)();

@end

@implementation UIBarButtonItemImpl

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    self.tapEventBlock = nil;
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title tapEventBlock:(void(^)(void))tapEventBlock
{
    self = [super init];
    
    self.tapEventBlock = tapEventBlock;
    self.title = title;
    self.style = UIBarButtonItemStyleBordered;
    self.target = self;
    self.action = @selector(event);
    
    return self;
}

- (void)event
{
    if(self.tapEventBlock){
        self.tapEventBlock();
    }
}

+ (NSString *)createBarButtonItemWithScriptId:(NSString *)scriptId
                                           si:(id<ScriptInteraction>)si
                                        title:(NSString *)title
                                 callbackFunc:(NSString *)callbackFunc
{
    UIBarButtonItemImpl *btn = [[[UIBarButtonItemImpl alloc] initWithTitle:title tapEventBlock:nil] autorelease];
    
    NSString *btnId = [LuaGroupedObjectManager addObject:btn group:scriptId];
    [btn setTapEventBlock:^{
        [si callFunction:callbackFunc parameters:btnId, nil];
    }];
    [[EventProxy sharedInstance] addEventSource:btn scriptInteraction:si funcName:callbackFunc viewId:btnId];
    return btnId;
}

@end
