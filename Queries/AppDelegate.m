//
//  AppDelegate.m
//  Queries
//
//  Created by yangzexin on 10/16/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "AppDelegate.h"
#import "QueriesViewController.h"
#import "MemoryTracer.h"
#import "ScriptInteraction.h"
#import "LuaScriptInteraction.h"
#import "LuaAppManager.h"
#import "LuaRuntimeUtils.h"
#import "LuaObjectManager.h"
#import "CodeUtils.h"
#import "ApplicationScriptBundle.h"
#import "LuaApp.h"
#import "OnlineAppBundleLoader.h"
#import "LocalAppBundle.h"
#import "ProviderPool.h"
#import "LINavigationController.h"
#import "AppRunnerViewController.h"

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [MemoryTracer start];

//    self.window.rootViewController =
//        [[[LINavigationController alloc] initWithRootViewController:[[[QueriesViewController alloc] init] autorelease]] autorelease];
    
//    self.window.rootViewController =
//        [[[LINavigationController alloc] initWithRootViewController:[[[AppRunnerViewController alloc] init] autorelease]] autorelease];
    UIViewController *relatedVC = [[[UIViewController alloc] init] autorelease];
    UINavigationController *nc = [[[LINavigationController alloc] initWithRootViewController:relatedVC] autorelease];
    self.window.rootViewController = nc;
    
    LuaApp *app = [[[LuaApp alloc] initWithScriptBundle:[ApplicationScriptBundle new] baseWindow:self.window] autorelease];
    app.relatedViewController = relatedVC;
    [LuaAppManager runRootApp:app params:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
