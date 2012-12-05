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
- (void)providerWillRemoveFromPool;
@optional
- (BOOL)providerIsExecuting;

@end

@interface ProviderPool : NSObject {
    
}

- (void)addProvider:(id<ProviderPoolable>)provider;
- (void)tryToReleaseProvider;

+ (id)providerInPoolWithIdentifier:(id)identifier;
+ (void)addProviderToSharedPool:(id<ProviderPoolable>)provider identifier:(id)identifier;
+ (void)cleanWithIdentifier:(id)identifier;

@end
