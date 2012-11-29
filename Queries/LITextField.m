//
//  TextField.m
//  Queries
//
//  Created by yangzexin on 11/18/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LITextField.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface TextFieldDelegateProxy : NSObject <UITextFieldDelegate>

@property(nonatomic, assign)LITextField *targetTextField;

@end

@implementation TextFieldDelegateProxy

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.targetTextField.shouldBeginEditing.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.targetTextField.appId] callFunction:self.targetTextField.shouldBeginEditing
                                                                                        parameters:self.targetTextField.objId, nil] boolValue];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.targetTextField.didBeginEditing.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.targetTextField.appId]
         callFunction:self.targetTextField.didBeginEditing parameters:self.targetTextField.objId, nil];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(self.targetTextField.shouldEndEditing.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.targetTextField.appId] callFunction:self.targetTextField.shouldEndEditing
                                                                                         parameters:self.targetTextField.objId, nil] boolValue];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.targetTextField.didEndEditing.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.targetTextField.appId]
         callFunction:self.targetTextField.didEndEditing parameters:self.targetTextField.objId, nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.targetTextField.shouldChangeCharactersInRange.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.targetTextField.appId]
                callFunction:self.targetTextField.shouldChangeCharactersInRange parameters:self.targetTextField.objId,
                [NSString stringWithFormat:@"%d", range.location], [NSString stringWithFormat:@"%d", range.length], string, nil] boolValue];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(self.targetTextField.shouldClear.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.targetTextField.appId] callFunction:self.targetTextField.shouldClear
                                                                                         parameters:self.targetTextField.objId, nil] boolValue];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.targetTextField.shouldReturn.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.targetTextField.appId] callFunction:self.targetTextField.shouldReturn
                                                                                         parameters:self.targetTextField.objId, nil] boolValue];
    }
    return YES;
}

@end

@interface LITextField ()

@property(nonatomic, retain)TextFieldDelegateProxy *delegateProxy;

@end

@implementation LITextField

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    self.shouldBeginEditing = nil;
    self.didBeginEditing = nil;
    self.shouldEndEditing = nil;
    self.didEndEditing = nil;
    self.shouldChangeCharactersInRange = nil;
    self.shouldClear = nil;
    self.shouldReturn = nil;
    
    self.delegateProxy = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.delegateProxy = [[TextFieldDelegateProxy new] autorelease];
    self.delegateProxy.targetTextField = self;
    [self updateDelegate];
    [self addTarget:self action:@selector(textFieldDone) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    return self;
}

- (void)updateDelegate
{
    self.delegate = self.delegateProxy;
}

- (void)textFieldDone
{
}

+ (NSString *)create:(NSString *)appId
{
    LITextField *tf = [[LITextField new] autorelease];
    tf.frame = CGRectMake(0, 0, 80, 37);
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.returnKeyType = UIReturnKeyDone;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    tf.appId = appId;
    tf.objId = [LuaObjectManager addObject:tf group:appId];
    
    return tf.objId;
}

@end
