//
//  ViewControllerImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ViewControllerImpl.h"
#import "LuaGroupedObjectManager.h"

@interface ViewControllerImpl ()

@end

@implementation ViewControllerImpl

- (void)dealloc
{
    self.viewDidLoadBlock = nil;
    self.viewWillAppearBlock = nil;
    D_Log(@"%d", (NSInteger)self);
    [super dealloc];
}

- (id)initWithViewDidLoadBlock:(void(^)())viewDidLoadBlock
           viewWillAppearBlock:(void(^)())viewWillAppearBlock
{
    self = [super init];
    
    self.viewDidLoadBlock = viewDidLoadBlock;
    self.viewWillAppearBlock = viewWillAppearBlock;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.viewDidLoadBlock){
        self.viewDidLoadBlock();
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.viewWillAppearBlock){
        self.viewWillAppearBlock();
    }
}

+ (NSString *)createViewControllerWithScriptId:(NSString *)scriptId
                                            si:(id<ScriptInteraction>)si
                                         title:(NSString *)title
                               viewDidLoadFunc:(NSString *)viewDidLoadFunc
                            viewWillAppearFunc:(NSString *)viewWillAppearFunc
{
    ViewControllerImpl *vc = [[[ViewControllerImpl alloc] init] autorelease];
    vc.title = title;
    NSString *cid = [LuaGroupedObjectManager addObject:vc group:scriptId];
    vc.viewDidLoadBlock = ^(void){
        [si callFunction:viewDidLoadFunc callback:nil parameters:cid, nil];
    };
    vc.viewWillAppearBlock = ^(void){
        [si callFunction:viewWillAppearFunc callback:nil parameters:cid, nil];
    };
    return cid;
}

@end
