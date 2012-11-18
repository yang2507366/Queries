//
//  TextField.m
//  Queries
//
//  Created by yangzexin on 11/18/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "TextField.h"
#import "LuaObjectManager.h"

@implementation TextField

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    [super dealloc];
}

+ (NSString *)create:(NSString *)appId
{
    TextField *tf = [[TextField new] autorelease];
    tf.frame = CGRectMake(0, 0, 80, 37);
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    
    tf.appId = appId;
    tf.objId = [LuaObjectManager addObject:tf group:appId];
    
    return tf.objId;
}

@end
