//
//  GoodsDetailViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/10.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SingleGoodOrderConfirmnationViewController.h"

@interface GoodsDetailViewController ()<UIScrollViewDelegate>{
    NSDictionary *goodsdetail;
    BOOL inventeroy;
    UIView *navbar;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollads;
@property (weak, nonatomic) IBOutlet UILabel *salepricelab;
@property (weak, nonatomic) IBOutlet UILabel *marketpricelab;
@property (weak, nonatomic) IBOutlet UILabel *firstbrandlab;
@property (weak, nonatomic) IBOutlet UILabel *kucunlab;
@property (weak, nonatomic) IBOutlet UILabel *secondbrandlab;
@property (weak, nonatomic) IBOutlet UILabel *goodscodelab;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@property (weak, nonatomic) IBOutlet UIView *goodsparaviewcontainer;
@property (weak, nonatomic) IBOutlet UIView *goodsdetailviewcontainer;
@property (weak, nonatomic) IBOutlet UIScrollView *namescrollview;


@property (weak, nonatomic) IBOutlet UIView *blueline;
@property (weak, nonatomic) IBOutlet UIView *blueline2;
- (IBAction)addtocollection:(id)sender;
- (IBAction)addtoshopcar:(id)sender;
- (IBAction)buysoonBtnClicked:(id)sender;

- (IBAction)goodsparasBtnClicked:(id)sender;
- (IBAction)goodsdetailBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)carBtnClicked:(id)sender;
- (IBAction)homeBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *descriptiontextview;

@end

@implementation GoodsDetailViewController
-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}

-(instancetype)init{
   if(self=[super init])
       self.automaticallyAdjustsScrollViewInsets=NO;
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 20)];
    v.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:v];
    navbar=[[[NSBundle mainBundle]loadNibNamed:@"prettynavbar" owner:self options:nil]firstObject];
    navbar.frame=CGRectMake(0, 20, MAIN_WIDTH, 44);
    [self.view addSubview:navbar];
    [self initparas];
    [self getdatafromweb];
    
}


-(void)initparas{
    goodsdetail=[NSDictionary dictionary];
}

-(void)getdatafromweb{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"goods_id"]=_goodsid;
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"])
        paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
  [HttpTool post:@"get_goods_detail" params:paras success:^(id responseObj) {
      NSLog(@"商品详情 参数=%@,%@",paras,responseObj);
      if([[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"goods_detail"] int32ForKey:@"max_buy_num"]>0)
          inventeroy=YES;
      goodsdetail=[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"goods_detail"];
      [self displaylocalcontent];
  } failure:^(NSError *error) {
      NSLog(@"获取商品详情失败 %@",error);
  }];

}

-(void)displaylocalcontent{
    int i=0;
    for (NSDictionary *dict in [goodsdetail arrayForKey:@"goodsGalleries"]) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(i*MAIN_WIDTH, 0, MAIN_WIDTH, _scrollads.height)];
        
        [[DownLoadImageTool singletonInstance]imageWithImage:[dict stringForKey:@"imgOriginal"]  scaledToWidth:img.width imageview:img];
//        [img sd_setImageWithURL:[NSURL URLWithString:[dict stringForKey:@"imgOriginal"]] placeholderImage:[UIImage imageNamed:@"default"]];
        NSLog(@"图片网址%@",[dict stringForKey:@"imgOriginal"]);
        [_scrollads addSubview:img];
        
        i++;
    }
    [self.view bringSubviewToFront:_pagecontrol];
    _pagecontrol.numberOfPages=i;
    
    _scrollads.contentSize=CGSizeMake(i*MAIN_WIDTH, 0);
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[goodsdetail stringForKey:@"name"] length]*17, _namescrollview.height)];
    
    lab.text=[goodsdetail stringForKey:@"name"];
    _namescrollview.contentSize=CGSizeMake(lab.width, 0);
    [_namescrollview addSubview:lab];
    _salepricelab.text=[NSString stringWithFormat:@"¥%.1f",[goodsdetail doubleForKey:@"salePrice"]];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"价格:¥%.1f",[goodsdetail doubleForKey:@"marketPrice"]]];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [attributeString length])];
       _marketpricelab.attributedText=attributeString;

    _firstbrandlab.text=[NSString stringWithFormat:@"品牌:%@",[goodsdetail stringForKey:@"brandName"]];
    if(inventeroy)
    _kucunlab.text=@"库存:有";
    else
     _kucunlab.text=@"库存:无";
    _secondbrandlab.text=[goodsdetail stringForKey:@"brandName"];
    _goodscodelab.text=[goodsdetail stringForKey:@"code"];
    

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int nextpage=(int)(scrollView.contentOffset.x/MAIN_WIDTH);
    
    if(nextpage!=[[goodsdetail arrayForKey:@"goodsGalleries"] count]){
        
        
        _pagecontrol.currentPage=nextpage;
    }
    else{
        _pagecontrol.currentPage=0;
        scrollView.contentOffset=CGPointMake(0, 0);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addtocollection:(id)sender {
}

- (IBAction)addtoshopcar:(id)sender {
    if(![[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"])
    {
        LoginViewController *vc=[[LoginViewController alloc]init];
        vc.source=@"xinpin";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
        
        paras[@"goodsId"]=_goodsid;
        paras[@"quantity"]=@"1";
        [HttpTool post:@"add_to_cart" params:paras success:^(id responseObj) {
            if([responseObj int32ForKey:@"result"]==0){
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addedtocar" object:nil];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已加入购物车";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:1.5];
            }
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    

}

- (IBAction)buysoonBtnClicked:(id)sender {
    if(![[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]){
    LoginViewController *vc1=[[LoginViewController alloc]init];
    vc1.source=@"buysoon";
    [self.navigationController pushViewController:vc1 animated:YES];
        return;
    }
    SingleGoodOrderConfirmnationViewController *vc=[[SingleGoodOrderConfirmnationViewController alloc]init];
    vc.imageurl=[[[goodsdetail arrayForKey:@"goodsGalleries"] firstObject] stringForKey:@"imgOriginal"];
    NSLog(@"图像链接%@",vc.imageurl);
    vc.namestr=[goodsdetail stringForKey:@"name"];
    vc.singleprice=[goodsdetail floatForKey:@"salePrice"];
    vc.goodsid=[goodsdetail stringForKey:@"id"];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    

}
- (IBAction)goodsparasBtnClicked:(UIButton *)sender {
    _blueline.hidden=NO;
    _blueline2.hidden=YES;
    _goodsdetailviewcontainer.hidden=YES;
    _goodsparaviewcontainer.hidden=NO;
    
}

- (IBAction)goodsdetailBtnClicked:(UIButton *)sender {
    NSLog(@"商品详情de %f",sender.x);
    _blueline.hidden=YES;
    _blueline2.hidden=NO;
    _goodsdetailviewcontainer.hidden=NO;
    _goodsparaviewcontainer.hidden=YES;
    _descriptiontextview.text=[goodsdetail stringForKey:@"introduction"];
    
}

- (IBAction)backBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBarHidden=NO;
}

- (IBAction)carBtnClicked:(id)sender {
    [self addtoshopcar:nil];
}

- (IBAction)homeBtnClicked:(id)sender {
    self.tabBarController.tabBar.hidden=NO;
    if(self.tabBarController.selectedIndex==0)
        [self.navigationController popToRootViewControllerAnimated:YES];
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
@end
