//
//  AppLoaderImpl.h
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface AppLoaderImpl : NSObject

+ (void)loadWithAppId:(NSString *)appId
                   si:(id<ScriptInteraction>)si
             loaderId:(NSString *)loaderId
            urlString:(NSString *)urlString
          processFunc:(NSString *)processFunc
         completeFunc:(NSString *)completeFunc;

@end
