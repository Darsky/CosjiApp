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
@synthesize mainTableView,CustomHeadView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tabBarController.view addSubview:self.customTabBar];
    topListArray=[[NSMutableArray alloc] initWithObjects:@"mainNews1.png",@"mainNews2.png", nil];
    storeListArray=[[NSMutableArray alloc] initWithObjects:@"jingdongLogo.png",@"jumeiLogo.jpg",@"weipinhuiLogo.png",@"lefengLogo.png",@"nuomiLogo.jpg",@"mengbashaLogo.jpg",@"yamaxunLogo.jpg",@"yihaodianLogo.png", nil];
    brandListArray=[[NSMutableArray alloc] initWithObjects:@"BelloLogo.png",@"chaberLogo.jpg",@"GAPLogo.jpg",@"hongqingtingLogo.jpg",@"nuoqiLogo.jpg",@"qipilangLogo.jpg",@"SCJLogo.jpg",@"taipingniaoLogo.jpg",@"xiangyingLogo.jpg", nil];
    page=[[UIPageControl alloc] initWithFrame:CGRectMake(260, 100, 38,36)];
    //page.center=CGPointMake(160, 126);
    sv=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    sv.delegate=self;
    sv.showsHorizontalScrollIndicator=NO;
    sv.backgroundColor=[UIColor clearColor];
    [CustomHeadView layer].shadowPath =[UIBezierPath bezierPathWithRect:CustomHeadView.bounds].CGPath;
    self.CustomHeadView.layer.shadowColor=[[UIColor blackColor] CGColor];
    self.CustomHeadView.layer.shadowOffset=CGSizeMake(0,0);
    self.CustomHeadView.layer.shadowRadius=10.0;
    self.CustomHeadView.layer.shadowOpacity=1.0;
    self.homeBtn.contentHorizontalAlignment=self.taoBaoBtn.contentHorizontalAlignment=self.activityBtn.contentHorizontalAlignment=self.mineBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    [self AdImg:topListArray];
    [self setCurrentPage:page.currentPage];
    


    
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
        size.height = 24/2;
        size.width = 24/2;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        
        if (subviewIndex == secondPage) [subview setImage:[UIImage imageNamed:@"rolling_selected"]];
        else [subview setImage:[UIImage imageNamed:@"rolling_unselected"]];
        
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
    [sv setContentSize:CGSizeMake(320*[arr count], 140)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[topListArray count]; i++) {
        
        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 320, 140)];
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
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}

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
   if(indexPath.row==0)
   {
       return 160;
   }
    if (indexPath.row==1)
    {
        return 40;
    }
    if (indexPath.row==2||indexPath.row==3||indexPath.row==4)
    {
        return 80;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    switch (indexPath.row) {
        case 0:
        {
            [cell addSubview:sv];
            [cell addSubview:page];
            UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 155, 320, 5)];
            lineImage.image=[UIImage imageNamed:@"speretorLine.png"];
            [cell addSubview:lineImage];
        }
            break;
        case 1:
        {
            UIButton *qiandaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 8, 110, 23)];
            [qiandaoBtn addTarget:self action:@selector(qiandaoServer:) forControlEvents:UIControlEventTouchUpInside];
            [qiandaoBtn.titleLabel setText:@"签到"];
            [qiandaoBtn setBackgroundImage:[UIImage imageNamed:@"qindaoBtn"] forState:UIControlStateNormal];
            [cell addSubview:qiandaoBtn];
                }
            break;
            
        default:
        {
            int rowNumber=(indexPath.row-2)*3;
            if (rowNumber<[storeListArray count]-1) {
                NSLog(@"cellSet");
                UIButton *img1=[[UIButton alloc]initWithFrame:CGRectMake(10, 15, 87, 30)];
                [img1 addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:img1];
                [img1 setImage:[UIImage imageNamed:[storeListArray objectAtIndex:rowNumber]] forState:UIControlStateNormal];
            }
            if (rowNumber+1<[storeListArray count]-1) {
                NSLog(@"cellSet");
                UIButton *img2=[[UIButton alloc]initWithFrame:CGRectMake(116.5, 15, 87, 30)];
                [img2 addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:img2];
                [img2 setImage:[UIImage imageNamed:[storeListArray objectAtIndex:rowNumber+1]] forState:UIControlStateNormal];

            }
            if (rowNumber+2<[storeListArray count]-1)
            {
                NSLog(@"cellSet");
                UIButton *img3=[[UIButton alloc]initWithFrame:CGRectMake(223, 15, 87, 30)];
                [img3 addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:img3];
                [img3 setImage:[UIImage imageNamed:[storeListArray objectAtIndex:rowNumber+2]] forState:UIControlStateNormal];
            }
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
        self.tabitemBack.frame=CGRectMake([sender tag]*80, 0, 80, 44);
        
    }];
}
-(void)closeAuthView{
    [nc dismissModalViewControllerAnimated:YES];
    nc = nil;
}
- (IBAction)exitKeyboard:(id)sender {
    [sender resignFirstResponder];
}
- (void)viewDidUnload {
    [self setTabitemBack:nil];
    [self setHomeBtn:nil];
    [self setTaoBaoBtn:nil];
    [self setStoreBtn:nil];
    [self setActivityBtn:nil];
    [self setMineBtn:nil];
    [self setCustomTabBar:nil];
    [self setCustomHeadView:nil];
    [super viewDidUnload];
}
@end
