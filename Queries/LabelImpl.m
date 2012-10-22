//
//  LabelImpl.m
//  Queries
//
//  Created by yangzexin on 12-10-22.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "LabelImpl.h"
#import "LuaGroupedObjectManager.h"

@implementation LabelImpl

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    [super dealloc];
}

+ (NSString *)createLabelWithScriptId:(NSString *)scriptId text:(NSString *)text frame:(CGRect)frame
{
    UILabel *tmpLabel = [[[LabelImpl alloc] init] autorelease];
    tmpLabel.font = [UIFont systemFontOfSize:14.0f];
    tmpLabel.text = text;
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.frame = frame;
    
    return [LuaGroupedObjectManager addObject:tmpLabel group:scriptId];
}

@end
