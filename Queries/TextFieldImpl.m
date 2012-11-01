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

@implementation TextFieldImpl

- (void)dealloc
{
    D_Log(@"%d", (NSInteger)self);
    [super dealloc];
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

@end
