//
//  CosjiViewController.m
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiViewController.h"
#import "TopIOSClient.h"
#import "TopSDKBundle.h"
#import "TopAuthWebView.h"
#import "TopAppService.h"
#import "TopAppConnector.h"
#import "StoreKit/StoreKit.h"

#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@interface CosjiViewController ()

@end

@implementation CosjiViewController
@synthesize userIds;
static UINavigationController* nc;
@synthesize tabitemBack,homeBtn,taoBaoBtn,storeBtn,activityBtn,mineBtn;
@synthesize customTabBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tabBarController.view addSubview:self.customTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)authAction:(id)sender {
    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:kAppKey];
    id result = [iosClient auth:self cb:@selector(authCallback:)];
    if ([result isMemberOfClass:[TopAuthWebViewToken class]]) {
        TopAuthWebView * view = [[TopAuthWebView alloc]initWithFrame:CGRectZero];
        [view open:result];
        UIViewController* c = [[UIViewController alloc] init];
        CGRect f = [[UIScreen mainScreen] applicationFrame];
        view.frame = CGRectMake(f.origin.x,40, f.size.width, f.size.height - 40);
        c.view = view;
        c.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain
                                                                              target:self action:@selector(closeAuthView)];
        c.navigationItem.title = @"授权";
        //显示层包装一下
        if (nc) {
            nc = nil;
        }
        nc = [[UINavigationController alloc]initWithRootViewController:c];
        
        //弹出来
        [self presentModalViewController:nc animated:YES];
    }


}
-(void)authCallback:(id)sender
{
    if ([sender isKindOfClass:[TopAuth class]])
    {
        TopAuth *auth = (TopAuth *)sender;
        
        [userIds addObject:[auth user_id]];
        
        NSLog(@"%@",[auth user_id]);
        
    }
    else
    {
        NSLog(@"%@",sender);
    }

}
- (IBAction)tqlAction:(id)sender {

    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:kAppKey];
    
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
}
-(IBAction)changeViewController:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
            self.tabBarController.selectedIndex=0;
        }
            break;
        case 1:
        {
            self.tabBarController.selectedIndex=1;
        }
            break;
        case 2:
        {
            self.tabBarController.selectedIndex=2;
        }
            break;
        case 3:
        {
            self.tabBarController.selectedIndex=3;
        }
            break;
        case 4:
        {
            self.tabBarController.selectedIndex=4;
        }
            break;
    }
    [UIView animateWithDuration:0.4 animations:^(void){
        self.tabitemBack.frame=CGRectMake([sender tag]*64, 0, 64, 44);
        
    }];
}
-(void)closeAuthView{
    [nc dismissModalViewControllerAnimated:YES];
    nc = nil;
}
- (void)viewDidUnload {
    [self setTabitemBack:nil];
    [self setHomeBtn:nil];
    [self setTaoBaoBtn:nil];
    [self setStoreBtn:nil];
    [self setActivityBtn:nil];
    [self setMineBtn:nil];
    [self setCustomTabBar:nil];
    [super viewDidUnload];
}
@end
