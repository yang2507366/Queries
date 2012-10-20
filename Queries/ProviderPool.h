//
//  ProviderPool.h
//  GWV2
//
//  Created by gewara on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProviderPool;

@protocol ProviderPoolable <NSObject>
@required
- (BOOL)providerShouldBeRemoveFromPool;
- (BOOL)providerIsExecuting;
- (void)providerWillRemoveFromPool;

@end

@interface ProviderPool : NSObject {
    
}

- (void)addProvider:(id<ProviderPoolable>)provider;
- (void)tryToReleaseProvider;

+ (void)addProviderToSharedPool:(id<ProviderPoolable>)provider identifier:(id)identifier;
+ (void)cleanWithIdentifier:(id)identifier;

@end
