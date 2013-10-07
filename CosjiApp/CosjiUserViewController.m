//
//  CosjiUserViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiUserViewController.h"
#import "TopIOSClient.h"
#import "CosjiMP3Player.h"
#import "MobileProbe.h"
#import "CosjiServerHelper.h"
#import "CosjiLoginViewController.h"
#import "CosjiSettingViewController.h"

#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@interface CosjiUserViewController ()
{
    UIViewController *currentMainController;
    BOOL backViewShowing;
    CGFloat translateFloat;
}
@property (strong,nonatomic)UIViewController *backViewController;
@end

@implementation CosjiUserViewController
static CosjiUserViewController *CosjiUserRootController;
@synthesize customNavBar,userInfoView,tableView,userName,vipImage,balanceLabel,scoreLabel,jifenbaoLabel,userHeadImage;
@synthesize MainBoard,SliderBackView,settingViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [MobileProbe pageBeginWithName:@"我的可及"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [MobileProbe pageEndWithName:@"我的可及"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    self.userInfoView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-背景"]];
    CosjiUserRootController=self;
    backViewShowing=NO;
    self.settingViewController=[[CosjiSettingViewController alloc] init];
    self.backViewController=self.settingViewController;
    [self.MainBoard setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-背景"]]];
    [self addChildViewController:self.backViewController];
    [self.SliderBackView addSubview:self.backViewController.view];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"]isEqualToString:@"YES"]) {
        self.userInfoView.hidden=NO;
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        self.userName.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"username"]];
        self.balanceLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"balance"]];
        self.scoreLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"score"]];
        self.jifenbaoLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"jifenbao"]];
        NSString *urlString=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"avatar"]];
        urlString=[urlString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if (self.userHeadImage==nil) {
            self.userHeadImage=[[UIImageView alloc] init];
            self.userHeadImage.frame = CGRectMake(10.f, 10.f, 72, 72);
            self.userHeadImage.layer.masksToBounds = YES;
            self.userHeadImage.layer.cornerRadius = 36;
            HeadImageFromURL([NSURL URLWithString:urlString], ^( UIImage * image )
                             {
                                 [self.userHeadImage setImage:image];
                             }, ^(void){
                             });
            UIImageView * userImageBoard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的可及-人像框"]];
            userImageBoard.frame = CGRectMake(10.f, 10.f, 76, 76);
            [self.userInfoView addSubview:userImageBoard];
            [self.userInfoView addSubview:self.userHeadImage];

        }else
        {
            
        }
        if ([[infoDic objectForKey:@"level"]isEqualToString:@"0"]) {
            self.vipImage.hidden=YES;
        }else
        {
            self.vipImage.hidden=NO;
        }
        
    }else
    {
        self.userInfoView.hidden=YES;
    }
}
#pragma mark tableviewmethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的订单"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 20)];
            functionLabel.text=@"返利订单";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
        case 1:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"推荐奖励"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 25)];
            functionLabel.text=@"推荐奖励";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
        case 2:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"账户明细"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 25)];
            functionLabel.text=@"账户明细";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
        case 3:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"信息"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 25)];
            functionLabel.text=@"站内信息";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
        case 4:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"账户设置"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 25)];
            functionLabel.text=@"账户设置";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
    }
    return cell;
}
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
void HeadImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL] ;
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock(image);
                               
                           }
                           else {
                               errorBlock();
                           }
                       });
                   });
}
- (IBAction)showOrHideBackView:(id)sender
{
    if (backViewShowing==NO) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGFloat translation = -280;
        self.MainBoard.transform = CGAffineTransformMakeTranslation(translation, 0);
        [UIView commitAnimations];
        backViewShowing=YES;
    }else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGFloat translation = 0;
        self.MainBoard.transform = CGAffineTransformMakeTranslation(translation, 0);
        [UIView commitAnimations];
        backViewShowing=YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCustomNavBar:nil];
    [self setUserInfoView:nil];
    [self setTableView:nil];
    [self setUserName:nil];
    [self setVipImage:nil];
    [self setBalanceLabel:nil];
    [self setScoreLabel:nil];
    [self setJifenbaoLabel:nil];
    [self setSliderBackView:nil];
    [self setMainBoard:nil];
    [super viewDidUnload];
}
@end
