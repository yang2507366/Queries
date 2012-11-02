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
    D_Log(@"%d", (NSInteger)self);
    
    self.viewDidLoadBlock = nil;
    self.viewWillAppearBlock = nil;
    self.viewShouldPopBlock = nil;
    self.viewDidPopedBlock = nil;
    
    self.group = nil;
    self.objectId = nil;
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldPopFromNavigationController
{
    if(self.viewShouldPopBlock){
        return self.viewShouldPopBlock();
    }
    return YES;
}

- (void)viewDidPopFromNavigationController
{
    if(self.viewDidPopedBlock){
        self.viewDidPopedBlock();
    }
}

+ (NSString *)createViewControllerWithScriptId:(NSString *)scriptId
                                            si:(id<ScriptInteraction>)si
                                         title:(NSString *)title
                               viewDidLoadFunc:(NSString *)viewDidLoadFunc
                            viewWillAppearFunc:(NSString *)viewWillAppearFunc
                              viewDidPopedFunc:(NSString *)viewDidPopedFunc
{
    ViewControllerImpl *vc = [[[ViewControllerImpl alloc] init] autorelease];
    vc.title = title;
    NSString *cid = [LuaGroupedObjectManager addObject:vc group:scriptId];
    vc.objectId = cid;
    vc.group = scriptId;
    vc.viewDidLoadBlock = ^(void){
        [si callFunction:viewDidLoadFunc callback:^(NSString *returnValue, NSString *error){
            D_Log(@"%@, %@", returnValue, error);
        } parameters:cid, nil];
    };
    vc.viewWillAppearBlock = ^(void){
        if(viewWillAppearFunc.length != 0){
            [si callFunction:viewWillAppearFunc callback:nil parameters:cid, nil];
        }
    };
    vc.viewDidPopedBlock = ^{
        if(viewDidPopedFunc.length != 0){
            [si callFunction:viewDidPopedFunc parameters:cid, nil];
        }
    };
    return cid;
}

@end
