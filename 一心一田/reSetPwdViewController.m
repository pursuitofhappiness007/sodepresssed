//
//  reSetPwdViewController.m
//  kitchen
//
//  Created by xipin on 15/12/21.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "reSetPwdViewController.h"
#import "LoginViewController.h"

@interface reSetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *originalpedtf;
@property (weak, nonatomic) IBOutlet UITextField *newpwdtf;
@property (weak, nonatomic) IBOutlet UITextField *confirmpwdtf;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnClicked:(id)sender;

@end

@implementation reSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"重置密码";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    else {
        if(_newpwdtf.text.length>0&_confirmpwdtf.text.length>0)
        
            _confirmBtn.enabled=YES;
        
        return YES;
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)confirmBtnClicked:(id)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"cell_phone"]=_cellphone;
    paras[@"password"]=_newpwdtf.text;
    paras[@"password_confirm"]=_confirmpwdtf.text;
    paras[@"phone_token"]=_phonetoken;
    [HttpTool post:@"update_password_by_login_name" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==-1){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =[[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
            
        }
        else{
            LoginViewController *vc=[[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }

    } failure:^(NSError *error) {
         NSLog(@"修改失败%@",error);
    }];
}
@end
