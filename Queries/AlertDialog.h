//
//  DialogTools.h
//  GewaraSport
//
//  Created by yangzexin on 12-9-21.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DialogCompletion)(NSInteger buttonIndex, NSString *buttonTitle);

@interface AlertDialog : NSObject

+ (void)showWithTitle:(NSString *)title
                message:(NSString *)message
             completion:(DialogCompletion)completion
      cancelButtonTitle:(NSString *)cancelButtonTitle
      otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (void)showWithTitle:(NSString *)title
                message:(NSString *)message
             completion:(DialogCompletion)completion
      cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitleList:(NSArray *)titleList;

@end
