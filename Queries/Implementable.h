//
//  Implementable.h
//  Queries
//
//  Created by yangzexin on 12-10-31.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Implementable <NSObject>

@property(nonatomic, copy)NSString *scriptId;
@property(nonatomic, copy)NSString *objectId;

@end
