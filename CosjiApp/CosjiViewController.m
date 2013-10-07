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
#import "CosjiMP3Player.h"
#import "MobileProbe.h"
#import "CosjiServerHelper.h"
#import "CosjiLoginViewController.h"


#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@interface CosjiViewController ()

@end

@implementation CosjiViewController
@synthesize userIds;
static UINavigationController* nc;
@synthesize mainTableView,CustomHeadView;
@synthesize storeBrowseViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    topListArray=[[NSMutableArray alloc] initWithObjects:@"mainNews1.png",@"mainNews2.png", nil];
    storeListArray=[[NSMutableArray alloc] initWithCapacity:0];
    brandListArray=[[NSMutableArray alloc] initWithCapacity:0];
    page=[[UIPageControl alloc] initWithFrame:CGRectMake(141, 110, 38,36)];
    //page.center=CGPointMake(160, 126);
    sv=[[UIScrollView alloc] initWithFrame:CGRectMake(10, 5, 300, 130)];
    sv.delegate=self;
    sv.showsHorizontalScrollIndicator=NO;
    sv.backgroundColor=[UIColor clearColor];
    [self.CustomHeadView layer].shadowPath =[UIBezierPath bezierPathWithRect:CustomHeadView.bounds].CGPath;
    self.CustomHeadView.layer.shadowColor=[[UIColor blackColor] CGColor];
    self.CustomHeadView.layer.shadowOffset=CGSizeMake(0,0);
    self.CustomHeadView.layer.shadowRadius=10.0;
    self.CustomHeadView.layer.shadowOpacity=1.0;
    self.CustomHeadView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    [self AdImg:topListArray];
    [self setCurrentPage:page.currentPage];
    self.storeBrowseViewController=[[CosjiWebViewController alloc] initWithNibName:@"CosjiWebViewController" bundle:nil];
    self.navigationController.navigationBarHidden=YES;
    selectSection=99;
}
-(void)viewDidAppear:(BOOL)animated
{
    [MobileProbe pageBeginWithName:@"首页"];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    if ([storeListArray count]==0)
    {
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/mall/hot/"]];
        if (tmpDic!=nil)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                storeListArray=[NSArray arrayWithArray:[tmpDic objectForKey:@"body"]];
                NSLog(@"get Store %d",[storeListArray count]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mainTableView reloadData];
                    });
               
            });
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }else
    {

    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    page.currentPage=scrollView.contentOffset.x/320;
    [self setCurrentPage:page.currentPage];
    
    
}
- (void) handleTimer: (NSTimer *) timer
{
    if (TimeNum % 5 == 0 ) {
        //Tend 默认值为No
        if (!Tend) {
            NSLog(@"curretn page is %d",page.currentPage);
            page.currentPage++;
            if (page.currentPage==page.numberOfPages-1) {
                Tend=YES;
            }
        }else{
            NSLog(@"curretn page is %d",page.currentPage);
            page.currentPage--;
            if (page.currentPage==0) {
                Tend=NO;
            }
        }
        
        [UIView animateWithDuration:0.7 //速度0.7秒
                         animations:^{//修改坐标
                             sv.contentOffset = CGPointMake(page.currentPage*320,0);
                         }];
        
        
    }
    TimeNum ++;
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
- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [page.subviews count]; subviewIndex++) {
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        
        if (subviewIndex == secondPage) [subview setImage:[UIImage imageNamed:@"首页-焦点图-动态"]];
        else [subview setImage:[UIImage imageNamed:@"首页-焦点图-默认"]];
        
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
-(void)AdImg:(NSMutableArray*)arr{
    [sv setContentSize:CGSizeMake(310*[arr count], 130)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[topListArray count]; i++) {
        
        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 300, 130)];
        [img addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:img];
        [img setImage:[UIImage imageNamed:[topListArray objectAtIndex:i]] forState:UIControlStateNormal];
    }
    
}
-(void)Action
{
     UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"我是广告君" message:@"现在还木有广告哦" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [alerView show];
}
void TopImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number;
    switch (section) {
        case 0:
        {
            number=1;
        }
            break;
        case 1:
        {
            number=1;
        }
            break;
        case 2:
        {
            number=5;
        }
            break;
    }
    return number;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    float height;
    switch (indexPath.section) {
        case 0:
        {
            height=140.0;
        }
            break;
        case 1:
        {
            height=102.0;
        }
            break;
        case 2:
        {
            height=78.0;
        }
            break;
    }
    return height;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
        headerView.backgroundColor=[UIColor clearColor];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 96, 33)];
        label.text=@"热门商城推荐";
        label.font=[UIFont fontWithName:@"Arial" size:14];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor darkGrayColor];
        [headerView addSubview:label];
        UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame=CGRectMake(272, 0, 38, 35);
        [moreButton setBackgroundImage:[UIImage imageNamed:@"首页-更多"] forState:UIControlStateNormal];
        [headerView addSubview:moreButton];
        return headerView;
    }else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 33;
    }else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    switch (indexPath.section) {
        case 0:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:sv];
            [cell addSubview:page];
        }
            break;
        case 1:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIButton *qiandaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 0, 216/2, 56/2)];
            [qiandaoBtn addTarget:self action:@selector(qiandaoServer:) forControlEvents:UIControlEventTouchUpInside];
            [qiandaoBtn setImage:[UIImage imageNamed:@"qiandaoBtn"] forState:UIControlStateNormal];
            [cell addSubview:qiandaoBtn];
            UIButton *helperBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 32, 218/2, 120/2)];
            [helperBtn addTarget:self action:@selector(qiandaoServer:) forControlEvents:UIControlEventTouchUpInside];
            [helperBtn setImage:[UIImage imageNamed:@"返利教程"] forState:UIControlStateNormal];
            [cell addSubview:helperBtn];

        }
            break;
        case 2:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //商城左
            NSDictionary *storeDic1=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:indexPath.row*3]];
            UIView *btnView1=[[UIView alloc] initWithFrame:CGRectMake(10, 0, 95, 55)];
            btnView1.backgroundColor=[UIColor whiteColor];
            UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame=CGRectMake(0,5, 95, 50);
            button1.tag=indexPath.row*3;
            NSString *imageUrl1=[NSString stringWithFormat:@"%@",[storeDic1 objectForKey:@"logo"]];
            imageUrl1=[imageUrl1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([imageUrl1 rangeOfString:@"http://www.Cosji.com/"].location==NSNotFound) {
                imageUrl1=[NSString stringWithFormat:@"http://www.Cosji.com/%@",imageUrl1];
            }
            TopImageFromURL([NSURL URLWithString:imageUrl1], ^( UIImage * image )
                            {
                                [button1 setBackgroundImage:image forState:UIControlStateNormal];
                            }, ^(void){
                            });
            [button1 addTarget:self action:@selector(opRemenshangcheng:) forControlEvents:UIControlEventTouchUpInside];
            [btnView1 addSubview:button1];
            [cell addSubview:btnView1];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 55, 95, 20)];
            label.adjustsFontSizeToFitWidth=YES;
            label.backgroundColor=[UIColor lightTextColor];
            label.text=[NSString stringWithFormat:@"最高返利%@",[storeDic1 objectForKey:@"profit" ]];
            [btnView1 addSubview:label];
            //商城中
            NSDictionary *storeDic2=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:indexPath.row*3+1]];
            UIView *btnView2=[[UIView alloc] initWithFrame:CGRectMake(112.5, 0, 95, 55)];
            btnView2.backgroundColor=[UIColor whiteColor];
            UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame=CGRectMake(0, 5, 95, 50);
            button2.tag=indexPath.row*3+1;
            NSString *imageUrl2=[NSString stringWithFormat:@"%@",[storeDic2 objectForKey:@"logo"]];
            imageUrl2=[imageUrl2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([imageUrl2 rangeOfString:@"http://www.Cosji.com/"].location==NSNotFound) {
                imageUrl2=[NSString stringWithFormat:@"http://www.Cosji.com/%@",imageUrl2];
            }

            TopImageFromURL([NSURL URLWithString:imageUrl2], ^( UIImage * image )
                            {
                                [button2 setBackgroundImage:image forState:UIControlStateNormal];
                            }, ^(void){
                            });
            [button2 addTarget:self action:@selector(opRemenshangcheng:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 55, 95, 20)];
            label2.adjustsFontSizeToFitWidth=YES;
            label2.backgroundColor=[UIColor lightTextColor];
            label2.text=[NSString stringWithFormat:@"最高返利%@",[storeDic2 objectForKey:@"profit" ]];
            [btnView2 addSubview:button2];
            [btnView2 addSubview:label2];
            //商城右
            NSDictionary *storeDic3=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:indexPath.row*3+2]];
            UIView *btnView3=[[UIView alloc] initWithFrame:CGRectMake(215, 0, 95, 55)];
            btnView3.backgroundColor=[UIColor whiteColor];

            UIButton *button3=[UIButton buttonWithType:UIButtonTypeCustom];
            button3.frame=CGRectMake(0, 0, 95, 50);
            button3.tag=indexPath.row*3+2;
            NSString *imageUrl3=[NSString stringWithFormat:@"%@",[storeDic3 objectForKey:@"logo"]];
            imageUrl3=[imageUrl3 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([imageUrl3 rangeOfString:@"http://www.Cosji.com/"].location==NSNotFound) {
                imageUrl3=[NSString stringWithFormat:@"http://www.Cosji.com/%@",imageUrl3];
            }
            TopImageFromURL([NSURL URLWithString:imageUrl3], ^( UIImage * image )
                            {
                                [button3 setBackgroundImage:image forState:UIControlStateNormal];
                            }, ^(void){
                            });
            UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(0, 55, 95, 20)];
            label3.adjustsFontSizeToFitWidth=YES;
            label3.backgroundColor=[UIColor lightTextColor];
            label3.text=[NSString stringWithFormat:@"最高返利%@",[storeDic3 objectForKey:@"profit" ]];
            label.font=label2.font=label3.font=[UIFont fontWithName:@"Arial Hebrew" size:12];
            label.textAlignment=label2.textAlignment=label3.textAlignment=UITextAlignmentCenter;
            [btnView3 addSubview:button3];
            [btnView3 addSubview:label3];
            [button3 addTarget:self action:@selector(opRemenshangcheng:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnView2];
            [cell addSubview:btnView3];
        
        }
            break;
    }
    return cell;
}
    
-(void)qiandaoServer:(id)sender
{
    NSLog(@"qiandao");
    UIButton *butn=(UIButton*)sender;
    [butn.titleLabel setText:@"签到 +1"];
    
}
-(void)opRemenshangcheng:(id)sender
{
    selectedIndex=[sender tag];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"]isEqualToString:@"YES"]) {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
        NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"url"]];
        NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
        [self.storeBrowseViewController.webView loadRequest:request];
        [self.storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];

    }else
    {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"登陆" delegate:self cancelButtonTitle:@"跳过" destructiveButtonTitle:nil otherButtonTitles:@"登陆",nil];
        [actionSheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"case 0");
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
             [self presentViewController:loginViewController animated:YES completion:nil];
            
        }
            break;
            
        case 1:
        {
            NSLog(@"case 1");
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
            NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"url"]];
            NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];

        }
            break;
            
    }

}
-(void)closeAuthView{
    [nc dismissModalViewControllerAnimated:YES];
    nc = nil;
}
- (IBAction)exitKeyboard:(id)sender {
    [sender resignFirstResponder];
}
- (void)viewDidUnload {
    [self setCustomHeadView:nil];
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [MobileProbe pageEndWithName:@"首页"];
}
@end
