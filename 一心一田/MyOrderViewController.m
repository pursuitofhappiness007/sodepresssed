//
//  MyOrderViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/13.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "MutipleGoodsViewController.h"
#import "WXApiManager.h"
@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *orderlist;
    
    double pagenum;
    int previouscount;
    UIButton *selectedBtn;
    NSDictionary *jsondict;
    BOOL cancelorder;
    double totalpage;
    UIView *dimview;
    MBProgressHUD *hud1;
    int paybtntag;
    
   
}
@property (weak, nonatomic) IBOutlet UITableView *myordertableview;
@property (weak, nonatomic) IBOutlet UILabel *dealtimelab;
@property (strong, nonatomic) IBOutlet UILabel *orderstatuslab;
@property (weak, nonatomic) IBOutlet UILabel *summarycountlab;
- (IBAction)showAllOrders:(id)sender;
- (IBAction)underDealBtnClicked:(id)sender;
- (IBAction)dealBtnClicked:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *blueline;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UILabel *acctuallypaidlab;
- (IBAction)seeorderBtnClicked:(id)sender;
- (IBAction)sureReceiverBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *seeorderBtn;
@property (weak, nonatomic) IBOutlet UIButton *surereceiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelorderBtn;
- (IBAction)cancelorderBtnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnClicked:(UIButton *)sender;


@end

@implementation MyOrderViewController
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
    // Do any additional setup after loading the view from its 
    _allBtn.selected=YES;
    selectedBtn=_allBtn;
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"我的订单";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [self initparas];
    [self getdatafromweb:1 jsondict:jsondict];
    
}

