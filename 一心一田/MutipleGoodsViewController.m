//
//  MutipleGoodsViewController.m
//  kitchen
//
//  Created by xipin on 15/12/23.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "MutipleGoodsViewController.h"
#import "OrderllistTableViewCell.h"
#import "WXApiManager.h"
@interface MutipleGoodsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *goodslist;
    int statusoforder;
    UIView *dimview;
    MBProgressHUD *hud1;
}
@property (weak, nonatomic) IBOutlet UILabel *totaltopaylab;
@property (weak, nonatomic) IBOutlet UILabel *receiverlab;
@property (weak, nonatomic) IBOutlet UILabel *addresslab;
@property (weak, nonatomic) IBOutlet UILabel *ordercodelab;
@property (weak, nonatomic) IBOutlet UILabel *orderdealtimelab;
@property (weak, nonatomic) IBOutlet UILabel *statuslab;
@property (weak, nonatomic) IBOutlet UIImageView *statusimgview;
@property (weak, nonatomic) IBOutlet UILabel *phonelab;
@property (weak, nonatomic) IBOutlet UITableView *orderdetailtableview;
- (IBAction)receivegoodBtnClicked:(UIButton *)sender;
- (IBAction)cancelorderBtnClicked:(UIButton *)sender;
- (IBAction)payBtnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelorderBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation MutipleGoodsViewController

-(void)viewWillAppear:(BOOL)animated{
    if([WXApi isWXAppInstalled]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paysucceedoption) name:@"paysucceed" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payfailedoption) name:@"payfailed" object:nil];
    }
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"订单详情";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
    
    goodslist=[_orderinfo arrayForKey:@"goods_details"];
    NSLog(@"订单详情中的数组=%@",goodslist);
    [self setlocalcontent];
}

-(void)setlocalcontent{
    statusoforder=[[_orderinfo dictionaryForKey:@"orderHead"]int32ForKey:@"businessStatus"];
    _totaltopaylab.text=[NSString stringWithFormat:@"订单金额(含运费)¥%@",[[_orderinfo dictionaryForKey:@"orderHead"] stringForKey:@"totalAmount"]];
    _statuslab.text=[[_orderinfo dictionaryForKey:@"orderHead"] stringForKey:@"businessStatusInfo"];
    
    _receiverlab.text=[NSString stringWithFormat:@"收货人:%@",[[_orderinfo dictionaryForKey:@"order_delivery_info"] stringForKey:@"consignee"]];
    _addresslab.text=[[_orderinfo dictionaryForKey:@"order_delivery_info"] stringForKey:@"area_name"];
    
    _ordercodelab.text=[NSString stringWithFormat:@"订单编号:%@",[[_orderinfo dictionaryForKey:@"orderHead"] stringForKey:@"code"]];
    
    _orderdealtimelab.text=[NSString stringWithFormat:@"订单时间:%@",[[_orderinfo dictionaryForKey:@"orderHead"] stringForKey:@"createTime"]];
    
    _phonelab.text=[[_orderinfo dictionaryForKey:@"order_delivery_info"] stringForKey:@"telephone"];
    
}

-(void)backBtnClicked{
    if(_backtoprevious==1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [refreshshoppingcarbadgenum refresh:self.tabBarController];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4] animated:YES];
    }
    
    
    self.tabBarController.tabBar.hidden=NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return goodslist.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        OrderllistTableViewCell *cell=[OrderllistTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.image=[goodslist[indexPath.row] stringForKey:@"thumbnailImg"];
        cell.name=[goodslist[indexPath.row] stringForKey:@"name"];
        
        cell.price=[NSString stringWithFormat:@"¥%@",[goodslist[indexPath.row] stringForKey:@"price"]];
        
        cell.count=[NSString stringWithFormat:@"X%@",[goodslist[indexPath.row] stringForKey:@"quantity"]];
    
        cell.toatalmoney=[NSString stringWithFormat:@"商品总价:¥%.1f",[goodslist[indexPath.row] floatForKey:@"price"]*[goodslist[indexPath.row] int32ForKey:@"quantity"]];
    
        return cell;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return  MAIN_HEIGHT*0.06;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  MAIN_HEIGHT*0.17;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    //一个按钮
    if(statusoforder==4){
    view=[[[NSBundle mainBundle]loadNibNamed:@"onebtnindetail" owner:self options:nil]firstObject];
        view.frame=CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT*0.06);
        _receiveBtn.tag=section;
        return view;
    }
    //2个按钮
    else if(statusoforder==1){
        view=[[[NSBundle mainBundle]loadNibNamed:@"twobtnindetail" owner:self options:nil]firstObject];
        view.frame=CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT*0.06);
        _cancelorderBtn.tag=section;
        _payBtn.tag=section;
        return view;
    
    }
    else{
        return nil;
    }
    
    
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
//确认收货
- (IBAction)receivegoodBtnClicked:(UIButton *)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    paras[@"orderId"]=[[_orderinfo dictionaryForKey:@"orderHead"] stringForKey:@"id"];
    [HttpTool post:@"confirm_order" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==-1){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =[[responseObj dictionaryForKey:@"data"]stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
            
        }
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =@"确认收货成功";
            _statuslab.text=@"已收货";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
        }
    } failure:^(NSError *error) {
        NSLog(@"确认收货失败%@",error);
    }];

}
//取消订单
- (IBAction)cancelorderBtnClicked:(UIButton *)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    paras[@"orderId"]=[[_orderinfo dictionaryForKey:@"orderHead"] stringForKey:@"id"];
    [HttpTool post:@"cancel_order" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==-1){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =[[responseObj dictionaryForKey:@"data"]stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
            
        }
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =@"已取消";
            _statuslab.text=@"已取消";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"发送取消失败%@",error);
    }];

}
//去支付
- (IBAction)payBtnClicked:(UIButton *)sender {
    //调起微信支付
    //1.没有安装微信，直接返回
    if(![WXApi isWXAppInstalled]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        
        hud.labelText =@"您未安装微信!";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.2];
        return;
    }
    //2.安装了微信，进入支付
    dimview=[[UIView alloc]initWithFrame:self.view.bounds];
    dimview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:0.6];
    [self.view addSubview:dimview];
    
    hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud1.labelText = NSLocalizedString(@"正在支付...", @"HUD loading title");
    //现获取支付信息
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    paras[@"order_id"]=[[_orderinfo dictionaryForKey:@"orderHead"] stringForKey:@"id"];
   
    NSDictionary *paydicparas=[_orderinfo dictionaryForKey:@"wechat_param"];
    PayReq *request=[[PayReq alloc]init];
    
    request.partnerId=[paydicparas stringForKey:@"partnerid"];
    request.package =@"Sign=WXPay";
    request.prepayId=[paydicparas stringForKey:@"prepayid"];
    request.nonceStr=[paydicparas stringForKey:@"noncestr"];
    request.timeStamp=[paydicparas int64ForKey:@"timestamp"];
    request.sign=[paydicparas stringForKey:@"sign"];
    
    if([WXApi sendReq:request]){
        [hud1 removeFromSuperview];
        [dimview removeFromSuperview];
        
    }

}
//支付成功后回调
-(void)paysucceedoption{
    [dimview removeFromSuperview];
    [hud1 removeFromSuperview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText =@"支付成功！";
    _statuslab.textColor=@"已付款";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.0];
}
//支付失败后回调
-(void)payfailedoption{
    [dimview removeFromSuperview];
    [hud1 removeFromSuperview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText =@"支付失败!";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.0];
}


@end
