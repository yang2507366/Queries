//
//  InputDialog.m
//  CodeEditor
//
//  Created by yangzexin on 2/16/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "InputDialog.h"

@interface InputDialog () <UIAlertViewDelegate>

@property(nonatomic, retain)UIAlertView *alertView;
@property(nonatomic, copy)void(^completion)(NSString *);

@end

@implementation InputDialog

- (void)dealloc
{
    self.alertView = nil;
    self.completion = nil;
    [super dealloc];
}

- (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             initText:(NSString *)initText
    cancelButtonTitle:(NSString *)cancelButtonTitle
   approveButtonTitle:(NSString *)approveButtonTitle
           completion:(void(^)(NSString *input))completion
{
    [self retain];
    self.completion = completion;
    self.alertView = [[[UIAlertView alloc] initWithTitle:title
                                                message:message
                                               delegate:self
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:approveButtonTitle, nil] autorelease];
    UITextField *textField = nil;
    if([self.alertView respondsToSelector:@selector(alertViewStyle)]){
        self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[self.alertView textFieldAtIndex:0] setText:initText];
    }else{
        textField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 42, 264, 35)] autorelease];
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.borderStyle = UITextBorderStyleBezel;
        textField.tag = 1001;
        textField.backgroundColor = [UIColor whiteColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.text = initText;
        [self.alertView addSubview:textField];
        self.alertView.message = @"\n\n";
    }
    [self.alertView show];
    [textField becomeFirstResponder];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *text = nil;
    if([self.alertView respondsToSelector:@selector(alertViewStyle)]){
        text = [[self.alertView textFieldAtIndex:0] text];
    }else{
        UITextField *textField = (id)[alertView viewWithTag:1001];
        text = textField.text;
    }
    if(buttonIndex == 1){
        self.completion(text);
    }
    [self release];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
   approveButtonTitle:(NSString *)approveButtonTitle
           completion:(void(^)(NSString *input))completion
{
    [self showWithTitle:title message:message initText:@"" cancelButtonTitle:cancelButtonTitle approveButtonTitle:approveButtonTitle completion:completion];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             initText:(NSString *)initText
    cancelButtonTitle:(NSString *)cancelButtonTitle
   approveButtonTitle:(NSString *)approveButtonTitle
           completion:(void(^)(NSString *input))completion
{
    InputDialog *inputDialog = [[InputDialog new] autorelease];
    [inputDialog showWithTitle:title
                       message:message
                      initText:initText
             cancelButtonTitle:cancelButtonTitle
            approveButtonTitle:approveButtonTitle
                    completion:completion];
}

@end
