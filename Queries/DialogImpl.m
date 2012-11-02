//
//  DialogImpl.m
//  Queries
//
//  Created by yangzexin on 12-11-2.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "DialogImpl.h"
#import "DialogTools.h"

@implementation DialogImpl

+ (void)dialogWithTitle:(NSString *)title
                message:(NSString *)message
      cancelButtonTitle:(NSString *)cancelButtonTitle
         otherTitleList:(NSArray *)titleList
                     si:(id<ScriptInteraction>)si
               dialogId:(NSString *)dialogId
           callbackFunc:(NSString *)callbackFunc
{
    [DialogTools dialogWithTitle:title message:message completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        [si callFunction:callbackFunc parameters:dialogId, [NSString stringWithFormat:@"%d", buttonIndex], buttonTitle];
    } cancelButtonTitle:cancelButtonTitle otherButtonTitleList:titleList];
}

@end
