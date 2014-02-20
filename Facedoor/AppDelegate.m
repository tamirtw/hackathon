//
//  AppDelegate.m
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/16/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import "AppDelegate.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "FacedoorModel.h"
#import "IIViewDeckController.h"
#import "HistoryViewController.h"
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface AppDelegate ()

@property (strong, nonatomic) IIViewDeckController *viewDeckController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *pushNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [self configPush];

    
    if (pushNotification)
    {
        [self handleNotification:pushNotification];
    }
    
    // Override point for customization after application launch.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    HistoryViewController* historyController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HistoryLog"];
    
    UINavigationController* navigationController = (UINavigationController *) self.window.rootViewController;
    self.viewDeckController =  [[IIViewDeckController alloc] initWithCenterViewController:navigationController
                                                                       leftViewController:nil
                                                                      rightViewController:historyController];
    self.window.rootViewController = self.viewDeckController;
    
    return YES;
}

- (void)configPush
{
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
        
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    // Request a custom set of notification types
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert |
                                         UIRemoteNotificationTypeNewsstandContentAvailability);
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

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DDLogVerbose(@"Application got push: %@", userInfo);
    
    [self handleNotification:userInfo];
}

- (void)handleNotification:(NSDictionary*)pushInfo
{
    DDLogVerbose(@"handle push %@", pushInfo);
    @try {
        FacedoorModel *doorModel = [FacedoorModel sharedInstance];
        [doorModel setIsAuthorized:pushInfo[@"name"] ? YES : NO];
        [doorModel setEventId:pushInfo[@"eventId"]];
        [doorModel setMessage:pushInfo[@"aps"][@"alert"]];
        [doorModel setSystemId:pushInfo[@"id"]];
        [doorModel setEventTimestamp:[NSDate dateWithTimeIntervalSince1970:[pushInfo[@"timestamp"] doubleValue]]];
    }
    @catch (NSException *exception) {
        DDLogCError(@"%@",exception);
    }
    @finally {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushInfoArrived object:self userInfo:nil];
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
