//
//  CosjiLoginViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-10-4.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CosjiLoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *CustomNarBar;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
+(CosjiLoginViewController*)shareCosjiLoginViewController;
@end
