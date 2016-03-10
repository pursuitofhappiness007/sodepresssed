//
//  RegisterVC.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/3.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "RegisterVC.h"
#import "XMLDictionary.h"

@interface RegisterVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
   
    NSString *provincestr;
    NSString *citystr;
    NSString *districtstr;
    UIView *v;
    NSMutableArray *provinces;
    NSArray *cities;
    NSArray *districts;
    NSArray *initialselected;
    NSString *cityid;
    NSString *areaid;
   
}

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"注册";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initparas];
}

-(void)initparas{
    provinces=[NSArray array];
    cities=[NSArray array];
    districts=[NSArray array];
    initialselected=[NSArray array];
   
    
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"id"]=@"0";
    [HttpTool post:@"get_area_by_pid" params:paras success:^(id responseObj) {
        NSLog(@"获得的所有省%@",responseObj);
        if([[responseObj arrayForKey:@"data"] count]==0)
            return ;
        provinces=[responseObj arrayForKey:@"data"];
        paras[@"id"]=[provinces[0] stringForKey:@"id"];
        [HttpTool post:@"get_area_by_pid" params:paras success:^(id responseObj) {
            NSLog(@"获得城市成功%@",responseObj);
            cities=[responseObj arrayForKey:@"data"];
            paras[@"id"]=[cities[0] stringForKey:@"id"];
            [HttpTool post:@"get_area_by_pid" params:paras success:^(id responseObj) {
                NSLog(@"获取区成功%@",responseObj);
                districts=[responseObj arrayForKey:@"data"];
            } failure:^(NSError *error) {
                NSLog(@"获取区失败%@",error);
            }];
        } failure:^(NSError *error) {
            NSLog(@"获取城市失败%@",error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"获得所有省失败%@",error);
    }];


}

-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    if(MAIN_HEIGHT-_container.y-_lastcellincontainer.y-_lastcellincontainer.height<keyboardFrameBeginRect.size.height){
        CGFloat detlaHeight=keyboardFrameBeginRect.size.height-(MAIN_HEIGHT-_container.y-_lastcellincontainer.y-_lastcellincontainer.height);
        
        self.view.y=-detlaHeight-10;
    }
    NSLog(@"键盘高度  %f",keyboardFrameBeginRect.size.height);
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:1.0 animations:^{
        v.height=0;
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
        self.tabBarController.tabBar.hidden=NO;
    }];
    
    [self.view endEditing:YES];
}

-(void)keyboardWillHide:(NSNotification*)notification{
    self.view.y=0;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
        if(_usernametextfield.text.length>0&&_phonetf.text.length==10)
        _gainmsgcodeBtn.enabled=YES;
    
       return YES;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [v removeFromSuperview];
    self.tabBarController.tabBar.hidden=NO;
    return YES;
    
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerBtnClicked:(id)sender {
    if(districtstr.length==0||_whorecommendphonetf.text.length==0||_customermanagertf.text.length==0||_msgcodetf.text.length==0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"信息填写不完整";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.0];
        return;
        
    }

    NSMutableDictionary *paras1=[NSMutableDictionary dictionary];
    paras1[@"phone"]=_phonetf.text;
    [HttpTool post:@"check_phone" params:paras1 success:^(id responseObj) {
        NSLog(@"检查获得的%@",responseObj);
        if([[responseObj stringForKey:@"data"] isEqualToString:@"true"])
            NSLog(@"未注册");
       else if([[responseObj stringForKey:@"data"] isEqualToString:@"false"]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"该号码已注册！";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0];
            return;
        }
       else{
           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
           
           // Configure for text only and offset down
           hud.mode = MBProgressHUDModeText;
           hud.labelText =@"您输入有误";
           hud.margin = 10.f;
           hud.removeFromSuperViewOnHide = YES;
           
           [hud hide:YES afterDelay:1.0];
           return;
       }
    } failure:^(NSError *error) {
        NSLog(@"检查失败  %@",error);
    }];
    
    
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"cell_phone"]=_phonetf.text;
    paras[@"city"]=cityid;
    paras[@"area"]=areaid;
    paras[@"referee_phone"]=_whorecommendphonetf.text;
    paras[@"manager_phone"]=_customermanagertf.text;
    paras[@"captcha"]=_msgcodetf.text;
    [HttpTool post:@"register" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"注册成功";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        
        }
    } failure:^(NSError *error) {
        NSLog(@"注册失败 %@",error);
    }];
    
    
}

