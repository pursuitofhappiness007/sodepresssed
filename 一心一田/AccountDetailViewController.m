//
//  AccountDetailViewController.m
//  一心一田
//
//  Created by user on 16/3/9.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "AcountDetailTableViewCell.h"
#import "RechargeCell.h"
@interface AccountDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeadingConstrains;
@property (weak, nonatomic) IBOutlet UIButton *firstbt;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedButton = self.firstbt;
    self.selectedButton.selected = YES;
}

#pragma mark - UITableViewataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.selectedButton.tag) {
        case 0:
        {
            static NSString *CellIdentifier = @"businessdeal";
            AcountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell= [[[NSBundle  mainBundle] loadNibNamed:@"AcountDetailTableViewCell" owner:self options:nil]  lastObject];
            }
            
            return cell;
        }
            break;
        case 1:
        {
            static NSString *CellIdentifier = @"businessdeal";
            AcountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell= [[[NSBundle  mainBundle] loadNibNamed:@"AcountDetailTableViewCell" owner:self options:nil]  lastObject];
            }
            
            return cell;        }
            break;
        case 2:
        {
            static NSString *CellIdentifier = @"recharge";
            RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell= [[[NSBundle  mainBundle] loadNibNamed:@"RechargeCell" owner:self options:nil]  lastObject];
            }
            return cell;
        }
            break;
        default:
            return 0;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}
- (IBAction)ButtonClicked:(UIButton *)sender {
    self.selectedButton.selected = NO;
    self.selectedButton = sender;
    self.selectedButton.selected = YES;
    self.labelLeadingConstrains.constant =  5+self.firstbt.frame.size.width*sender.tag;
    [self updateViewConstraints];
    [self.tableView reloadData];
    
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

@end
