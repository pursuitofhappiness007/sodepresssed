//
//  PersonalInfomationViewController.m
//  一心一田
//
//  Created by xipin on 16/3/9.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "PersonalInfomationViewController.h"

@interface PersonalInfomationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *personalIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernamelab;
@property (weak, nonatomic) IBOutlet UILabel *phone1lab;
@property (weak, nonatomic) IBOutlet UILabel *phone2lab;
@property (weak, nonatomic) IBOutlet UILabel *phone3lab;
- (IBAction)exitLoginBtnClicked:(id)sender;

@end

@implementation PersonalInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exitLoginBtnClicked:(id)sender {
}
@end
