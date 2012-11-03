//
//  TextFieldImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "TextFieldImpl.h"
#import "LuaGroupedObjectManager.h"
#import "EventProxy.h"

@interface TextFieldImpl () <UITextFieldDelegate>

@property(nonatomic, copy)BOOL(^shouldBeginBlock)();
@property(nonatomic, copy)void(^didBeginBlock)();
@property(nonatomic, copy)BOOL(^shouldEndBlock)();
@property(nonatomic, copy)void(^didEndBlock)();
@property(nonatomic, copy)BOOL(^shouldChangeCharBlock)(NSInteger location, NSInteger length);

@end

@implementation TextFieldImpl

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    self.shouldBeginBlock = nil;
    self.didBeginBlock = nil;
    self.shouldEndBlock = nil;
    self.didEndBlock = nil;
    self.shouldChangeCharBlock = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.delegate = self;
    
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.shouldBeginBlock){
        return self.shouldBeginBlock();
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.didBeginBlock){
        self.didBeginBlock();
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(self.shouldEndBlock){
        return self.shouldEndBlock();
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.didEndBlock){
        self.didEndBlock();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.shouldChangeCharBlock){
        return self.shouldChangeCharBlock(range.location, range.length);
    }
    return YES;
}

+ (NSString *)createTextFieldWithScriptId:(NSString *)scriptId frame:(CGRect)frame
{
    UITextField *tmpTextField = [[[TextFieldImpl alloc] initWithFrame:frame] autorelease];
    tmpTextField.borderStyle = UITextBorderStyleRoundedRect;
    tmpTextField.returnKeyType = UIReturnKeyDone;
    tmpTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tmpTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tmpTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [tmpTextField addTarget:[EventProxy sharedInstance] action:@selector(event:) forControlEvents:UIControlEventEditingDidEndOnExit];
    return [LuaGroupedObjectManager addObject:tmpTextField group:scriptId];
}

+ (void)attachEventWithAppId:(NSString *)appId
                          si:(id<ScriptInteraction>)si
                    objectId:(NSString *)objectId
             shouldBeginFunc:(NSString *)shouldBeginFunc
                didBeginFunc:(NSString *)didBeginFunc
               shouldEndFunc:(NSString *)shouldEndFunc
                  didEndFunc:(NSString *)didEndFunc
        shouldChangeCharFunc:(NSString *)shouldChangeCharFunc
{
    TextFieldImpl *textField = [LuaGroupedObjectManager objectWithId:objectId group:appId];
    [textField setShouldBeginBlock:^BOOL{
        NSString *bstr = [si callFunction:shouldBeginFunc parameters:objectId, nil];
        return [bstr boolValue];
    }];
    [textField setDidBeginBlock:^{
        [si callFunction:didBeginFunc parameters:objectId, nil];
    }];
    [textField setShouldEndBlock:^BOOL{
        NSString *bstr = [si callFunction:shouldEndFunc parameters:objectId, nil];
        return [bstr boolValue];
    }];
    [textField setDidEndBlock:^{
        [si callFunction:didEndFunc parameters:objectId, nil];
    }];
    [textField setShouldChangeCharBlock:^BOOL(NSInteger location, NSInteger length) {
        NSString *bstr = [si callFunction:shouldChangeCharFunc parameters:objectId,
                          [NSString stringWithFormat:@"%d", location], [NSString stringWithFormat:@"%d", length], nil];
        return [bstr boolValue];
    }];
}

@end
