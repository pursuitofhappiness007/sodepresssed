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


@property (weak, nonatomic) IBOutlet UILabel *namelab;
@property (weak, nonatomic) IBOutlet UIImageView *usericon;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundimage;
- (IBAction)changeIconClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shadowoficon;

@end

@implementation PersonalCenterViewController
-(void)viewWillAppear:(BOOL)animated{
   self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(namechangedrefresh) name:@"namechanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshbadgenum) name:@"refreshbadgenum" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateicon) name:@"iconchanged" object:nil];
    
    
    [self setpersoninfo];
    
}

-(void)updateicon{
    [self setpersoninfo];
}

-(void)setpersoninfo{
    _namelab.text=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] dictionaryForKey:@"member_info"] stringForKey:@"name"];
    _usericon.layer.cornerRadius=_usericon.width/2.0;
    _usericon.clipsToBounds=YES;
    _usericon.layer.masksToBounds =YES;
    _usericon.layer.borderWidth=3.0;
        [[DownLoadImageTool singletonInstance]imageWithImage:[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] dictionaryForKey:@"member_info"] stringForKey:@"headPath"] scaledToWidth:_usericon.width imageview:_usericon];
    
   
    _shadowoficon.layer.shadowOffset = CGSizeMake(0, 0);
    _shadowoficon.layer.shadowOpacity = 0.6;
    _shadowoficon.layer.shadowRadius =_usericon.width/2.0;
    _shadowoficon.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowoficon.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:_shadowoficon.bounds cornerRadius:_usericon.width/2.0] CGPath];
    [[DownLoadImageTool singletonInstance]imageWithImage:[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] dictionaryForKey:@"member_info"] stringForKey:@"headPath"] scaledToWidth:_backgroundimage.width imageview:_backgroundimage];
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
    UINavigationController *reVc = [[UINavigationController alloc]initWithRootViewController:rechargeVc];
    [self presentViewController:reVc animated:YES completion:nil];
}
//我的订单
- (IBAction)myOrderclicked:(id)sender {
}
//我的账单
- (IBAction)myBillsBtnClicked:(id)sender {
}
//商品收藏
- (IBAction)goodsCollectionBtnClicked:(id)sender {
    OriginalCollectionListViewController *collectionVc = [[OriginalCollectionListViewController alloc]init];
    UINavigationController *coVc = [[UINavigationController alloc]initWithRootViewController:collectionVc];
    [self presentViewController:coVc animated:YES completion:nil];

}
//消息中心
- (IBAction)msgCenterBtnClicked:(id)sender {
}
//密码修改
- (IBAction)changePwdBtnClicked:(id)sender {
}
//关于我们
- (IBAction)aboutusBtnClicked:(id)sender {
}
//当前版本
- (IBAction)currentVersionBtnClicked:(id)sender {
}

- (IBAction)seePersonInfoClicked:(id)sender {
    PersonalInfomationViewController *vc=[[PersonalInfomationViewController alloc]init];
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
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"修改成功";
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:1.5];
        
        
        NSDictionary *tokenfile=[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"];
        tokenfile[@"member_info"][@"headPath"]=[NSString stringWithFormat:@"http://static.exinetian.com/%@",responseObject[@"url"]];
        [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:tokenfile filepath:@"tokenfile.txt"];
        
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"token"]=[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"][@"token"];
        paras[@"memberModify"]=[DictionaryToJsonStr dictToJsonStr:@{@"headPath":[NSString stringWithFormat:@"http://static.exinetian.com/%@",responseObject[@"url"]]}];
        paras[@"app_source"]=@6;
        
      [HttpTool post:@"modify_personal_property" params:paras success:^(id responseObj) {
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
      }];
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
