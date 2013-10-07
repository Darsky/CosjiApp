//
//  CosjiSettingViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-10-5.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiSettingViewController.h"

@interface CosjiSettingViewController ()

@end

@implementation CosjiSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        itemArray=[[NSArray alloc] initWithObjects:@"用户指南",@"返利问题",@"提现问题",@"常见问题",@"客服在线",@"意见反馈",@"清除缓存",@"检测更新",@"流量节省模式", nil];
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-系统设置-背景"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark tableviewmethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }else
    return 4;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 33)];
    switch (section) {
        case 0:
        {
            headerView.backgroundColor=[UIColor clearColor];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 96, 33)];
            label.text=[NSString stringWithFormat:@"新手帮助"];
            label.font=[UIFont fontWithName:@"Arial" size:14];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor darkGrayColor];
            [headerView addSubview:label];
            return headerView;
            
        }
            break;
        case 1:
        {
            headerView.backgroundColor=[UIColor clearColor];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 96, 33)];
            label.text=[NSString stringWithFormat:@"应用设置"];
            label.font=[UIFont fontWithName:@"Arial" size:14];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor darkGrayColor];
            [headerView addSubview:label];
            return headerView;
        }
            break;
    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==4)
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 30)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 80, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                UILabel *number=[[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 30)];
                number.text=@"400-00347-678";
                cellLabel.textColor=number.textColor=[UIColor lightTextColor];
                cellLabel.backgroundColor=number.backgroundColor=[UIColor clearColor];
                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];
                [cell addSubview:number];
   
            }else
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 30)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.textColor=[UIColor lightTextColor];

                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];

            }
        }
            break;
        case 1:
        {
            if (indexPath.row==3)
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 30)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+5]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+5]];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.textColor=[UIColor lightTextColor];
                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];
                
            }else
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 30)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+5]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+5]];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.textColor=[UIColor lightTextColor];

                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];
                
            }
        }
            break;
    }

    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
