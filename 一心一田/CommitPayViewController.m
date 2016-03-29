//
//  CommitPayViewController.m
//  一心一田
//
//  Created by xipin on 16/3/29.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "CommitPayViewController.h"
#import "MutipleGoodsViewController.h"
@interface CommitPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *summoneylab;
- (IBAction)sureBtnClicked:(id)sender;

@end

@implementation CommitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认支付";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(backBtnClicked)];
    _summoneylab.text=_summoney;
}

-(void)backBtnClicked{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];

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

- (IBAction)sureBtnClicked:(id)sender {
    MutipleGoodsViewController *vc=[[MutipleGoodsViewController alloc]init];
    vc.order_id=_order_id;
    vc.isparent=@"1";
    vc.backtoprevious=2;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
