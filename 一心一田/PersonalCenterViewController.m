//
//  PersonalCenterViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/5.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "AccountRecharge.h"
#import "PersonalInfomationViewController.h"
#import "OriginalCollectionListViewController.h"
#import "AccountDetailViewController.h"
#import "MyOrderViewController.h"
#import "MessageCenterViewController.h"
#import "reSetPwdViewController.h"

@interface PersonalCenterViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
   UIImagePickerController *imagePicker;
    UIImage *usericonimg;
}
- (IBAction)chongzhiBtnClicked:(id)sender;
- (IBAction)myOrderclicked:(id)sender;
- (IBAction)myBillsBtnClicked:(id)sender;
- (IBAction)goodsCollectionBtnClicked:(id)sender;
- (IBAction)msgCenterBtnClicked:(id)sender;
- (IBAction)changePwdBtnClicked:(id)sender;
- (IBAction)aboutusBtnClicked:(id)sender;
- (IBAction)currentVersionBtnClicked:(id)sender;
- (IBAction)seePersonInfoClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UILabel *creditAmount;

@property (weak, nonatomic) IBOutlet UILabel *namelab;
@property (weak, nonatomic) IBOutlet UIImageView *usericon;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundimage;
- (IBAction)changeIconClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shadowoficon;
@property (strong ,nonatomic)NSDictionary *userInfo;
@end

@implementation PersonalCenterViewController
-(void)viewWillAppear:(BOOL)animated{
   self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=NO;
     [self getPersonInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(namechangedrefresh) name:@"namechanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshbadgenum) name:@"refreshbadgenum" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateicon) name:@"iconchanged" object:nil];
   
//  [self setpersoninfo];
    [self getPersonInfo];
    
}

-(void)updateicon{
    [self setpersoninfo];
}


- (void)getPersonInfo{
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    [HttpTool post:@"get_member_by_token" params:paras success:^(id responseObj) {
        NSLog(@"get_member_by_token=%@",responseObj);
        if([responseObj int32ForKey:@"result"]==0){

            NSDictionary *info = [responseObj dictionaryForKey:@"data"];//responseObj[@"data"];
            self.userInfo = info;
            self.namelab.text = [info stringForKey:@"name"];//info[@"name"];
            _usericon.layer.cornerRadius=_usericon.width/2.0;
            _usericon.clipsToBounds=YES;
            _usericon.layer.masksToBounds =YES;
            _usericon.layer.borderWidth=3.0;
            
           [self.usericon sd_setImageWithURL:[NSURL URLWithString:[info stringForKey:@"imagePath"]] placeholderImage:[UIImage imageNamed:@"defualt"]];
            self.amount.text = [NSString stringWithFormat:@"¥%@",[info stringForKey:@"acBal"]];
          self.creditAmount.text = [NSString stringWithFormat:@"¥%@",[info stringForKey:@"amount"]];
            
        }else{
            NSLog(@"个人信息获取失败%@", responseObj);
        }
    } failure:^(NSError *error) {
           }controler:self];

        //返回的json中无此字段
        //    _phone1lab.text=;
        //    _phone2lab.text=;
        //    _phone3lab.text=;
    
    }


-(void)setpersoninfo{
    _namelab.text=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] dictionaryForKey:@"member_info"] stringForKey:@"name"];
    _usericon.layer.cornerRadius=_usericon.width/2.0;
    _usericon.clipsToBounds=YES;
    _usericon.layer.masksToBounds =YES;
    _usericon.layer.borderWidth=3.0;
    [_usericon sd_setImageWithURL:[NSURL URLWithString:[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] dictionaryForKey:@"member_info"] stringForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"defualt"]];
    
    _shadowoficon.layer.shadowOffset = CGSizeMake(0, 0);
    _shadowoficon.layer.shadowOpacity = 0.6;
    _shadowoficon.layer.shadowRadius =_usericon.width/2.0;
    _shadowoficon.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowoficon.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:_shadowoficon.bounds cornerRadius:_usericon.width/2.0] CGPath];
    [_backgroundimage sd_setImageWithURL:[NSURL URLWithString:[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] dictionaryForKey:@"member_info"] stringForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"defualt"]];
}

