//
//  LoginViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/11/24.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "LoginViewController.h"
#import "PersonalCenterViewController.h"
#import "BPush.h"
@interface LoginViewController ()<UITextFieldDelegate>{
   
}

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    [[UITextField appearance] setTintColor:[UIColor colorWithRed:34.0/255 green:127.0/255 blue:223.0/255 alpha:1.0]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"登录";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personinfochangedupdate) name:@"personinfochanged" object:nil];
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"userpassword.txt"]){
    _accounttextfield.text=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"userpassword.txt"] stringForKey:@"user"];
    _pwdtextfield.text=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"userpassword.txt"] stringForKey:@"password"];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnClicked{
    
    if([self.tabBarController selectedIndex]==0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        UIView * fromView = self.tabBarController.selectedViewController.view;
        UIView * toView =[[self.tabBarController.viewControllers objectAtIndex:0] view];
        [UIView transitionFromView:fromView
                            toView:toView
                          duration:0.5
                           options:(0>self.tabBarController.selectedIndex? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                        completion:^(BOOL finished) {
                            if (finished) {
                                [self.tabBarController setSelectedIndex:0];
                                self.tabBarController.tabBar.hidden=NO;
                            }
                        }];
    }
    
}


-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
       if(MAIN_HEIGHT-_loginBtn.height-_loginBtn.y<keyboardFrameBeginRect.size.height){
       CGFloat detlaHeight=keyboardFrameBeginRect.size.height-(MAIN_HEIGHT-_loginBtn.height-_loginBtn.y);
        
        self.view.y=-detlaHeight-5;
    }
    NSLog(@"键盘高度  %f",keyboardFrameBeginRect.size.height);
 
}

-(void)keyboardWillHide:(NSNotification*)notification{
    self.view.y=0;
    
}

-(void)personinfochangedupdate{

    [self loginBtnClicked:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenfilechanged" object:nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //用户名
    if(textField.tag==88){
        if([textField.text isEqualToString:@"输入账号"])
            textField.text=nil;
        if (_pwdtextfield.text.length==0) {
            _pwdtextfield.text=@"输入密码";
            _pwdtextfield.secureTextEntry=NO;
        }
    }
    //密码
    else{
        if([textField.text isEqualToString:@"输入密码"])
            textField.text=nil;
        _pwdtextfield.secureTextEntry=YES;
        if (_accounttextfield.text.length==0) {
            _accounttextfield.text=@"输入账号";
        }
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches]anyObject];
    if(touch.view.tag==88||touch.view.tag==90)
        return;
    [self.view endEditing:YES];
}




- (IBAction)loginBtnClicked:(id)sender {
    if(_accounttextfield.text.length==0||_pwdtextfield.text.length==0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        
        hud.labelText =@"账号或密码为空!";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.2];
        return;

    }
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"login_name"]=_accounttextfield.text;
    paras[@"password"]=_pwdtextfield.text;
    [HttpTool post:@"login" params:paras success:^(id responseObj) {
        NSLog(@"登录后的%@",responseObj);
        
        if([responseObj int32ForKey:@"result"]==0){
        [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:[responseObj dictionaryForKey:@"data"] filepath:@"tokenfile.txt"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
            NSDictionary *userandpassword=@{@"user":_accounttextfield.text,@"password":_pwdtextfield.text};
            [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:userandpassword filepath:@"userpassword.txt"];
            [LocalAndOnlineFileTool refreshkindnum:self.tabBarController];
            //注册推送接口
            NSMutableDictionary *paras=[NSMutableDictionary dictionary];
            paras[@"baidu_user_id"]=[BPush getUserId];
            paras[@"baidu_channel_id"]=[BPush getChannelId];
            paras[@"baidu_app_id"]=[BPush getAppId];
            paras[@"device_type"]=@"4";
            NSLog(@"%@", paras);
            [HttpTool post:@"msg_push_register" params:paras success:^(id responseObj) {
                NSLog(@"注册推送接口成功%@",responseObj);
            } failure:^(NSError *error) {
                NSLog(@"注册推送接口失败%@",error);
            }controler:self];
            
            if([_source isEqualToString:@"back"]){
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
}
        else{
            
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText=[[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
        
        }
    } failure:^(NSError *error) {
        NSLog(@"未能登录陈宫%@",error);
    }controler:self];
    
}

@end
