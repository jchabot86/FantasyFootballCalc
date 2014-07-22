//
//  AppDelegate.m
//  FantasyFootballCalc
//
//  Created by Jon on 6/22/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"
#import "Settings.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"App loaded.");
    [self createEditableCopyOfDatabaseIfNeeded];
    NSLog(@"Database ready.");
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    [tabBar setTintColor:[UIColor whiteColor]];
    [tabBar setBarTintColor:[UIColor whiteColor]];
    [tabBar setSelectionIndicatorImage:[[UIImage imageNamed:@"icon_bkg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 0, 0)]];
    [tabBarItem1 setImage:[[UIImage imageNamed:@"Search_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[UIImage imageNamed:@"Search_white.png"] ];
    [tabBarItem2 setImage:[[UIImage imageNamed:@"Scenario_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[UIImage imageNamed:@"Scenario_white.png"] ];
    [tabBarItem3 setImage:[[UIImage imageNamed:@"MyTeam_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[UIImage imageNamed:@"MyTeam_white.png"] ];
    [tabBarItem4 setImage:[[UIImage imageNamed:@"Settings_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setSelectedImage:[UIImage imageNamed:@"Settings_white.png"] ];
    
    return YES;
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"FantasyFootballCalc.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success && FORCE_CREATE_DB_ON_LOAD){
        [fileManager removeItemAtPath:writableDBPath error:NULL];
    } else if (success) {
        DBPATH = writableDBPath;
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FantasyFootballCalc.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    DBPATH = writableDBPath;
    
    
    Settings *settings = [Settings new];
    [settings resetTable];
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