-(void)namechangedrefresh{
   _namelab.text=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] dictionaryForKey:@"member_info"] stringForKey:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//充值
- (IBAction)chongzhiBtnClicked:(id)sender {
    AccountRecharge *rechargeVc = [[AccountRecharge alloc]init];
    [self.navigationController pushViewController:rechargeVc animated:YES];
}
//我的订单
- (IBAction)myOrderclicked:(id)sender {
    MyOrderViewController *vc=[[MyOrderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//我的账单
- (IBAction)myBillsBtnClicked:(id)sender {
    AccountDetailViewController *acVc = [[AccountDetailViewController alloc]init];
    [self.navigationController pushViewController:acVc animated:YES];
}
//商品收藏
- (IBAction)goodsCollectionBtnClicked:(id)sender {
    OriginalCollectionListViewController *collectionVc = [[OriginalCollectionListViewController alloc]init];
    [self.navigationController pushViewController:collectionVc animated:YES];

}
//消息中心
- (IBAction)msgCenterBtnClicked:(id)sender {
    MessageCenterViewController *mvc = [[MessageCenterViewController alloc]init];
    [self.navigationController pushViewController:mvc animated:YES];
}
//密码修改
- (IBAction)changePwdBtnClicked:(id)sender {
    reSetPwdViewController *rvc = [[reSetPwdViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}
//关于我们
- (IBAction)aboutusBtnClicked:(id)sender {
}
//当前版本
- (IBAction)currentVersionBtnClicked:(id)sender {
}

- (IBAction)seePersonInfoClicked:(id)sender {
    PersonalInfomationViewController *vc=[[PersonalInfomationViewController alloc]init];
    NSArray *phoneArr = self.userInfo[@"phones"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeIconClicked:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"拍照");{
            imagePicker =[[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            break;
            }
        case 1:{
            NSLog(@"从相册选择");
            imagePicker =[[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;

            [self presentViewController:imagePicker animated:YES completion:nil];
            break;}
            
        default:
            break;
    }}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    usericonimg=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSString *stringUrl =@"http://static.exinetian.com/upload.html?fileProject=3&fileItem=2&fileType=1";
    NSData *imgdata=UIImageJPEGRepresentation(usericonimg, 0.5);
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:stringUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imgdata name:@"image" fileName:@"avator.jpeg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"图片上船Success: %@", responseObject);
        NSDictionary *tokenfile=[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"];
        tokenfile[@"member_info"][@"headPath"]=[NSString stringWithFormat:@"http://static.exinetian.com/%@",responseObject[@"url"]];
        [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:tokenfile filepath:@"tokenfile.txt"];
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"token"]=[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"][@"token"];
        paras[@"memberModify"]=[DictionaryToJsonStr dictToJsonStr:@{@"headPath":[NSString stringWithFormat:@"http://static.exinetian.com/%@",responseObject[@"url"]]}];
        
      [HttpTool post:@"modify_personal_property" params:paras success:^(id responseObj) {
          NSLog(@"上传地址后的json＝%@",responseObj);
          if([responseObj int32ForKey:@"result"]==-1){
              MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
              
              // Configure for text only and offset down
              hud.mode = MBProgressHUDModeText;
              
              hud.labelText =@"头像修改失败";
              hud.margin = 10.f;
              hud.removeFromSuperViewOnHide = YES;
              
              [hud hide:YES afterDelay:1.2];
          }
          else{
              _usericon.image=usericonimg;
              _backgroundimage.image=usericonimg;
              MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
              [self.navigationController.view addSubview:HUD];
              HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
              HUD.mode = MBProgressHUDModeCustomView;
              HUD.labelText = @"头像修改成功";
              
              [HUD show:YES];
              [HUD hide:YES afterDelay:1.5];
          }
      } failure:^(NSError *error) {
          NSLog(@"头像上传失败%@",error);
      } controler:self];
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"图像上传失败  %@",error);
          }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
