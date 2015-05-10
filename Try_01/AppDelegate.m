//
//  AppDelegate.m
//  Try_01
//
//  Created by hqman on 15/4/21.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import  "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "FeedVC.h"
#import "FavoratiesVC.h"
#import "ProfileVC.h"
#import "RootTabbarVC.h"

#import "RDVTabBarItem.h"

@interface AppDelegate ()

@end
 
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    
    //https://github.com/CocoaLumberjack/CocoaLumberjack/blob/master/Documentation/XcodeColors.md
    setenv("XcodeColors", "YES", 0);
    
    // Standard lumberjack initialization
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    // Check out default colors:
    // Error : Red
    // Warn  : Orange
    
    UIColor *green = [UIColor colorWithRed:0.165 green:0.734 blue:0.301 alpha:1.000];
    
    
    
    [[DDTTYLogger sharedInstance] setForegroundColor:green backgroundColor:nil forFlag:DDLogFlagInfo];
    DDLogError(@"Paper jam");
//    DDLogError(@"Paper jam");                              // Red
//    DDLogWarn(@"Toner is low");                            // Orange
//    DDLogInfo(@"Warming up printer (pre-customization)");  // Default (black)
//    DDLogVerbose(@"Intializing protcol x26");              // Default (black)
    // Override point for customization after application launch.
    CGRect  viewRect=[[UIScreen mainScreen] bounds];
    self.window=[[UIWindow alloc]initWithFrame:viewRect];
    // 设置第一个VC
    //self.colorVC=[ViewController new];
     //self.window.rootViewController  = self.colorVC;
    self.window.backgroundColor = [UIColor whiteColor];

    
    UIViewController *feedVc = [[FeedVC alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:feedVc];
    
    UIViewController *favoratiesVC = [[FavoratiesVC  alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:favoratiesVC];
    
    //UIViewController *profileVC = [[ProfileVC alloc] init];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController * profileVC = (ProfileVC *)[sb instantiateViewControllerWithIdentifier:@"main_st"];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:profileVC];
    
    RootTabbarVC *tabBarController = [[RootTabbarVC alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController]];
    self.window.rootViewController  = tabBarController;
    [tabBarController customizeVCs];
    [self customizeInterface];
    NSUserDefaults *nd=[NSUserDefaults standardUserDefaults];
    
    
    
    NSDictionary *factorySettings = @{@"FavoriteGreeting": @"Hey!",@"HoursBetweenMothershipConnection" : @2};
    [nd registerDefaults:factorySettings];
    NSLog(@"name %@",[nd objectForKey:@"FavoriteGreeting"]);
        [self.window makeKeyAndVisible];
    return YES;
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        NSLog(@"%f",NSFoundationVersionNumber);
        //[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
        [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
        [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextField的光标颜色
        [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextView的光标颜色
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xe5e5e5"]] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        
         textAttributes = @{
                          // NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                            };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xe5e5e5"]]];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
     ;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
