//
//  SingleGoodOrderConfirmnationViewController.m
//  kitchen
//
//  Created by xipin on 15/12/21.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "SingleGoodOrderConfirmnationViewController.h"
#import "AddInOrderTableViewCell.h"
#import "MutipleGoodsViewController.h"
#import "WXApiManager.h"
#import "NewAddressViewController.h"
@interface SingleGoodOrderConfirmnationViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,WXApiDelegate>{
    NSMutableArray *addlistarray;
    UIView *v;
    UIView *concurrentv;
    float totalmoney;
    int totalcount;
    float singleprice;
    NSString *deliveryId;
    int deliverindex;
    NSDictionary *qianggousucceedjson;
    MBProgressHUD *hud1;
    UIView *dimview;
    //提交订单成功是活的的json,如果支付失败就保留一份，以便后续再继续支付
    NSDictionary *tempdict;
}
@property (weak, nonatomic) IBOutlet UITextField *inputtf;
@property (weak, nonatomic) IBOutlet UILabel *receiverlab;
@property (weak, nonatomic) IBOutlet UILabel *addresslab;
@property (weak, nonatomic) IBOutlet UILabel *phonelab;
- (IBAction)changedeliveryaddressBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *goodsimgview;
@property (weak, nonatomic) IBOutlet UILabel *goodsnamelab;
@property (weak, nonatomic) IBOutlet UILabel *goodspricelab;
@property (weak, nonatomic) IBOutlet UILabel *goodscountlab;
@property (weak, nonatomic) IBOutlet UILabel *summarylab;
@property (weak, nonatomic) IBOutlet UILabel *totalmoneylab;
- (IBAction)payBtnClicked:(UIButton *)sender;
- (IBAction)singletap:(id)sender;
- (IBAction)singletap2:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (IBAction)minusBtnClicked:(id)sender;
- (IBAction)addBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countlab;

@property (weak, nonatomic) IBOutlet UITableView *deliveryaddresstableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightextendiniphone4s;
@property (weak, nonatomic) IBOutlet UILabel *addressnoticelab;


@end

@implementation SingleGoodOrderConfirmnationViewController

-(void)initparas{
    addlistarray=[NSMutableArray array];
    deliverindex=0;
    qianggousucceedjson=[NSDictionary dictionary];
    if(MAIN_HEIGHT==480)
        _heightextendiniphone4s.constant=70;
   
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view.tag==11)
        return YES;
    else
        return NO;

}

-(void)setdeliveryaddress{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    [HttpTool post:@"get_delivery_list" params:paras success:^(id responseObj) {
        NSLog(@"获取的收获地址列表 %@",responseObj);
        if([responseObj int32ForKey:@"result"]==0){
            addlistarray=[[responseObj mutableArrayValueForKey:@"data"]mutableCopy];
            if(addlistarray.count<2){
                _addressnoticelab.text=@"新增收货地址";
            }
            else
                _addressnoticelab.text=@"修改收货地址";
            NSDictionary *dict=[addlistarray firstObject];
            _receiverlab.text=[dict stringForKey:@"receiver"];
            _phonelab.text=[dict stringForKey:@"cellPhone"];
            _addresslab.text=[dict stringForKey:@"deliveryAddress"];
            deliveryId=[dict stringForKey:@"id"];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取收货地址失败 %@",error);
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


-(void)viewWillAppear:(BOOL)animated{
    if([WXApi isWXAppInstalled]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paysucceedoption) name:@"paysucceed" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payfailedoption) name:@"payfailed" object:nil];
    }
     [super viewWillAppear:animated];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addaddressrefresh) name:@"newaddresssucceed" object:nil];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"订单确认";
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [self initparas];
    [self setdeliveryaddress];
    if([_sourcetype isEqualToString:@"qianggou"])
    [self setseckillcontent];
    else
    [self setlocalcontent];
    
}
-(void)addaddressrefresh{
   
    [self setdeliveryaddress];
}
-(void)setseckillcontent{
  [[DownLoadImageTool singletonInstance]imageWithImage:_imageurl  scaledToWidth:_goodsimgview.width imageview:_goodsimgview];
    _goodsnamelab.text=_namestr;
    _goodspricelab.text=[NSString stringWithFormat:@"¥%.2f",_singleprice];
    
    totalmoney=_singleprice;
     _summarylab.text=[NSString stringWithFormat:@"商品总价:¥%.2f",totalmoney];
    _totalmoneylab.text=[NSString stringWithFormat:@"¥%.2f",totalmoney];
    _minusBtn.hidden=YES;
    _addBtn.hidden=YES;
    _countlab.hidden=YES;
}

