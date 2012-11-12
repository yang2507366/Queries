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
#import "LuaAppRunner.h"
#import "MethodInvokerForLua.h"
#import "LuaGroupedObjectManager.h"
#import "CodeUtils.h"
#import "ApplicationScriptBundle.h"
#import "LuaApp.h"
#import "OnlineAppBundleLoader.h"
#import "ZipArchive.h"
#import "LocalAppBundle.h"
#import "ProviderPool.h"
#import "NavigationControllerImpl.h"
#import "AppRunnerViewController.h"

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
    
    [MemoryTracer start];

    self.window.rootViewController =
        [[[NavigationControllerImpl alloc] initWithRootViewController:[[[AppRunnerViewController alloc] init] autorelease]] autorelease];
    
//    UIViewController *relatedVC = [[[UIViewController alloc] init] autorelease];
//    UINavigationController *nc = [[[NavigationControllerImpl alloc] initWithRootViewController:relatedVC] autorelease];
//    self.window.rootViewController = nc;
//    LuaApp *app = [[[LuaApp alloc] initWithScriptBundle:[ApplicationScriptBundle new] baseWindow:self.window] autorelease];
//    app.relatedViewController = relatedVC;
//    [LuaAppRunner runRootApp:app];
    
//    NSString *objId = [MethodInvokerForLua createObjectWithGroup:@"test"
//                                                       className:@"UIColor"
//                                                  initMethodName:@"initWithRed:green:blue:alpha:"
//                                                      parameters:[NSArray arrayWithObjects:@"1.0f", @"0.0f", @"0.0f", @"1.0f", nil]];
//    NSString *objId = [MethodInvokerForLua createObjectWithGroup:@"test"
//                                                       className:@"LabelImpl"
//                                                  initMethodName:@"init"
//                                                      parameters:[NSArray array]];
//    
//    NSLog(@"objId:%@", objId);
//    UIColor *targetObject = [LuaGroupedObjectManager objectWithId:objId group:@"test"];
//    NSLog(@"targetObject:%@", targetObject);
//    [LuaGroupedObjectManager removeObjectWithId:objId group:@"test"];
//    NSString *objId = [MethodInvokerForLua invokeClassMethodWithGroup:@"test" className:@"UIColor" methodName:@"blueColor" parameters:nil];
//    UIColor *targetObject = [LuaGroupedObjectManager objectWithId:objId group:@"test"];
//    NSLog(@"targetObject:%@", targetObject);
    
//    for(int i = 0; i < 8; ++i){
//        NSLog(@"%d", i << 20);
//    }
    
//    OnlineAppBundleLoader *loader = [[[OnlineAppBundleLoader alloc] initWithURLString:@"http://imyvoaspecial.googlecode.com/files/qr20.zip"] autorelease];
//    [loader loadWithCompletion:^(NSString *filePath) {
//        NSLog(@"%@", filePath);
//        ZipArchive *zipAr = [[[ZipArchive alloc] init] autorelease];
//        [zipAr UnzipOpenFile:filePath];
//        NSString *targetPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [filePath lastPathComponent]];
//        [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:NO attributes:nil error:nil];
//        [zipAr UnzipFileTo:targetPath overWrite:YES];
//        [zipAr UnzipCloseFile];
//        LocalAppBundle *appBundle = [[[LocalAppBundle alloc] initWithDirectory:targetPath] autorelease];
//        LuaApp *app = [[[LuaApp alloc] initWithScriptBundle:appBundle baseWindow:_window] autorelease];
//        [LuaSystemContext runRootApp:app];
//    }];
//    [ProviderPool addProviderToSharedPool:loader identifier:@"root_app_loader"];
    
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
