//
//  CosjiWebViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiWebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CosjiWebViewController ()

@end

@implementation CosjiWebViewController
@synthesize customNavBar,storeName,userImage,userSetBtn,webView;
static CosjiWebViewController *shareCosjiWebViewController = nil;
+(CosjiWebViewController*)shareCosjiWebViewController
{
    
    if (shareCosjiWebViewController == nil) {
        shareCosjiWebViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiWebViewController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    [self.customNavBar layer].shadowPath =[UIBezierPath bezierPathWithRect:customNavBar.bounds].CGPath;
    self.customNavBar.layer.shadowColor=[[UIColor blackColor] CGColor];
    self.customNavBar.layer.shadowOffset=CGSizeMake(0,0);
    self.customNavBar.layer.shadowRadius=10.0;
    self.customNavBar.layer.shadowOpacity=1.0;

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}
-(void)setTabBarHidden:(BOOL)is
{
}

- (IBAction)back:(id)sender
{
  //  [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setStoreName:nil];
    [self setUserImage:nil];
    [self setUserSetBtn:nil];
    [self setWebView:nil];
    [self setCustomNavBar:nil];
    [super viewDidUnload];
}
@end
