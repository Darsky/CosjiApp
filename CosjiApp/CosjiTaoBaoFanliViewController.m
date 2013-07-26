//
//  CosjiTaoBaoFanliViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiTaoBaoFanliViewController.h"

@interface CosjiTaoBaoFanliViewController ()

@end

@implementation CosjiTaoBaoFanliViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        kindsListArray=[[NSMutableArray alloc] initWithObjects:@"服装服饰",@"箱包服饰",@"数码家电",@"美容护服",@"母婴用品",@"家居建材",@"食品百货",@"户外&汽车",@"文化玩乐",@"生活服务",nil];;
        kindsImageArray=[[NSMutableArray alloc] initWithObjects:@"fuzhuangfushi",@"xiangbaofushi",@"shumajiadian",@"meironghufu",@"muyingyongpin",@"jiajujiancai",@"shipinbaihuo",@"huwai",@"wenhuawanle",@"shenghuofuwu", nil];
        kindsDescriptionArray=[[NSMutableArray alloc] initWithObjects:@"2013我的鞋日记，女鞋新品8折包邮！",@"精选包包每日上新，多重折扣享受！",@"2012数码相机新品展销会，各类时尚新品全面到货",@"她跟他还有它都收啦！今夏HOT瘦身单品全搜罗",@"各种各样婴儿跟孕妇用品/玩具/天天上新",@"超低价折扣家具！家居装饰轻松搞定",@"一站式购物，大型综合百货超市为您服务",@"假日出游、户外活动整装待发",@"为爱宠打扮打扮，Show出你萌萌的宠物宝宝!",@"享受生活便捷！电影新片在线抢票", nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectSection=99;
}
#pragma mark -tableview datasource




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
    return [kindsListArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *dotView=[[UIImageView alloc] initWithFrame:CGRectMake(10,0, 70, 70)];
            [dotView setImage:[UIImage imageNamed:[kindsImageArray objectAtIndex:indexPath.section]]];
            [cell addSubview:dotView];
            UILabel *kindName=[[UILabel alloc] init];
            kindName.frame=CGRectMake(90, 20, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
            kindName.backgroundColor=[UIColor clearColor];
            kindName.font=[UIFont fontWithName:@"Arial Hebrew" size:20];
            kindName.textColor=[UIColor blackColor];
            [kindName setText:[kindsListArray objectAtIndex:indexPath.section]];
            [cell addSubview:kindName];
            UILabel *kindDesp=[[UILabel alloc] init];
            kindDesp.frame=CGRectMake(200, 20, 100, cell.contentView.frame.size.height);
            kindDesp.backgroundColor=[UIColor clearColor];
            kindDesp.font=[UIFont fontWithName:@"Arial Hebrew" size:12];
            [kindDesp setNumberOfLines:0];
            kindDesp.textColor=[UIColor darkGrayColor];
            [kindDesp setText:[kindsDescriptionArray objectAtIndex:indexPath.section]];
            [cell addSubview:kindDesp];
       

        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
    }
         return cell;
}
#pragma mark -tableview delegate



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section!=selectSection) {
            selectedSection=selectSection;
            selectSection=99;
            if (selectedSection!=99) {
                NSLog(@"delete %d",selectedSection);
                NSArray *path=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:selectedSection],[NSIndexPath indexPathForRow:2 inSection:selectedSection],nil];
                [self.tableView deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationAutomatic];
                //[self performSelector:@selector(TablereloadData) withObject:self afterDelay:0.15];
            }
            selectSection=indexPath.section;
            self.tableView.userInteractionEnabled=NO;
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
                [self.tableView deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationAutomatic];
                [self performSelector:@selector(TablereloadData) withObject:self afterDelay:0.2];
            }
            
        }
}
-(void)setContentOff
{
    NSLog(@"%d setcontent",selectSection);
    
    CGPoint point=CGPointMake(0,70*(selectSection));
    /*
     [self.mainTableView beginUpdates];
     [self.mainTableView endUpdates];
     */
    [self.tableView setContentOffset:point animated:YES];
    [self performSelector:@selector(addRows) withObject:nil afterDelay:0.3];
}
-(void)TablereloadData
{
    [self.tableView reloadData];
}



-(void)addRows
{
    NSLog(@"%d addRows",selectSection);
    // [self.mainTableView reloadData];
    NSArray *indexes=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:selectSection],[NSIndexPath indexPathForRow:2 inSection:selectSection],nil];
    [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
    self.tableView.userInteractionEnabled=YES;
    // CGPoint point=CGPointMake(0,40*(selectSection-1));
    //  [self.mainTableView setContentOffset:point animated:NO];
    [self performSelector:@selector(TablereloadData) withObject:self afterDelay:0.3];
    // [self performSelector:@selector(resetTableView:) withObject:self.tableView afterDelay:0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
