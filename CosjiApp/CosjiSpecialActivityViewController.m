//
//  CosjiSpecialActivityViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiSpecialActivityViewController.h"
#import "TopIOSSdk.h"
#import "TopIOSClient.h"


#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@interface CosjiSpecialActivityViewController ()

@end

@implementation CosjiSpecialActivityViewController

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
}
- (IBAction)testDemo:(id)sender
{
     TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:kAppKey];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"taobao.item.img.upload" forKey:@"method"];
    [params setObject:@"2008-01-25 20:23:30" forKey:@"timestamp"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject:kAppKey forKey:@"app_key"];
    [params setObject:@"2.0" forKey:@"v"];
    [params setObject:@"NO" forKey:@"sign"];
    [params setObject:@"md5" forKey:@"sign_method"];
    NSArray *fields=[NSArray arrayWithObjects:@"cid",@"pid",@"prop_name",@"vid",@"name",@"name_alias",@"status",@"sort_order", nil];
    [params setObject:fields forKey:@"fields"];
    
    [iosClient api:@"GET" params:params target:self cb:@selector(showApiResponse:) userId:nil needMainThreadCallBack:TRUE];
}
-(void)showApiResponse:(id)data
    {
        if ([data isKindOfClass:[TopApiResponse class]])
        {
            TopApiResponse *response = (TopApiResponse *)data;
            
            if ([response content])
            {
                NSLog(@"%@",[response content]);
            }
            else {
                NSLog(@"%@",[(NSError *)[response error] userInfo]);
            }
            
            NSDictionary *dictionary = (NSDictionary *)[response reqParams];
            
            for (id key in dictionary) {
                
                NSLog(@"key: %@, value: %@", key, [dictionary objectForKey:key]);
                
            }
            for (id last_modified in dictionary) {
                 NSLog(@"item_cats %@",[dictionary objectForKey:last_modified]);
            }
        }
        
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
