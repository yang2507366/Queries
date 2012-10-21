//
//  ViewControllerImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "ViewControllerImpl.h"

@interface ViewControllerImpl ()

@end

@implementation ViewControllerImpl

- (void)dealloc
{
    self.viewDidLoadBlock = nil;
    self.viewWillAppearBlock = nil;
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

@end
