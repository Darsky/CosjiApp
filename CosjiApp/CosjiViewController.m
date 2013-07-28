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
@synthesize tabitemBack,homeBtn,taoBaoBtn,activityBtn,mineBtn;
@synthesize customTabBar;
@synthesize mainTableView,CustomHeadView;
@synthesize storeBrowseViewController;

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
    self.storeBrowseViewController=[[CosjiWebViewController alloc] initWithNibName:@"CosjiWebViewController" bundle:nil];
      self.navigationController.navigationBarHidden=YES;
    selectSection=99;


    
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
    [sv setContentSize:CGSizeMake(320*[arr count], 160)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[topListArray count]; i++) {
        
        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 320, 160)];
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
                           } else {
                               errorBlock();
                           }
                       });
                   });
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==selectSection) {
        return 3;
    }else
    {
         return 1;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section==0)
   {
       return 160;
   }else
   {
       if (indexPath.section==1)
       {
           return 40;
       }else
           if (indexPath.section==selectSection) {
               if(indexPath.row==0)
               return 40;
               else
                   return 80;
           }else
           return 50;

   }
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
            UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 155, 320, 5)];
            lineImage.image=[UIImage imageNamed:@"speretorLine.png"];
            [cell addSubview:lineImage];
        }
            break;
        case 1:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIButton *qiandaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 8, 110, 23)];
            [qiandaoBtn addTarget:self action:@selector(qiandaoServer:) forControlEvents:UIControlEventTouchUpInside];
            [qiandaoBtn setTitle:@"签到" forState:UIControlStateNormal];
            [qiandaoBtn setImage:[UIImage imageNamed:@"qindaoBtn"] forState:UIControlStateNormal];
            [cell addSubview:qiandaoBtn];
            UIButton *helperBtn=[[UIButton alloc]initWithFrame:CGRectMake(200, 8, 110, 23)];
            [helperBtn addTarget:self action:@selector(qiandaoServer:) forControlEvents:UIControlEventTouchUpInside];
            [helperBtn setTitle:@"返利助手" forState:UIControlStateNormal];
            [helperBtn setImage:[UIImage imageNamed:@"helperBtn"] forState:UIControlStateNormal];
            [cell addSubview:helperBtn];

        }
            break;
        case 2:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIButton *taobaoStoreBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [taobaoStoreBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
            [taobaoStoreBtn setBackgroundImage:[UIImage imageNamed:@"taobaoStore"] forState:UIControlStateNormal];
            [taobaoStoreBtn setTag:0];
            taobaoStoreBtn.frame=CGRectMake(10, 5, 90, 40);
            UIButton *tmallStoreBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [tmallStoreBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
            [tmallStoreBtn setBackgroundImage:[UIImage imageNamed:@"tmailStore"] forState:UIControlStateNormal];
            [tmallStoreBtn setTag:1];
            tmallStoreBtn.frame=CGRectMake(115, 5, 90, 40);
            UIButton *juhuasuanStoreBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [juhuasuanStoreBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
            [juhuasuanStoreBtn setBackgroundImage:[UIImage imageNamed:@"juhuasuanStore"] forState:UIControlStateNormal];
            [juhuasuanStoreBtn setTag:2];
            juhuasuanStoreBtn.frame=CGRectMake(220, 5, 90, 40);
            [cell addSubview:taobaoStoreBtn];
            [cell addSubview:tmallStoreBtn];
            [cell addSubview:juhuasuanStoreBtn];
        }
            break;
        case 3:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            if (selectSection==indexPath.section) {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened"];
                        [cell addSubview:cellBG];
                        UILabel *kindName=[[UILabel alloc] init];
                        kindName.frame=CGRectMake(15, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                        kindName.backgroundColor=[UIColor clearColor];
                        kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                        kindName.textColor=[UIColor grayColor];
                        [kindName setText:@"团购返利"];
                        [cell addSubview:kindName];

                    }
                        break;
                    case 1:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened1"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                    case 2:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 70)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened2"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                }
            }else
            {
                UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
                cellBG.image=[UIImage imageNamed:@"cellBGclosed"];
                [cell addSubview:cellBG];
                UILabel *kindName=[[UILabel alloc] init];
                kindName.frame=CGRectMake(15, 5, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                kindName.backgroundColor=[UIColor clearColor];
                kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                kindName.textColor=[UIColor grayColor];
                [kindName setText:@"团购返利"];
                [cell addSubview:kindName];

            }
        }
            break;
        case 4:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

            if (selectSection==indexPath.section) {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened"];
                        [cell addSubview:cellBG];
                        UILabel *kindName=[[UILabel alloc] init];
                        kindName.frame=CGRectMake(15, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                        kindName.backgroundColor=[UIColor clearColor];
                        kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                        kindName.textColor=[UIColor grayColor];
                        [kindName setText:@"母婴教育"];
                        [cell addSubview:kindName];
                        
                    }
                        break;
                    case 1:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened1"];
                        [cell addSubview:cellBG];

                    }
                        break;
                    case 2:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 70)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened2"];
                        [cell addSubview:cellBG];

                    }
                        break;
                }

                
            }else
            {
                UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
                cellBG.image=[UIImage imageNamed:@"cellBGclosed"];
                [cell addSubview:cellBG];
                UILabel *kindName=[[UILabel alloc] init];
                kindName.frame=CGRectMake(15, 5, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                kindName.backgroundColor=[UIColor clearColor];
                kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                kindName.textColor=[UIColor grayColor];
                [kindName setText:@"母婴教育"];
                [cell addSubview:kindName];

            }
        }
            break;
        case 5:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

            if (selectSection==indexPath.section) {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened"];
                        [cell addSubview:cellBG];
                        UILabel *kindName=[[UILabel alloc] init];
                        kindName.frame=CGRectMake(15, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                        kindName.backgroundColor=[UIColor clearColor];
                        kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                        kindName.textColor=[UIColor grayColor];
                        [kindName setText:@"家庭生活"];
                        [cell addSubview:kindName];
                        
                    }
                        break;
                    case 1:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened1"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                    case 2:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 70)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened2"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                }

                
            }else
            {
                UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
                cellBG.image=[UIImage imageNamed:@"cellBGclosed"];
                [cell addSubview:cellBG];
                UILabel *kindName=[[UILabel alloc] init];
                kindName.frame=CGRectMake(15, 5, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                kindName.backgroundColor=[UIColor clearColor];
                kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                kindName.textColor=[UIColor grayColor];
                [kindName setText:@"家庭生活"];
                [cell addSubview:kindName];

            }
        }
            break;
        case 6:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

            if (selectSection==indexPath.section) {
                
                switch (indexPath.row) {
                    case 0:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened"];
                        [cell addSubview:cellBG];
                        UILabel *kindName=[[UILabel alloc] init];
                        kindName.frame=CGRectMake(15, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                        kindName.backgroundColor=[UIColor clearColor];
                        kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                        kindName.textColor=[UIColor grayColor];
                        [kindName setText:@"美容化妆"];
                        [cell addSubview:kindName];
                        
                    }
                        break;
                    case 1:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened1"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                    case 2:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 70)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened2"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                }

            }else
            {
                UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
                cellBG.image=[UIImage imageNamed:@"cellBGclosed"];
                [cell addSubview:cellBG];
                UILabel *kindName=[[UILabel alloc] init];
                kindName.frame=CGRectMake(15, 5, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                kindName.backgroundColor=[UIColor clearColor];
                kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                kindName.textColor=[UIColor grayColor];
                [kindName setText:@"美容化妆"];
                [cell addSubview:kindName];

            }
        }
            break;
        case 7:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

            if (selectSection==indexPath.section) {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened"];
                        [cell addSubview:cellBG];
                        UILabel *kindName=[[UILabel alloc] init];
                        kindName.frame=CGRectMake(15, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                        kindName.backgroundColor=[UIColor clearColor];
                        kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                        kindName.textColor=[UIColor grayColor];
                        [kindName setText:@"数码家电"];
                        [cell addSubview:kindName];
                        
                    }
                        break;
                    case 1:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened1"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                    case 2:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 70)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened2"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                }

                
            }else
            {
                UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
                cellBG.image=[UIImage imageNamed:@"cellBGclosed"];
                [cell addSubview:cellBG];
                UILabel *kindName=[[UILabel alloc] init];
                kindName.frame=CGRectMake(15, 5, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                kindName.backgroundColor=[UIColor clearColor];
                kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                kindName.textColor=[UIColor grayColor];
                [kindName setText:@"数码家电"];
                [cell addSubview:kindName];

            }
        }
            break;
        case 8:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

            if (selectSection==indexPath.section) {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened"];
                        [cell addSubview:cellBG];
                        UILabel *kindName=[[UILabel alloc] init];
                        kindName.frame=CGRectMake(15, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                        kindName.backgroundColor=[UIColor clearColor];
                        kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                        kindName.textColor=[UIColor grayColor];
                        [kindName setText:@"服饰鞋包"];
                        [cell addSubview:kindName];
                        
                    }
                        break;
                    case 1:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened1"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                    case 2:
                    {
                        UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 70)];
                        cellBG.image=[UIImage imageNamed:@"cellBGopened2"];
                        [cell addSubview:cellBG];
                        
                    }
                        break;
                }

            }else
            {
                UIImageView *cellBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
                cellBG.image=[UIImage imageNamed:@"cellBGclosed"];
                [cell addSubview:cellBG];
                UILabel *kindName=[[UILabel alloc] init];
                kindName.frame=CGRectMake(15, 5, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
                kindName.backgroundColor=[UIColor clearColor];
                kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
                kindName.textColor=[UIColor grayColor];
                [kindName setText:@"服饰鞋包"];
                [cell addSubview:kindName];

            }
        }
            break;
            /*
        default:
        {
            int rowNumber=(indexPath.section-2)*3;
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
             */
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
-(void)presentStoreBrowseViewController:(id)sender
{
    NSLog(@"%d",[sender tag]);
    switch ([sender tag]) {
        case 0:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self.navigationController pushViewController:storeBrowseViewController animated:YES];
            [storeBrowseViewController.webView loadRequest:request];
            [storeBrowseViewController.storeName setText:@"淘宝网"];
        }
            break;
        case 1:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.tmall.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self.navigationController pushViewController:storeBrowseViewController animated:YES];
            [storeBrowseViewController.webView loadRequest:request];
            [storeBrowseViewController.storeName setText:@"天猫"];
        }
            break;
        case 2:
        {
            NSURL *url =[NSURL URLWithString:@"http://ju.m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self.navigationController pushViewController:storeBrowseViewController animated:YES];
            [storeBrowseViewController.webView loadRequest:request];
            [storeBrowseViewController.storeName setText:@"聚划算"];
        }
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>2) {
    if (indexPath.section!=selectSection) {
        selectedSection=selectSection;
        selectSection=99;
        if (selectedSection!=99) {
            NSLog(@"delete %d",selectedSection);
            NSArray *path=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:selectedSection],[NSIndexPath indexPathForRow:2 inSection:selectedSection],nil];
            [self.mainTableView deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self performSelector:@selector(TablereloadData) withObject:self afterDelay:0.15];
        }
        selectSection=indexPath.section;
        self.mainTableView.userInteractionEnabled=NO;
        /*
         [self.mainTableView beginUpdates];
         [self.mainTableView endUpdates];*/
        [self performSelector:@selector(setContentOff) withObject:nil afterDelay:0.2];

    }else
    {
        selectedSection=selectSection;
        selectSection=99;
        if (selectedSection!=99) {
            NSLog(@"delete %d",selectedSection);
            NSArray *path=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:selectedSection],[NSIndexPath indexPathForRow:2 inSection:selectedSection],nil];
            [self.mainTableView deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationAutomatic];
            [self performSelector:@selector(TablereloadData) withObject:self afterDelay:0.2];
        }

    }
    }
}
-(void)setContentOff
{
    NSLog(@"%d setcontent",selectSection);
    
    CGPoint point=CGPointMake(0,40*(selectSection-1));
    /*
    [self.mainTableView beginUpdates];
    [self.mainTableView endUpdates];
    */
    [self.mainTableView setContentOffset:point animated:YES];
    [self performSelector:@selector(addRows) withObject:nil afterDelay:0.3];
}
-(void)TablereloadData
{
    [self.mainTableView reloadData];
}



-(void)addRows
{
    NSLog(@"%d addRows",selectSection);
   // [self.mainTableView reloadData];
    NSArray *indexes=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:selectSection],[NSIndexPath indexPathForRow:2 inSection:selectSection],nil];
    [self.mainTableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
    self.mainTableView.userInteractionEnabled=YES;
   // CGPoint point=CGPointMake(0,40*(selectSection-1));
  //  [self.mainTableView setContentOffset:point animated:NO];
    [self performSelector:@selector(TablereloadData) withObject:self afterDelay:0.3];
    // [self performSelector:@selector(resetTableView:) withObject:self.tableView afterDelay:0];
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
    [self setActivityBtn:nil];
    [self setMineBtn:nil];
    [self setCustomTabBar:nil];
    [self setCustomHeadView:nil];
    [super viewDidUnload];
}
@end
