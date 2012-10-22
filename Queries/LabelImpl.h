//
//  LabelImpl.h
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelImpl : NSObject

+ (NSString *)createLabelWithScriptId:(NSString *)scriptId text:(NSString *)text frame:(CGRect)frame;

@end
