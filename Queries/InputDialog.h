//
//  InputDialog.h
//  CodeEditor
//
//  Created by yangzexin on 2/16/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputDialog : NSObject

+ (void)showInputDialogWithTitle:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
              approveButtonTitle:(NSString *)approveButtonTitle
                      completion:(void(^)(NSString *input))completion;

@end
