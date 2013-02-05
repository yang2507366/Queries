//
//  LIScrollView.h
//  Queries
//
//  Created by yangzexin on 2/5/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"

@interface LIScrollViewDelegateProxy : NSObject <UIScrollViewDelegate>

+ (id)sharedInstance;
+ (void)setScrollViewHash:(NSString *)hash scrollViewObjId:(NSString *)scrollViewObjId appId:(NSString *)appId;
+ (void)removeDelegateWithHash:(NSString *)hash;

+ (void)setScrollViewDidScrollFunc:(NSString *)func;

@end

@interface LIScrollView : UIScrollView <LuaImplentatable>

@end
