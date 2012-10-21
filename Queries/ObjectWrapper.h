//
//  ObjectWrapper.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectWrapper : NSObject

+ (id)newObjectWrapperWithObject:(id)object;

@property(nonatomic, assign)NSInteger referenceCount;
@property(nonatomic, retain)NSObject *object;

@end
