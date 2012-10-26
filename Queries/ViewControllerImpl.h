//
//  ViewControllerImpl.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface ViewControllerImpl : UIViewController

@property(nonatomic, copy)void(^viewDidLoadBlock)();
@property(nonatomic, copy)void(^viewWillAppearBlock)();
@property(nonatomic, copy)BOOL(^viewShouldPopBlock)();
@property(nonatomic, copy)void(^viewDidPopedBlock)();

@property(nonatomic, copy)NSString *group;
@property(nonatomic, copy)NSString *objectId;

- (id)initWithViewDidLoadBlock:(void(^)())viewDidLoadBlock
           viewWillAppearBlock:(void(^)())viewWillAppearBlock;

- (BOOL)shouldPopFromNavigationController;
- (void)viewDidPopFromNavigationController;

+ (NSString *)createViewControllerWithScriptId:(NSString *)scriptId
                                            si:(id<ScriptInteraction>)si
                                         title:(NSString *)title
                               viewDidLoadFunc:(NSString *)viewDidLoadFunc
                            viewWillAppearFunc:(NSString *)viewWillAppearFunc
                              viewDidPopedFunc:(NSString *)viewDidPopedFunc;

@end
