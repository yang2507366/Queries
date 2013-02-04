//
//  NetworkManager.h
//  Fitness
//
//  Created by gewara on 12-6-8.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

OBJC_EXPORT NSString *kNetworkStatusDidBecomeReachableNotification;
OBJC_EXPORT NSString *kNetworkStatusDidChangeNotification;

@interface NetworkManager : NSObject {
    NetworkStatus _currentStatus;
    
    Reachability *_reachability;
}

+ (NetworkManager *)sharedInstance;
- (void)startListen;
- (void)stopListen;

@property(nonatomic, readonly)NetworkStatus currentNetworkStatus;

@end
