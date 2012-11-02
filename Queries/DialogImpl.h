//
//  DialogImpl.h
//  Queries
//
//  Created by yangzexin on 12-11-2.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface DialogImpl : NSObject

+ (void)dialogWithTitle:(NSString *)title
                message:(NSString *)message
      cancelButtonTitle:(NSString *)cancelButtonTitle
         otherTitleList:(NSArray *)titleList
                     si:(id<ScriptInteraction>)si
               dialogId:(NSString *)dialogId
           callbackFunc:(NSString *)callbackFunc;

@end
