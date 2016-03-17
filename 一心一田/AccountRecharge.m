//
//  AccountRecharge.m
//  一心一田
//
//  Created by user on 16/3/8.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "AccountRecharge.h"
#import "WXPayTool.h"
@interface AccountRecharge (){
    UIView  *dimview;
    MBProgressHUD *hud1;
}
@property (weak, nonatomic) IBOutlet UITextField *amountTF;

@end

@implementation AccountRecharge
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"账户充值";
   UIButton  *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backBtn setImage:[UIImage imageNamed:@"backpretty"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paysucceedoption) name:@"paysucceed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payfailedoption) name:@"payfailed" object:nil];
 
}
//支付成功
-(void)paysucceedoption{
    [dimview removeFromSuperview];
    [hud1 removeFromSuperview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}
//支付失败
-(void)payfailedoption{
    [dimview removeFromSuperview];
    [hud1 removeFromSuperview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText =@"充值失败!";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.0];
}


- (void)goBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)RechargeButtonClicked:(id)sender {
    if(self.amountTF.text.length==0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        
        hud.labelText =@"请输入充值金额!";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.2];
        return;
    }

    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"rcgAmount"] = self.amountTF.text;
    NSDictionary *dic = [[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"tokenfile.txt"];
    NSString *str = [dic stringForKey:@"token"];
    NSLog(@"token:%@", str);
    paras[@"token"] = [dic stringForKey:@"token"];
    [HttpTool post:@"get_recharge_code" params:paras success:^(id responseObj) {
        NSLog(@"recharge message:%@",responseObj);
        
        if([responseObj int32ForKey:@"result"]==0){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
               hud.mode = MBProgressHUDModeText;
               hud.labelText =@"充值成功!";
               hud.margin = 10.f;
              hud.removeFromSuperViewOnHide = YES;
              [hud hide:YES afterDelay:1.2];
            //充值成功后调起微信支付
            dimview=[[UIView alloc]initWithFrame:self.view.bounds];
            dimview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:0.6];
            [self.view addSubview:dimview];
            
          hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            hud1.labelText = NSLocalizedString(@"正在充值...", @"HUD loading title");
            BOOL flag=[[WXPayTool singletonInstance]wxpaywithdict:[responseObj dictionaryForKey:@"data"]];
            if(flag){
                [dimview removeFromSuperview];
                [hud1 removeFromSuperview];
            }
                return;

        } else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText=[[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"网络繁忙，请稍后再试");
    }];
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
