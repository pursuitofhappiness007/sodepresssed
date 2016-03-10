//
//  NewAddressViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/14.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "NewAddressViewController.h"

@interface NewAddressViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *v;
    NSMutableArray *provinces;
    NSArray *cities;
    NSArray *districts;
     NSString *areaid;
    NSArray *initialselected;
    NSString *provincestr;
    NSString *citystr;
    NSString *districtstr;
    BOOL btnClicked;
    NSString *status;
   
}
- (IBAction)choosepcdBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *provicetf;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *zipcodetf;
@property (weak, nonatomic) IBOutlet UITextField *deliveryaddresstf;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *receivertf;
- (IBAction)setdefaultBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *chooseornotimg;

@end

@implementation NewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"新增收货地址";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [self initparas];
}

-(void)initparas{
    provinces=[NSArray array];
    cities=[NSArray array];
    districts=[NSArray array];
    initialselected=[NSArray array];
    btnClicked=NO;
    status=@"0";
    
    
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    [HttpTool post:@"get_area_by_pid" params:paras success:^(id responseObj) {
        NSLog(@"获得的所有省%@",responseObj);
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

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
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

            
            [pickerView reloadComponent:1];
            
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    
    return YES;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [v removeFromSuperview];
    
    return YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)choosepcdBtnClicked:(id)sender {
    self.tabBarController.tabBar.hidden=YES;
    [self.view endEditing:YES];
    
    v=[[[NSBundle mainBundle]loadNibNamed:@"popprivincechooser" owner:self options:nil]firstObject];
    v.frame=CGRectMake(0,_saveBtn.y+_saveBtn.height+30, MAIN_WIDTH, MAIN_HEIGHT-(_saveBtn.y+_saveBtn.height+30));
    
    [self.view addSubview:v];
    provincestr=[[provinces objectAtIndex:0] stringForKey:@"province"];
    
    citystr=[[cities objectAtIndex:0] stringForKey:@"city"];
    
    districtstr=[[districts objectAtIndex:0] stringForKey:@"district"];
    
    _provicetf.text=[NSString stringWithFormat:@"%@%@%@",provincestr,citystr,districtstr];

}
- (IBAction)saveBtnClicked:(id)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    if(_receivertf.text.length==0||_phonetf.text.length!=11||_provicetf.text.length==0||_deliveryaddresstf.text.length==0||(_zipcodetf.text.length!=0&&_zipcodetf.text.length!=6))
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您输入的信息有误!";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.0];
        return;
    
    }
    paras[@"delivery"]=[DictionaryToJsonStr dictToJsonStr:@{@"areaId":areaid,@"deliveryAddress":_deliveryaddresstf.text,@"cellPhone":_phonetf.text,@"receiver":_receivertf.text,@"status":status}];
    
    [HttpTool post:@"add_delivery" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==-1){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.0];
        }
        else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"newaddresssucceed" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"添加收货地址失败 %@",error);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)setdefaultBtnClicked:(id)sender {
    if(!btnClicked){
        _chooseornotimg.image=[UIImage imageNamed:@"check"];
        btnClicked=YES;
        status=@"1";
    }
    else{
        _chooseornotimg.image=[UIImage imageNamed:@"设为默认"];
        btnClicked=NO;
    status=@"0";
    }
}
@end
