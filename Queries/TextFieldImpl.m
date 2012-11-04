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



@interface TextFieldDelegateProxy : NSObject <UITextFieldDelegate>

+ (id)sharedInstance;

@end

@implementation TextFieldDelegateProxy

+ (id)sharedDict
{
    static NSMutableDictionary *textFieldDict = nil;
    if(textFieldDict == nil){
        textFieldDict = [[NSMutableDictionary dictionary] retain];
    }
    return textFieldDict;
}

+ (id)sharedInstance
{
    static typeof(self) instance = nil;
    if(instance == nil){
        instance = [[self alloc] init];
    }
    return instance;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    TextFieldImpl *impl = (id)textField;
    if(impl.shouldBeginBlock){
        return impl.shouldBeginBlock();
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    TextFieldImpl *impl = (id)textField;
    if(impl.didBeginBlock){
        impl.didBeginBlock();
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    TextFieldImpl *impl = (id)textField;
    if(impl.shouldEndBlock){
        return impl.shouldEndBlock();
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    TextFieldImpl *impl = (id)textField;
    if(impl.didEndBlock){
        impl.didEndBlock();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    TextFieldImpl *impl = (id)textField;
    if(impl.shouldChangeCharBlock){
        return impl.shouldChangeCharBlock(range.location, range.length);
    }
    return YES;
}

@end


@interface TextFieldImpl ()

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
    
    return self;
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
    textField.delegate = [TextFieldDelegateProxy sharedInstance];
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
