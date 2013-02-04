//
//  NetworkManager.m
//  Fitness
//
//  Created by gewara on 12-6-8.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "NetworkManager.h"

NSString *kNetworkStatusDidBecomeReachableNotification = @"kNetworkStatusDidBecomeReachableNotification";
NSString *kNetworkStatusDidChangeNotification = @"kNetworkStatusDidChangeNotification";

@interface NetworkManager ()

@property(nonatomic, retain)Reachability *reachability;

@end

@implementation NetworkManager

@synthesize currentNetworkStatus = _currentStatus;

@synthesize reachability = _reachability;

+ (NetworkManager *)sharedInstance
{
    NetworkManager *instance = nil;
    @synchronized(instance){
        instance = [[NetworkManager alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_reachability stopNotifier];
    [_reachability release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onNetworkStatusChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    _currentStatus = [self.reachability currentReachabilityStatus];
    
    return self;
}

- (void)startListen
{
    [self.reachability startNotifier];
}

- (void)stopListen
{
    [self.reachability stopNotifier];
}

- (void)onNetworkStatusChanged:(NSNotification *)notification
{
    _currentStatus = self.reachability.currentReachabilityStatus;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStatusDidChangeNotification 
                                                        object:nil];
    
    if(_currentStatus != NotReachable){
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStatusDidBecomeReachableNotification 
                                                            object:nil];
    }
}

@end
