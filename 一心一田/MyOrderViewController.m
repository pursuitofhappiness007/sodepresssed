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
#define  singlesize @"6"
#import "WXPayTool.h"
@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *orderlist;
    int pagenum;
    int previouscount;
    UIButton *selectedBtn;
    NSDictionary *jsondict;
    BOOL cancelorder;
    int totalrows;
    UIView *dimview;
    MBProgressHUD *hud1;
    int sectioncount;
    NSMutableArray *rowinsecionsarray;
   
    
   
}
@property (weak, nonatomic) IBOutlet UILabel *orderstatuslab;
@property (weak, nonatomic) IBOutlet UILabel *ordercodelab;


@property (weak, nonatomic) IBOutlet UITableView *myordertableview;
//共几件商品
@property (weak, nonatomic) IBOutlet UILabel *summarycountlab;
//合计多少钱
@property (weak, nonatomic) IBOutlet UILabel *acctuallypaidlab;
- (IBAction)showAllOrders:(id)sender;
- (IBAction)dfkBtnClicked:(id)sender;
- (IBAction)dfhBtnClicked:(id)sender;
- (IBAction)dshBtnClicked:(id)sender;
- (IBAction)ywcBtnClicked:(id)sender;




@property (weak, nonatomic) IBOutlet UIView *blueline;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;


