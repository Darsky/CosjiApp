//
//  CosjiViewController.h
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreKit/SKProductsRequest.h"

@interface CosjiViewController : UIViewController<SKProductsRequestDelegate>
@property (weak, nonatomic) IBOutlet UIView *tabitemBack;
@property (copy,nonatomic) NSMutableArray * userIds;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *taoBaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
@property (weak, nonatomic) IBOutlet UIButton *mineBtn;
@property (weak, nonatomic) IBOutlet UIView *customTabBar;


@end
