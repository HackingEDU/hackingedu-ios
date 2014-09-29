//
//  HackrBoardv1_1AppDelegate.m
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import "HackrBoardv1_1AppDelegate.h"
#import "AMSlideOutNavigationController.h"
#import "BaseViewController.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>

@implementation HackrBoardv1_1AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"1ODY0KDOt0JC4nDTb7Ze1eGy1O5W9d5gWAuLDHtg"
                  clientKey:@"bPvFMkzYP60QpTClNsaKSFn8G9eb30Ic56J0yC2a"];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];

    
    UIStoryboard *storybaord = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    self.slideoutController = [AMSlideOutNavigationController slideOutNavigation];
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		[self.slideoutController setSlideoutOptions:[AMSlideOutGlobals defaultFlatOptions]];
	}
	[self.slideoutController addSectionWithTitle:nil];
    
    UIViewController *controller;
    controller = [storybaord instantiateViewControllerWithIdentifier:@"Feed"];
    [self.slideoutController addViewControllerToLastSection:controller tagged:1 withTitle:@"Event Feed" andIcon:@""];
    
    UIViewController *controller2;
    controller2 = [storybaord instantiateViewControllerWithIdentifier:@"Profile"];
    [self.slideoutController addViewControllerToLastSection:controller2 tagged:2 withTitle:@"Profile" andIcon:@""];
    
    UIViewController *controller3;
    controller3 = [storybaord instantiateViewControllerWithIdentifier:@"Team"];
    [self.slideoutController addViewControllerToLastSection:controller3 tagged:3 withTitle:@"Team" andIcon:@""];
    
    [self.window setRootViewController:self.slideoutController];
    
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
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"%@",url);
    NSString *code = [[[url absoluteString] componentsSeparatedByString:@"="] lastObject];
    NSLog(@"%@",code);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"URLParsed" object:code];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
@end