//查看订单
@property (weak, nonatomic) IBOutlet UIButton *seeorderBtn;
- (IBAction)seeorderBtnClicked:(id)sender;
//确认收货
@property (weak, nonatomic) IBOutlet UIButton *surereceiveBtn;
- (IBAction)sureReceiverBtnClicked:(id)sender;
//取消订单
@property (weak, nonatomic) IBOutlet UIButton *cancelorderBtn;
- (IBAction)cancelorderBtnClicked:(UIButton *)sender;
//去支付
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *emptyNoticelab;

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
    if([WXApi isWXAppInstalled]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paysucceedoption) name:@"paysucceed" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payfailedoption) name:@"payfailed" object:nil];
    }
    _allBtn.selected=YES;
    selectedBtn=_allBtn;
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"我的订单";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(backBtnClicked)];
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
    paras[@"page_size"]=singlesize;
    paras[@"order_conditions"]=[DictionaryToJsonStr dictToJsonStr:dict];
    [HttpTool post:@"get_order_list" params:paras success:^(id responseObj) {
        NSLog(@"获取所有订单为 %@",responseObj);
        NSLog(@"获取订单参数%@",paras);
        if(orderlist.count>0){
            _emptyNoticelab.hidden=YES;
            if ([[[responseObj dictionaryForKey:@"data"] arrayForKey:@"order_list"]count]==0)
                return ;
            previouscount=orderlist.count;
            for(int i=0;i<[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"order_list"]count];i++) {
                    [_myordertableview beginUpdates];
                    [_myordertableview insertSections:[NSIndexSet indexSetWithIndex:previouscount+i] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [orderlist addObject:[[responseObj dictionaryForKey:@"data"] arrayForKey:@"order_list"][i]];
                    [_myordertableview endUpdates];
                }
        }
        else
        {
            if([[[responseObj dictionaryForKey:@"data"] arrayForKey:@"order_list"]count]>0){
                _emptyNoticelab.hidden=YES;
        orderlist=[[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"order_list"] mutableCopy];
            }
            else
                _emptyNoticelab.hidden=NO;
        totalrows=[[[responseObj dictionaryForKey:@"data"]dictionaryForKey:@"page"]int32ForKey:@"totalRows"];
            [_myordertableview reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取订单详情shibai %@",error);
    } controler:self];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[orderlist[section]arrayForKey:@"orderDetailList"]count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return orderlist.count;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell *cell=[MyOrderTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dict=[orderlist[indexPath.section] arrayForKey:@"orderDetailList"][indexPath.row];
        cell.image=[dict stringForKey:@"goodsPic"];
        cell.name=[dict stringForKey:@"goodsName"];
    cell.shortcomment=[dict stringForKey:@"commentary"];
      return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==orderlist.count-1){
        if(pagenum*[singlesize intValue]<totalrows){
        pagenum++;
        NSLog(@"huadongdi %d",pagenum);
        [self getdatafromweb:pagenum jsondict:jsondict];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, MAIN_WIDTH, 25);
    NSDictionary *dict=[orderlist[section] dictionaryForKey:@"orderHeader"];
    int i=[dict int32ForKey:@"businessStatus"];
   
    //只有一个按钮的情况
    if(i==2||i==6||i==8||i<0){
        view=[[[NSBundle mainBundle]loadNibNamed:@"onebtninfooter" owner:self options:nil]firstObject];
        _acctuallypaidlab.text=[NSString stringWithFormat:@"实付款金额:¥%.2f",[dict doubleForKey:@"paymentAmount"]];
        
        _summarycountlab.text=[NSString stringWithFormat:@"共%d件商品",[[orderlist[section] arrayForKey:@"orderDetailList"]count]];
         _seeorderBtn.tag=section;
    }
    //有两个按钮的情况
    
    if(i==6){
        view=[[[NSBundle mainBundle]loadNibNamed:@"footerforsection" owner:self options:nil]firstObject];
        _acctuallypaidlab.text=[NSString stringWithFormat:@"实付款金额:¥%.2f",[dict doubleForKey:@"paymentAmount"]];
        _summarycountlab.text=[NSString stringWithFormat:@"共%d件商品",[[orderlist[section] arrayForKey:@"orderDetailList"]count]];
        _seeorderBtn.tag=section;
        _surereceiveBtn.tag=section;
    }
    //3个按钮的情况
    if(i==0){
        view=[[[NSBundle mainBundle]loadNibNamed:@"threeBtninfoot" owner:self options:nil]firstObject];
        _acctuallypaidlab.text=[NSString stringWithFormat:@"实付款金额:¥%.2f",[dict doubleForKey:@"paymentAmount"]];
        _summarycountlab.text=[NSString stringWithFormat:@"共%d件商品",[[orderlist[section] arrayForKey:@"orderDetailList"]count]];
        _seeorderBtn.tag=section;
        _cancelorderBtn.tag=section;
        _payBtn.tag=section;
    }
    return view;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[[NSBundle mainBundle]loadNibNamed:@"sectiontitle" owner:self options:nil]firstObject];
    view.frame=CGRectMake(0, 0, MAIN_WIDTH, 40);
    NSDictionary *dict=[orderlist[section] dictionaryForKey:@"orderHeader"];
    _ordercodelab.text=[NSString stringWithFormat:@"订单编号:%@",[dict stringForKey:@"orderCode"]];
   
    _orderstatuslab.text=[dict stringForKey:@"businessStatusName"];
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
    _emptyNoticelab.hidden=YES;
    CGPoint temp=_blueline.center;
    temp.x=sender.center.x;
    _blueline.center=temp;
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
//待付款
- (IBAction)dfkBtnClicked:(UIButton *)sender {
    _emptyNoticelab.hidden=YES;
    CGPoint temp=_blueline.center;
    temp.x=sender.center.x;
    _blueline.center=temp;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [orderlist removeAllObjects];
    pagenum=1;
    jsondict=@{@"businessStatus":@"0"};
    [self getdatafromweb:1 jsondict:jsondict];
    
}
//待发货
- (IBAction)dfhBtnClicked:(UIButton *)sender {
    _emptyNoticelab.hidden=YES;
    CGPoint temp=_blueline.center;
    temp.x=sender.center.x;
    _blueline.center=temp;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [orderlist removeAllObjects];
    pagenum=1;
    [self getdatafromweb:1 jsondict:@{@"businessStatus":@"2"}];
    jsondict=@{@"businessStatus":@"2"};
}
//待收货
- (IBAction)dshBtnClicked:(UIButton *)sender {
    _emptyNoticelab.hidden=YES;
    CGPoint temp=_blueline.center;
    temp.x=sender.center.x;
    _blueline.center=temp;
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
//已完成
- (IBAction)ywcBtnClicked:(UIButton *)sender {
    _emptyNoticelab.hidden=YES;
    CGPoint temp=_blueline.center;
    temp.x=sender.center.x;
    _blueline.center=temp;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [orderlist removeAllObjects];
    pagenum=1;
    [self getdatafromweb:1 jsondict:@{@"businessStatus":@"8"}];
    jsondict=@{@"businessStatus":@"8"};
}



//查看订单
- (IBAction)seeorderBtnClicked:(UIButton *)sender {
    MutipleGoodsViewController *vc=[[MutipleGoodsViewController alloc]init];
    NSDictionary *dict=[orderlist[sender.tag] dictionaryForKey:@"orderHeader"];
    vc.order_id=[dict stringForKey:@"id"];
    vc.isparent=[dict stringForKey:@"isParent"];
    vc.backtoprevious=1;
    [self.navigationController pushViewController:vc animated:YES];
}
//取消订单
- (IBAction)cancelorderBtnClicked:(UIButton *)sender {
    
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    paras[@"order_id"]=[[orderlist[sender.tag]dictionaryForKey:@"orderHeader"] stringForKey:@"id"];
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
                            [_payBtn removeFromSuperview];
                            [_cancelorderBtn removeFromSuperview];
                            
                        }
                    }
                }
                
                
            }
        } failure:^(NSError *error) {
            NSLog(@"发送取消失败%@",error);
        } controler:self];
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
    //现获取支付信息
    
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    NSDictionary *tempdict=[orderlist[sender.tag]dictionaryForKey:@"orderHeader"];
    paras[@"order_id"]=[tempdict stringForKey:@"id"];
    paras[@"isParent"]=[tempdict stringForKey:@"isParent"];
    [HttpTool post:@"get_order_detail" params:paras success:^(id responseObj) {
        NSLog(@"获取订单详情=%@ 参数＝%@",responseObj,paras);
        if([responseObj int32ForKey:@"result"]==0)
            
            dimview=[[UIView alloc]initWithFrame:self.view.bounds];
        dimview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:0.6];
        [self.view addSubview:dimview];
        
        hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud1.labelText = NSLocalizedString(@"正在支付...", @"HUD loading title");
        
        if([WXPayTool wxpaywithdict:[[responseObj dictionaryForKey:@"data"]dictionaryForKey:@"wechat_param"]]){
            [hud1 removeFromSuperview];
            [dimview removeFromSuperview];
            
        }

        
        
    } failure:^(NSError *error) {
        NSLog(@"获取详情失败%@",error);
    }controler:self];
    
}

//确认收货
- (IBAction)sureReceiverBtnClicked:(UIButton *)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
paras[@"order_id"]=[[orderlist[sender.tag]dictionaryForKey:@"orderHeader"] stringForKey:@"id"];
    [HttpTool post:@"order_confirm" params:paras success:^(id responseObj) {
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
                        [_surereceiveBtn removeFromSuperview];
                        
                    }
                }
            }
            
            
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
        }
    } failure:^(NSError *error) {
        NSLog(@"确认收货失败%@",error);
    } controler:self];
    
    
    
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
    UIView *v=[_myordertableview viewWithTag:50+_payBtn.tag];
    
    NSLog(@"所有子集 %@",v.subviews);
      for (UIView *subs in v.subviews) {
        if([subs isKindOfClass:[UILabel class]]){
            UILabel *lab=(UILabel *)subs;
            if(lab.tag==22){
                lab.textColor=[UIColor redColor];
                lab.text=@"已完成";
                _cancelorderBtn.hidden=YES;
                _payBtn.hidden=YES;
                _seeorderBtn.x=_payBtn.x;
                
            }
        }
    }
    [_payBtn removeFromSuperview];
    [_cancelorderBtn removeFromSuperview];
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
