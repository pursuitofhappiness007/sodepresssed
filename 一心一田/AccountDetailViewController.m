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
@property (strong, nonatomic) NSMutableArray *billArr;
@property (strong, nonatomic) NSMutableArray *icomeArr;
@property (strong, nonatomic) NSMutableArray *expenditureArr;
@end

@implementation AccountDetailViewController
- (NSMutableArray *)billArr{
    if (!_billArr) {
        _billArr = [[NSMutableArray alloc]init];
    }
    return  _billArr;
}

- (NSMutableArray *)icomeArr{
    if (!_icomeArr) {
        _icomeArr = [[NSMutableArray alloc]init];
    }
    return _icomeArr;
}

- (NSMutableArray *)expenditureArr{
    if (!_expenditureArr) {
        _expenditureArr = [[NSMutableArray alloc]init];
    }
    return  _expenditureArr;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单详情";
  self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(goBack)];
    self.selectedButton = self.firstbt;
    self.selectedButton.selected = YES;
    self.tableView.tableFooterView = [UIView new];
    [self getBillData];
}

- (void)getBillData{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    NSDictionary *dic = [[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"tokenfile.txt"];
    NSString *str = [dic stringForKey:@"token"];
    NSLog(@"token:%@", str);
    paras[@"token"] = [dic stringForKey:@"token"];
    [HttpTool post:@"obvious_bill" params:paras success:^(id responseObj) {
        NSLog(@"...........recharge message:%@",responseObj);
        if([responseObj int32ForKey:@"result"]==0){
            NSMutableArray *arr = [[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"tranFlowList"] ;
           self.billArr = [arr mutableCopy];
            for (int i = 0; i < self.billArr.count; i ++) {
                NSDictionary *dic = self.billArr[i];
                NSLog(@"%@",dic);
                if ([dic doubleForKey:@"acBal"] < 0) {
                    NSLog(@"%f", [dic doubleForKey:@"acBal"]);
                    [self.expenditureArr addObject:dic];
                }else{
                    [self.icomeArr addObject:dic];
                      NSLog(@"%f", [dic doubleForKey:@"acBal"]);
                }
            }
            if (!self.billArr.count) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText=@"暂无账单！";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.2];
            }
            [self.tableView reloadData];
            NSLog(@"获取数据成功");
            return;
        } else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText=@"网络繁忙，请稍后再试";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.2];
        }
    } failure:^(NSError *error) {
        NSLog(@"网络繁忙，请稍后再试");
        NSLog(@"%@", error);
    } controler:self];

}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.selectedButton.tag) {
        case 0:
            return self.billArr.count;
            break;
        case 1:
            return self.icomeArr.count;
            break;
        case 2:
            return self.expenditureArr.count;
        break;
        default:
            return 0;
            break;
    }
 
    
}

#pragma mark - tableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view= [UIView new];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.selectedButton.tag) {
        case 0:
        {
            
                NSDictionary *dic = self.billArr[indexPath.row];
                if ([dic int32ForKey:@"acBal"] < 0) {
                      static NSString *CellIdentifier = @"businessdeal";
                      AcountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                     {
                        cell= [[[NSBundle  mainBundle] loadNibNamed:@"AcountDetailTableViewCell" owner:self options:nil]  lastObject];
                         cell.remarkLb.text = [dic stringForKey:@"remark"];
                         cell.timeLb.text = [dic stringForKey:@"addTime"];
                         cell.acBalLb.text = [NSString stringWithFormat:@"%@",[dic stringForKey:@"acBal"]];
                         cell.amountLb.text = [NSString stringWithFormat:@"账户余额: %@",[dic stringForKey:@"amount"]];
                     }
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                } else{
                        static NSString *CellIdentifier = @"recharge";
                        RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil)
                        {
                            cell= [[[NSBundle  mainBundle] loadNibNamed:@"RechargeCell" owner:self options:nil]  lastObject];
                            cell.remarkLb.text = [dic stringForKey:@"remark"];
                            cell.timeLb.text = [dic stringForKey:@"addTime"];
                            cell.acBalLb.text = [NSString stringWithFormat:@"%@",[dic stringForKey:@"acBal"]];
                        }
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                    }
            }
            break;
            
        case 1:
        {
            
            NSDictionary *dic = self.icomeArr[indexPath.row];
            static NSString *CellIdentifier = @"businessdeal";
            AcountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell= [[[NSBundle  mainBundle] loadNibNamed:@"AcountDetailTableViewCell" owner:self options:nil]  lastObject];
                cell.remarkLb.text = [dic stringForKey:@"remark"];
                cell.timeLb.text = [dic stringForKey:@"addTime"];
                cell.acBalLb.text = [NSString stringWithFormat:@"%@",[dic stringForKey:@"acBal"]];
                cell.amountLb.text = [NSString stringWithFormat:@"账户余额: %@",[dic stringForKey:@"amount"]];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;

        case 2:
        {
            NSDictionary *dic = self.expenditureArr[indexPath.row];
            static NSString *CellIdentifier = @"recharge";
            RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell= [[[NSBundle  mainBundle] loadNibNamed:@"RechargeCell" owner:self options:nil]  lastObject];
                cell.remarkLb.text = [dic stringForKey:@"remark"];
                cell.timeLb.text = [dic stringForKey:@"addTime"];
                 cell.acBalLb.text = [NSString stringWithFormat:@"%@",[dic stringForKey:@"acBal"]];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
                      default:
            return 0;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
