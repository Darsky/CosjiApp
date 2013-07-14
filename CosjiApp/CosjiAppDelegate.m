//
//  CosjiAppDelegate.m
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiAppDelegate.h"
#import "TopAppConnector.h"
#import "SKTransactionObserver.h"
#import "TopAppService.h"
#import "CosjiViewController.h"
#import "CosjiSpecialActivityViewController.h"
#import "CosjiTaoBaoFanliViewController.h"
#import "CosjiUserViewController.h";
#import "CosjiViewStoreFanliController.h"
#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@implementation CosjiAppDelegate
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UITabBarController *rootTabBarController=[[UITabBarController alloc] init];
    CosjiSpecialActivityViewController *specialActivityViewController=[[CosjiSpecialActivityViewController alloc] initWithNibName:@"CosjiSpecialActivityViewController" bundle:nil];
    CosjiTaoBaoFanliViewController *taoBaoFanliViewController=[[CosjiTaoBaoFanliViewController alloc] initWithNibName:@"CosjiTaoBaoFanliViewController" bundle:nil];
    CosjiViewStoreFanliController *storeFanliController=[[CosjiViewStoreFanliController alloc] initWithNibName:@"CosjiViewStoreFanliController" bundle:nil];
    CosjiUserViewController *userViewController=[[CosjiUserViewController alloc] initWithNibName:@"CosjiUserViewController" bundle:nil];    
    viewController=[[CosjiViewController alloc] initWithNibName:@"CosjiViewController" bundle:nil];
    rootTabBarController.viewControllers=[NSArray arrayWithObjects:viewController,taoBaoFanliViewController,storeFanliController,specialActivityViewController,userViewController, nil];
    //[rootTabBarController.tabBar setHidden:YES];
    UIView *contentView;
    if ( [[rootTabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [rootTabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [rootTabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + rootTabBarController.tabBar.frame.size.height);
    rootTabBarController.tabBar.hidden = YES;

    self.window.rootViewController = rootTabBarController;
    [self.window makeKeyAndVisible];
    [TopIOSClient registerIOSClient:kAppKey appSecret:kAppSecret callbackUrl:kAppRedirectURI needAutoRefreshToken:TRUE];

    
    [TopAppService registerAppService:kAppKey appConnector:[TopAppConnector getAppConnectorbyAppKey:kAppKey]];
    
    //add transaction observer
    SKTransactionObserver * skObserver = [[SKTransactionObserver alloc]init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:skObserver];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        
        TopAppService *appservice = [TopAppService getAppServicebyAppKey:kAppKey];
        
        [appservice sso:nil forceRefresh:TRUE eventCallback:nil];
    });
    

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
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    TopAppConnector *appConnector = [TopAppConnector getAppConnectorbyAppKey:@"12642644"];
    //
    //    [appConnector receiveMessageFromApp:[url absoluteString]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        TopAppService *appservice = [TopAppService getAppServicebyAppKey:kAppKey];
        
        [appservice sso:nil forceRefresh:TRUE eventCallback:nil];
    });
    
    return YES;
}

@end