-(void)setlocalcontent{
    [[DownLoadImageTool singletonInstance]imageWithImage:_imageurl  scaledToWidth:_goodsimgview.width imageview:_goodsimgview];
    _goodsnamelab.text=_namestr;
    _goodspricelab.text=[NSString stringWithFormat:@"¥%.2f",_singleprice];
    totalcount=1;
    totalmoney=_singleprice;
    _goodscountlab.text=[NSString stringWithFormat:@"X%d",totalcount];
    
    _summarylab.text=[NSString stringWithFormat:@"商品总价:¥%.2f",totalmoney];
    _totalmoneylab.text=[NSString stringWithFormat:@"¥%.2f",totalmoney];
    
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return addlistarray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        AddInOrderTableViewCell *cell=[AddInOrderTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.receiver=[addlistarray[indexPath.row] stringForKey:@"receiver"];
        cell.phone=[addlistarray[indexPath.row]stringForKey:@"cellPhone"];
        cell.address=[addlistarray[indexPath.row] stringForKey:@"deliveryAddress"];
        return cell;
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _phonelab.text=[addlistarray[indexPath.row]stringForKey:@"cellPhone"];
        _addresslab.text=[addlistarray[indexPath.row] stringForKey:@"deliveryAddress"];
    deliverindex=indexPath.row;
        _receiverlab.text=[addlistarray[indexPath.row] stringForKey:@"receiver"];
        [v removeFromSuperview];
        deliveryId=[addlistarray[indexPath.row]stringForKey:@"id"];
        
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
           return _deliveryaddresstableview.height*0.5;
   
}

- (IBAction)changedeliveryaddressBtnClicked:(id)sender {
    if(addlistarray.count<2){

        NewAddressViewController *vc=[[NewAddressViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
     
    }
        
        
    v=[[[NSBundle mainBundle]loadNibNamed:@"popaddressdeliverylist" owner:self options:nil]firstObject];
    v.frame=self.view.bounds;
    [self.view addSubview:v];
    _deliveryaddresstableview.tag=100;
    [_deliveryaddresstableview reloadData];
}

- (IBAction)payBtnClicked:(UIButton *)sender {
    if([addlistarray count]==0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        
        hud.labelText =@"您还未添加收货地址";
        hud.labelFont=[UIFont systemFontOfSize:14.0];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2.0];
        return;
       
    }
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
    if([_sourcetype isEqualToString:@"qianggou"]){
        concurrentv=[[[NSBundle mainBundle]loadNibNamed:@"concurrentcontrolwindow" owner:self options:nil]firstObject];
        concurrentv.frame=self.view.bounds;
        [self.view addSubview:concurrentv];
        return;
    }
    
    
    
       NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    paras[@"deliveryId"]=deliveryId;
    paras[@"goodsId"]=_goodsid;
    paras[@"quantity"]=[NSString stringWithFormat:@"%d",totalcount];
    paras[@"payMode"]=@"4";
    NSLog(@"参数%@",paras);
    
    
   
           [HttpTool post:@"add_order_by_goods" params:paras success:^(id responseObj) {
        NSLog(@"单个提交选择微信支付时获得的json%@",responseObj);
        if([responseObj int32ForKey:@"result"]==-1){
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =[[responseObj dictionaryForKey:@"data"]stringForKey:@"error_msg"];
            hud.labelFont=[UIFont systemFontOfSize:10.0];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2.0];
        }
        //提交订单成功
        else{
            dimview=[[UIView alloc]initWithFrame:self.view.bounds];
            dimview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:0.6];
            [self.view addSubview:dimview];
            
            hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            hud1.labelText = NSLocalizedString(@"正在支付...", @"HUD loading title");
            [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:responseObj filepath:@"detailbasedinfo.txt"];
         tempdict=[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"wechat_param"];
            NSLog(@"fuch tepdic=%@",tempdict);
            NSString *prepayId=[tempdict stringForKey:@"prepayid"];
            NSString *noncestr=[tempdict stringForKey:@"noncestr"];
            int timestamp=[tempdict int64ForKey:@"timestamp"];
            NSString *sign=[tempdict stringForKey:@"sign"];
            if(tempdict==nil)[self paysucceedoption];
            else{
                
                PayReq *request=[[PayReq alloc]init];
                    
                    request.partnerId=@"1300204001";
                    request.package =@"Sign=WXPay";
                    request.prepayId=prepayId;
                    request.nonceStr=noncestr;
                    request.timeStamp=timestamp ;
                    request.sign=sign;
                    NSLog(@"prepayid=%@,noncestr=%@,timestamo=%d,sign=%@调用微信的返回值 %d",prepayId,noncestr,timestamp,sign,[WXApi sendReq:request]);
                if([WXApi sendReq:request]){
                    [hud1 removeFromSuperview];
                    [dimview removeFromSuperview];
                
                }
               
                

            }
        
        }

    } failure:^(NSError *error) {
        NSLog(@"提交订单shibai%@",error);
    }];
}


