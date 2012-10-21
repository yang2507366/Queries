//
//  ViewControllerImpl.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewControllerImpl : UIViewController

@property(nonatomic, copy)void(^viewDidLoadBlock)();
@property(nonatomic, copy)void(^viewWillAppearBlock)();

- (id)initWithViewDidLoadBlock:(void(^)())viewDidLoadBlock
           viewWillAppearBlock:(void(^)())viewWillAppearBlock;

@end