- (IBAction)gainmsgcodeBtnClicked:(UIButton *)sender {
    
    if(_usernametextfield.text.length==0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入用户名";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.0];
        return;
    }
    if(_phonetf.text.length!=11){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"手机号输入错误";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.0];
        return;
    }
    
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"cell_phone"]=_phonetf.text;
    [HttpTool post:@"send_register_sms" params:paras success:^(id responseObj) {
        
        if([responseObj int32ForKey:@"result"]==0){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"验证码已发送到您手机";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0];
        
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0];
        
        }
    } failure:^(NSError *error) {
        NSLog(@"发送验证码失败 %@",error);
    }];
    
    
    
    
    
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  
    return 3;
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSLog(@"%s",__func__);
    if(component==0)
    {
        return provinces.count;
    }
    if(component==1)
    {
        return cities.count;
    }
    if(component==2)
    {
        

        return districts.count;
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSLog(@"%s",__func__);
    if(component==0){
        
        return [provinces[row] stringForKey:@"province"];
    }
    if(component==1)
    {
       
        return [cities[row] stringForKey:@"city"];
    }
    
    if(component==2){
                return [districts[row] stringForKey:@"district"];
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%s",__func__);
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    
    if (component==0) {
        NSLog(@"低1列");
        provincestr=[[provinces objectAtIndex:[pickerView selectedRowInComponent:0]] stringForKey:@"province"];
        paras[@"id"]=[provinces[row] stringForKey:@"id"];
        [HttpTool post:@"get_area_by_pid" params:paras success:^(id responseObj) {
            
            cities=[responseObj arrayForKey:@"data"];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            citystr=[[cities objectAtIndex:[pickerView selectedRowInComponent:1]] stringForKey:@"city"];
            cityid=[[cities objectAtIndex:[pickerView selectedRowInComponent:1]] stringForKey:@"id"];
            
            [pickerView reloadComponent:1];
            NSLog(@"选择省dedaode %@ str=%@",cities,citystr);
            paras[@"id"]=[cities[0] stringForKey:@"id"];
            [HttpTool post:@"get_area_by_pid" params:paras success:^(id responseObj) {
                NSLog(@"滚动获取区成功%@",responseObj);
                districts=[responseObj arrayForKey:@"data"];
                
                [pickerView selectRow:0 inComponent:2 animated:YES];
                districtstr=[[districts objectAtIndex:[pickerView selectedRowInComponent:2]] stringForKey:@"district"];
                areaid=[[districts objectAtIndex:[pickerView selectedRowInComponent:2]] stringForKey:@"id"];
                [pickerView reloadComponent:2];
                 _provicetf.text=[NSString stringWithFormat:@"%@%@%@",provincestr,citystr,districtstr];
            } failure:^(NSError *error) {
                NSLog(@"滚动获取区失败%@",error);
            }];
        } failure:^(NSError *error) {
            NSLog(@"滚动获取城市失败%@",error);
        }];

           }
    if (component==1) {
        NSLog(@"低2列");
        citystr=[[cities objectAtIndex:[pickerView selectedRowInComponent:1]] stringForKey:@"city"];
        paras[@"id"]=[cities[row] stringForKey:@"id"];
        [HttpTool post:@"get_area_by_pid" params:paras success:^(id responseObj) {
            NSLog(@"滚动获取区成功%@",responseObj);
            districts=[responseObj arrayForKey:@"data"];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            districtstr=[[districts objectAtIndex:[pickerView selectedRowInComponent:2]] stringForKey:@"district"];
            areaid=[[districts objectAtIndex:[pickerView selectedRowInComponent:2]] stringForKey:@"id"];
            [pickerView reloadComponent:2];
            _provicetf.text=[NSString stringWithFormat:@"%@%@%@",provincestr,citystr,districtstr];
        } failure:^(NSError *error) {
            NSLog(@"滚动获取区失败%@",error);
        }];
        
        
           }
    
    if(component==2){
      NSLog(@"低3列");
        districtstr=[[districts objectAtIndex:[pickerView selectedRowInComponent:2]] stringForKey:@"district"];
        areaid=[[districts objectAtIndex:[pickerView selectedRowInComponent:2]] stringForKey:@"id"];
        _provicetf.text=[NSString stringWithFormat:@"%@%@%@",provincestr,citystr,districtstr];
    }
   

    
   
    
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component==0) {
        return 0.25*MAIN_WIDTH;
    }
    if (component==1) {
        return 0.25*MAIN_WIDTH;
    }
    if (component==2) {
        return 0.5*MAIN_WIDTH;
    }
    return 0;
}


- (IBAction)chooseprovinceBtnClicked:(id)sender {
        self.tabBarController.tabBar.hidden=YES;
    [self.view endEditing:YES];
    
    v=[[[NSBundle mainBundle]loadNibNamed:@"chooseprovince" owner:self options:nil]firstObject];
    v.frame=CGRectMake(0,_container.y+_lastcellincontainer.y+_lastcellincontainer.height, MAIN_WIDTH, MAIN_HEIGHT-(_container.y+_lastcellincontainer.y+_lastcellincontainer.height));
    
    [self.view addSubview:v];
}
@end