-(void)paysucceedoption{
    NSLog(@"支付成功后来到回调函数");
    [dimview removeFromSuperview];
    [hud1 removeFromSuperview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText =@"支付成功！";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.0];
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    if([_sourcetype isEqualToString:@"qianggou"])
    paras[@"order_id"]=[[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"detailbasedinfo.txt"] dictionaryForKey:@"data"]dictionaryForKey:@"secKill_info"] stringForKey:@"id"];

    else
     paras[@"order_id"]=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"detailbasedinfo.txt"]dictionaryForKey:@"data"]stringForKey:@"order_id"];

    [HttpTool post:@"get_order_detail" params:paras success:^(id responseObj) {
        NSLog(@"抢购陈宫获得的json=%@",responseObj);
        if([responseObj int32ForKey:@"result"]==0){
            
            MutipleGoodsViewController *vc=[[MutipleGoodsViewController alloc]init];
            vc.orderinfo=[responseObj dictionaryForKey:@"data"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText =[[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0];
            [self.navigationController  popViewControllerAnimated:YES];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"获取订单详情失败 %@",error);
    }];

    
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

- (IBAction)singletap:(id)sender {
    
    [v removeFromSuperview];
}

- (IBAction)singletap2:(id)sender {
    [concurrentv removeFromSuperview];
}

- (IBAction)minusBtnClicked:(id)sender {
    int i=[_countlab.text intValue];
    if(i>1){
        if(i==2)
           [_minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255 blue:163.0/255 alpha:1.0] forState:UIControlStateNormal];
        _countlab.text=[NSString stringWithFormat:@"%d",i-1];
        totalcount=i-1;
        _goodscountlab.text=[NSString stringWithFormat:@"X%d",totalcount];
        totalmoney=_singleprice*totalcount;
        _totalmoneylab.text=[NSString stringWithFormat:@"¥%.2f",totalmoney];
        _summarylab.text=[NSString stringWithFormat:@"商品总价:¥%.2f",totalmoney];
    }
}


- (IBAction)addBtnClicked:(id)sender {
    [_minusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    int i=[_countlab.text intValue];
  
    _countlab.text=[NSString stringWithFormat:@"%d",i+1];
    totalcount=i+1;
    _goodscountlab.text=[NSString stringWithFormat:@"X%d",totalcount];
    totalmoney=_singleprice*totalcount;
    _totalmoneylab.text=[NSString stringWithFormat:@"¥%.2f",totalmoney];
    _summarylab.text=[NSString stringWithFormat:@"商品总价:¥%.2f",totalmoney];
}
@end
