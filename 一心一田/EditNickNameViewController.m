//
//  EditNickNameViewController.m
//  kitchen
//
//  Created by xipin on 15/12/17.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "EditNickNameViewController.h"

@interface EditNickNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nametf;
- (IBAction)saveBtnClicked:(id)sender;

@end

@implementation EditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=NO;
    [self setnavtitle];
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(backBtnClicked)];
    _nametf.text=_stringtobechanged;
}
-(void)setnavtitle
{
    switch (_type) {
        case Nickname:
        {
        self.navigationItem.title=@"昵称修改";
        }
            break;
            
        default:
            self.navigationItem.title=@"电话修改";
            break;
    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveBtnClicked:(id)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    NSMutableArray *phones=[[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] dictionaryForKey:@"member_info"] arrayForKey:@"phones"]mutableCopy];
    NSMutableArray *phonesArr = [NSMutableArray array];
    for (int i = 0; i < phones.count; i ++)
        [phonesArr addObject:phones[i]];
    for (int i = phones.count; i < 3; i ++)
        [phonesArr addObject:@""];
    NSLog(@"*************%@", phonesArr);
    switch (_type) {
        case Nickname:
        {
            paras[@"memberModify"]=[DictionaryToJsonStr dictToJsonStr:@{@"name":_nametf.text}];
        }
            break;
        case Phone1:
        {
            [phonesArr replaceObjectAtIndex:0 withObject:_stringtobechanged];
            paras[@"memberModify"]=[DictionaryToJsonStr dictToJsonStr:@{@"phones":[NSString stringWithFormat:@"%@",phonesArr]}];
        }
            break;
        case Phone2:
        {
            [phonesArr replaceObjectAtIndex:1 withObject:_stringtobechanged];
            paras[@"memberModify"]=[DictionaryToJsonStr dictToJsonStr:@{@"phones":[NSString stringWithFormat:@"%@",phonesArr]}];
        }
            break;
        case Phone3:
        {
            [phonesArr replaceObjectAtIndex:2 withObject:_stringtobechanged];
            paras[@"memberModify"]=[DictionaryToJsonStr dictToJsonStr:@{@"phones":[NSString stringWithFormat:@"%@",phonesArr]}];
        }
            break;
        default:
            break;
    }
    
    [HttpTool post:@"modify_personal_property" params:paras success:^(id responseObj) {
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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            
            hud.labelText =@"修改成功!";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1.2];
            //个人信息修改成功后，及时修改沙河里面的文件，更新前面控制器的信息
            NSDictionary *infodic = [[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"tokenfile.txt"];
            [infodic setValue:_nametf.text forKey:@"name"];
            [infodic setValue:phonesArr forKey:@"phones"];
            [[SaveFileAndWriteFileToSandBox singletonInstance] savefiletosandbox:infodic filepath:@"tokenfile.txt"];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"personinfochanged" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSError *error) {
        NSLog(@"昵称修改失败%@",error);
    } controler:self];
}
- (IBAction)textFieldDIdEndOnExist:(UITextField *)sender {
    
}


@end
