//
//  PersonalInfomationViewController.m
//  一心一田
//
//  Created by xipin on 16/3/9.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "PersonalInfomationViewController.h"
#import "EditNickNameViewController.h"
#import "BPush.h"
@interface PersonalInfomationViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImagePickerController *imagePicker;
    UIImage *usericonimg;
}
@property (weak, nonatomic) IBOutlet UIImageView *personalIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernamelab;
@property (weak, nonatomic) IBOutlet UILabel *phone1lab;
@property (weak, nonatomic) IBOutlet UILabel *phone2lab;
@property (weak, nonatomic) IBOutlet UILabel *phone3lab;
- (IBAction)exitLoginBtnClicked:(id)sender;
- (IBAction)changeIconBtnClicked:(id)sender;
- (IBAction)changepersonalinfo:(UIButton *)sender;

@end

@implementation PersonalInfomationViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personinfochangedupdate) name:@"tokenfilechanged" object:nil];
    self.navigationItem.title=@"个人资料";
    [UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [self setlocalcontent];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)personinfochangedupdate{
    [self setlocalcontent];

}

-(void)setlocalcontent{
    NSDictionary *dict=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]dictionaryForKey:@"member_info"];
    _personalIcon.layer.cornerRadius=_personalIcon.width/2.0;
    _personalIcon.clipsToBounds=YES;
    _personalIcon.layer.masksToBounds =YES;

    [[DownLoadImageTool singletonInstance]imageWithImage:[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"imagePath"] scaledToWidth:_personalIcon.width imageview:_personalIcon];
    _usernamelab.text=[dict stringForKey:@"name"];
    //返回的json中无此字段
//    _phone1lab.text=;
//    _phone2lab.text=;
//    _phone3lab.text=;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitLoginBtnClicked:(id)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    [HttpTool post:@"logout" params:paras success:^(id responseObj) {
        NSLog(@"退出帐号%@",responseObj);
        [[SaveFileAndWriteFileToSandBox singletonInstance]removefile:@"tokenfile.txt"];
        //注销消息推送
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"baidu_user_id"]=[BPush getUserId];
        paras[@"baidu_channel_id"]=[BPush getChannelId];
        paras[@"baidu_app_id"]=[BPush getAppId];
        paras[@"device_type"]=@"4";
        [HttpTool post:@"msg_push_unregister" params:paras success:^(id responseObj) {
            NSLog(@"注销推送成功%@",responseObj);
        } failure:^(NSError *error) {
            NSLog(@"注销推送失败%@",error);
        }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:nil];
        UIView * fromView = self.tabBarController.selectedViewController.view;
            UIView * toView =[[self.tabBarController.viewControllers objectAtIndex:0] view];
            [UIView transitionFromView:fromView
                                toView:toView
                              duration:0.5
                               options:(0>self.tabBarController.selectedIndex? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                            completion:^(BOOL finished) {
                                if(finished){
                                   
                                    }
                            }];
        

    } failure:^(NSError *error) {
        NSLog(@"注销失败%@",error);
    }];

    
}

- (IBAction)changeIconBtnClicked:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (IBAction)changepersonalinfo:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
        //修改昵称
            EditNickNameViewController *vc=[[EditNickNameViewController alloc]init];
            vc.stringtobechanged=_usernamelab.text;
            vc.type=Nickname;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
        //修改电话1
            EditNickNameViewController *vc=[[EditNickNameViewController alloc]init];
            vc.stringtobechanged=_phone1lab.text;
            vc.type=Phone1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
        //修改电话2
            EditNickNameViewController *vc=[[EditNickNameViewController alloc]init];
            vc.stringtobechanged=_phone2lab.text;
            vc.type=Phone2;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
        //修改电话3
            EditNickNameViewController *vc=[[EditNickNameViewController alloc]init];
            vc.stringtobechanged=_phone3lab.text;
            vc.type=Phone3;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
                _personalIcon.image=usericonimg;
                MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.labelText = @"头像修改成功";
                
                [HUD show:YES];
                [HUD hide:YES afterDelay:1.5];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"iconchanged" object:nil];
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
