//
//  CosjiWebViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-7-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiWebViewController : UIViewController
{
    
}
+(CosjiWebViewController*)shareCosjiWebViewController;
@property (weak, nonatomic) IBOutlet UIView *customNavBar;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *userSetBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
