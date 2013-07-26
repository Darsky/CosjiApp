//
//  CosjiTaoBaoFanliViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiTaoBaoFanliViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *kindsListArray;
    NSMutableArray *kindsImageArray;
    NSMutableArray *kindsDescriptionArray;
    NSMutableArray *ObjectsArray;
    int selectedSection;
    int selectSection;
}

@property (nonatomic,strong)IBOutlet UITableView *tableView;


@end