-(void)initparas{
    orderlist=[NSMutableArray array];
    jsondict=[NSDictionary dictionary];
    pagenum=1;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getdatafromweb:(int)pagenum  jsondict:(NSDictionary *)dict{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
     paras[@"page_no"]=[NSString stringWithFormat:@"%d",pagenum];
//    paras[@"order_conditions"]=[DictionaryToJsonStr dictToJsonStr:dict];
    [HttpTool post:@"get_order_list" params:paras success:^(id responseObj) {
        NSLog(@"获取所有订单为 %@",responseObj);
        NSLog(@"获取订单参数%@",paras);
        if(orderlist.count>0){
            previouscount=orderlist.count;
            for(int i=0;i<[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"orderList"] count];i++) {
               [_myordertableview beginUpdates];
               [_myordertableview insertSections:[NSIndexSet indexSetWithIndex:previouscount+i] withRowAnimation:UITableViewRowAnimationAutomatic];
               [orderlist addObject:[[responseObj dictionaryForKey:@"data"] arrayForKey:@"orderList"][i]];
               [_myordertableview endUpdates];
                
                }
        }
                    else
        {
            if([[[responseObj dictionaryForKey:@"data"] arrayForKey:@"orderList"]count]>0)
            orderlist=[[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"orderList"] mutableCopy];
            totalpage=[[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"page"] doubleForKey:@"totalPage"];
            [_myordertableview reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取订单详情shibai %@",error);
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[orderlist[section] arrayForKey:@"orderGoods"] count];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return orderlist.count;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell *cell=[MyOrderTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.image=[[orderlist[indexPath.section] arrayForKey:@"orderGoods"][indexPath.row] stringForKey:@"thumbnailImg"];
        cell.name=[[orderlist[indexPath.section] arrayForKey:@"orderGoods"][indexPath.row] stringForKey:@"name"];
    cell.price=[[orderlist[indexPath.section] arrayForKey:@"orderGoods"][indexPath.row] stringForKey:@"salePrice"];
    cell.counttobuy=[NSString stringWithFormat:@"X%@",[[orderlist[indexPath.section] arrayForKey:@"orderGoods"][indexPath.row] stringForKey:@"quantity"]];
   cell.totalgoodstobuy=[NSString stringWithFormat:@"共%@件商品",[[orderlist[indexPath.section] arrayForKey:@"orderGoods"][indexPath.row] stringForKey:@"quantity"]];
    NSString *temp=[[[orderlist[indexPath.section] arrayForKey:@"orderGoods"][indexPath.row] stringForKey:@"salePrice"]stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    cell.actuallypaid=[NSString stringWithFormat:@"实付金额:¥%.2f",[temp floatValue]*[[orderlist[indexPath.section] arrayForKey:@"orderGoods"][indexPath.row] floatForKey:@"quantity"]];
    
      return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.15;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==orderlist.count-1){
        if(pagenum<totalpage){
        pagenum++;
        NSLog(@"huadongdi %d",pagenum);
        [self getdatafromweb:pagenum jsondict:jsondict];
        }
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    //只有一个按钮的情况
    if([[orderlist[section] dictionaryForKey:@"orderHeadVOs"] int32ForKey:@"businessStatus"]==-1||[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] int32ForKey:@"businessStatus"]==3||[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] int32ForKey:@"businessStatus"]==6){
        view=[[[NSBundle mainBundle]loadNibNamed:@"onebtninfooter" owner:self options:nil]firstObject];
        view.frame=CGRectMake(0, 0, MAIN_WIDTH, 25);
        _seeorderBtn.tag=section;
        _acctuallypaidlab.text=[NSString stringWithFormat:@"实付款金额:%@",[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"actualAmount"]];
        _summarycountlab.text=[NSString stringWithFormat:@"共%@件商品",[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"totalQuantity"]];
    }
    //有两个按钮的情况
    if([[orderlist[section] dictionaryForKey:@"orderHeadVOs"] int32ForKey:@"businessStatus"]==4){
        view=[[[NSBundle mainBundle]loadNibNamed:@"footerforsection" owner:self options:nil]firstObject];
        view.frame=CGRectMake(0, 0, MAIN_WIDTH, 25);
        _seeorderBtn.tag=section;
        _surereceiveBtn.tag=section;
        _acctuallypaidlab.text=[NSString stringWithFormat:@"实付款金额:%@",[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"actualAmount"]];
        _summarycountlab.text=[NSString stringWithFormat:@"共%@件商品",[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"totalQuantity"]];
    }
    //3个按钮的情况
    if([[orderlist[section] dictionaryForKey:@"orderHeadVOs"] int32ForKey:@"businessStatus"]==1)
    {
        view=[[[NSBundle mainBundle]loadNibNamed:@"threebtninfooter" owner:self options:nil]firstObject];
        view.frame=CGRectMake(0, 0, MAIN_WIDTH, 25);
        _seeorderBtn.tag=section;
        _cancelorderBtn.tag=section;
        _payBtn.tag=section;
        paybtntag=section;
        _acctuallypaidlab.text=[NSString stringWithFormat:@"实付款金额:%@",[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"actualAmount"]];
        _summarycountlab.text=[NSString stringWithFormat:@"共%@件商品",[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"totalQuantity"]];
    }
    return view;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[[NSBundle mainBundle]loadNibNamed:@"sectiontitile" owner:self options:nil]firstObject];
    view.frame=CGRectMake(0, 0, MAIN_WIDTH, 40);
    _dealtimelab.text=[NSString stringWithFormat:@"下单时间:%@",[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"createTime"]];
   
    _orderstatuslab.text=[[orderlist[section] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"businessName"];
    view.tag=section+50;

    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return MAIN_HEIGHT*0.11;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//所有订单
- (IBAction)showAllOrders:(UIButton *)sender {
    
    _blueline.x=sender.x;
    if(sender.selected)
        sender.selected=NO;
    else
    {         sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    
    [orderlist removeAllObjects];
    pagenum=1;
    [self getdatafromweb:1 jsondict:[NSDictionary dictionary]];
    jsondict=[NSDictionary dictionary];
    
    
}

- (IBAction)underDealBtnClicked:(id)sender {
}

- (IBAction)dealBtnClicked:(id)sender {
}
//待付款
- (IBAction)showdfkorders:(UIButton *)sender {
    _blueline.x=sender.x;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [orderlist removeAllObjects];
    pagenum=1;
    [self getdatafromweb:1 jsondict:@{@"businessStatus":@"1"}];
    jsondict=@{@"businessStatus":@"1"};
}
//已付款
- (IBAction)showpaidorders:(UIButton *)sender {
    _blueline.x=sender.x;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [orderlist removeAllObjects];
    pagenum=1;
    [self getdatafromweb:1 jsondict:@{@"businessStatus":@"3"}];
    jsondict=@{@"businessStatus":@"3"};
}
//已发货
- (IBAction)showyfhorders:(UIButton *)sender {
    _blueline.x=sender.x;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [orderlist removeAllObjects];
    pagenum=1;
    [self getdatafromweb:1 jsondict:@{@"businessStatus":@"4"}];
    jsondict=@{@"businessStatus":@"4"};
}
//已收货
- (IBAction)showyshorders:(UIButton *)sender {
    _blueline.x=sender.x;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [orderlist removeAllObjects];
    pagenum=1;
    [self getdatafromweb:1 jsondict:@{@"businessStatus":@"6"}];
    jsondict=@{@"businessStatus":@"6"};
}
//已取消
- (IBAction)showyqxorders:(UIButton *)sender {
    _blueline.x=sender.x;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [orderlist removeAllObjects];
    pagenum=1;
    [self getdatafromweb:1 jsondict:@{@"businessStatus":@"-1"}];
    jsondict=@{@"businessStatus":@"-1"};
}


//查看订单
- (IBAction)seeorderBtnClicked:(UIButton *)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    paras[@"order_id"]=[[orderlist[sender.tag] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"id"];
    [HttpTool post:@"get_order_detail" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==0){
            NSLog(@"获取商品详情的参数＝%@ json＝%@",paras,responseObj);
            MutipleGoodsViewController *vc=[[MutipleGoodsViewController alloc]init];
            
            vc.orderinfo=[responseObj dictionaryForKey:@"data"];
            vc.backtoprevious=1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =[[responseObj dictionaryForKey:@"data"]stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"获取订单详情失败 %@",error);
    }];

}
//取消订单
- (IBAction)cancelorderBtnClicked:(UIButton *)sender {
    
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
        paras[@"orderId"]=[[orderlist[sender.tag]dictionaryForKey:@"orderHeadVOs"] stringForKey:@"id"];
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
                
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:1.2];
                UIView *v=[_myordertableview viewWithTag:50+sender.tag];
                
                NSLog(@"所有子集 %@",v.subviews);
                for (UIView *subs in v.subviews) {
                    if([subs isKindOfClass:[UILabel class]]){
                        UILabel *lab=(UILabel *)subs;
                        if(lab.tag==22){
                            lab.textColor=[UIColor redColor];
                            lab.text=@"已取消";
                            _cancelorderBtn.hidden=YES;
                            _payBtn.hidden=YES;
                            _seeorderBtn.x=_payBtn.x;
                            
                        }
                    }
                }
                
                
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
    paras[@"order_id"]=[[orderlist[sender.tag] dictionaryForKey:@"orderHeadVOs"] stringForKey:@"id"];
    [HttpTool post:@"get_order_detail" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==0){
            NSLog(@"获取商品详情的参数＝%@ json＝%@",paras,responseObj);
            NSDictionary *paydicparas=[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"wechat_param"];
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
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =@"支付失败!";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"获取订单详情失败 %@",error);
    }];
    
}
//确认收货
- (IBAction)sureReceiverBtnClicked:(UIButton *)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    paras[@"orderId"]=[[orderlist[sender.tag]dictionaryForKey:@"orderHeadVOs"] stringForKey:@"id"];
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
            UIView *v=[_myordertableview viewWithTag:50+sender.tag];
            
            NSLog(@"所有子集 %@",v.subviews);
            
            
            
            for (UIView *subs in v.subviews) {
                if([subs isKindOfClass:[UILabel class]]){
                    UILabel *lab=(UILabel *)subs;
                    if(lab.tag==22){
                        lab.textColor=[UIColor redColor];
                        lab.text=@"已收货";
                        _surereceiveBtn.hidden=YES;
                        _seeorderBtn.x=_surereceiveBtn.x;
                        
                    }
                }
            }
            
            
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
        }
    } failure:^(NSError *error) {
        NSLog(@"确认收货失败%@",error);
    }];
    
    
    
}

-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"paysucceed" object:nil];
                
                break;
            }
            default:{
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"payfailed" object:nil];
                
                break;
            }
        }
    }
    
}

-(void)paysucceedoption{
    [dimview removeFromSuperview];
    [hud1 removeFromSuperview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText =@"支付成功！";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.0];
    UIView *v=[_myordertableview viewWithTag:50+paybtntag];
    
    NSLog(@"所有子集 %@",v.subviews);
      for (UIView *subs in v.subviews) {
        if([subs isKindOfClass:[UILabel class]]){
            UILabel *lab=(UILabel *)subs;
            if(lab.tag==22){
                lab.textColor=[UIColor redColor];
                lab.text=@"已付款";
                _cancelorderBtn.hidden=YES;
                _payBtn.hidden=YES;
                _seeorderBtn.x=_payBtn.x;
                
            }
        }
    }
}
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
