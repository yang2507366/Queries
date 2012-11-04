//
//  TextFieldImpl.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface TextFieldImpl : UITextField

@property(nonatomic, copy)BOOL(^shouldBeginBlock)();
@property(nonatomic, copy)void(^didBeginBlock)();
@property(nonatomic, copy)BOOL(^shouldEndBlock)();
@property(nonatomic, copy)void(^didEndBlock)();
@property(nonatomic, copy)BOOL(^shouldChangeCharBlock)(NSInteger location, NSInteger length);

+ (NSString *)createTextFieldWithScriptId:(NSString *)scriptId
                                    frame:(CGRect)frame;
+ (void)attachEventWithAppId:(NSString *)appId
                          si:(id<ScriptInteraction>)si
                    objectId:(NSString *)objectId
             shouldBeginFunc:(NSString *)shouldBeginFunc
                didBeginFunc:(NSString *)didBeginFunc
               shouldEndFunc:(NSString *)shouldEndFunc
                  didEndFunc:(NSString *)didEndFunc
        shouldChangeCharFunc:(NSString *)shouldChangeCharFunc;

@end
