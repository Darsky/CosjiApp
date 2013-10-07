//
//  CosjiLoginViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-10-4.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiLoginViewController.h"
#import "CosjiServerHelper.h"
#define testID @"zhuweimingyanha"
#define testPWD @"83266295"
#define userID @"394280"


@interface CosjiLoginViewController ()

@end

@implementation CosjiLoginViewController
@synthesize CustomNarBar,userName,passWord;

static CosjiLoginViewController *shareCosjiLoginViewController = nil;

+(CosjiLoginViewController*)shareCosjiLoginViewController
{
    
    if (shareCosjiLoginViewController == nil) {
        shareCosjiLoginViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiLoginViewController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.CustomNarBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        [self.CustomNarBar layer].shadowPath =[UIBezierPath bezierPathWithRect:CustomNarBar.bounds].CGPath;
        self.CustomNarBar.layer.shadowColor=[[UIColor blackColor] CGColor];
        self.CustomNarBar.layer.shadowOffset=CGSizeMake(0,0);
        self.CustomNarBar.layer.shadowRadius=10.0;
        self.CustomNarBar.layer.shadowOpacity=1.0;
        self.userName.delegate=self;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)back:(id)sender
{
    //  [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)exitUserName:(UITextField*)userTextField
{
    [userTextField resignFirstResponder];
}

-(IBAction)login:(id)sender
{
    NSLog(@"didEndEditing");
    [sender resignFirstResponder];
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    // NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary: [serverHelper getJsonDictionary:[NSString stringWithFormat:@"/user/login/?account=%@&password=%@",self.userName.text,self.passWord.text]]];
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary: [serverHelper getJsonDictionary:[NSString stringWithFormat:@"/user/login/?account=%@&password=%@",testID,testPWD]]];
    if (tmpDic!=nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"head"]];
            if ([[headDic objectForKey:@"msg"]isEqualToString:@"success"]) {
                NSDictionary *idDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                
                NSDictionary *userInfo=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/user/profile/?id=%@",[idDic objectForKey:@"userId"]]]];
                [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"logined"];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"恭喜你" message:@"登陆成功" delegate:self cancelButtonTitle:@"马上购物" otherButtonTitles: nil];
                    alert.tag=1;
                    [alert show];
                });
                
            }else
            {
                NSString *errString=[NSString stringWithFormat:@"%@",[headDic objectForKey:@"msg"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:errString delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles: nil];
                [alert show];
                
            }
            
            
        });
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCustomNarBar:nil];
    [self setUserName:nil];
    [self setPassWord:nil];
    [super viewDidUnload];
}
@end
