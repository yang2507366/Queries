//
//  TextFieldImpl.m
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "TextFieldImpl.h"
#import "LuaGroupedObjectManager.h"

@implementation TextFieldImpl

+ (NSString *)createTextFieldWithScriptId:(NSString *)scriptId frame:(CGRect)frame
{
    UITextField *tmpTextField = [[[UITextField alloc] initWithFrame:frame] autorelease];
    tmpTextField.borderStyle = UITextBorderStyleRoundedRect;
    tmpTextField.returnKeyType = UIReturnKeyDone;
    tmpTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tmpTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tmpTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    return [LuaGroupedObjectManager addObject:tmpTextField group:scriptId];
}

@end
