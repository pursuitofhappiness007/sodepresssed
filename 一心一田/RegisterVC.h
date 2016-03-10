//
//  RegisterVC.h
//  广盐健康大厨房
//
//  Created by xipin on 15/12/3.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernametextfield;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *msgcodetf;
@property (weak, nonatomic) IBOutlet UITextField *provicetf;
@property (weak, nonatomic) IBOutlet UITextField *whorecommendphonetf;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *lastcellincontainer;
@property (weak, nonatomic) IBOutlet UITextField *customermanagertf;
- (IBAction)registerBtnClicked:(id)sender;

- (IBAction)gainmsgcodeBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gainmsgcodeBtn;
- (IBAction)chooseprovinceBtnClicked:(id)sender;

@end
