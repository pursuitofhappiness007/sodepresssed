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
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *shortComment;
@property (weak, nonatomic) IBOutlet UILabel *specification;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *price3;
@property (weak, nonatomic) IBOutlet UILabel *price4;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (assign, nonatomic)BOOL  isFavour;
@property (weak, nonatomic) IBOutlet UITextView *textArea;

@property (weak, nonatomic) IBOutlet UIButton *productInstuctionBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redlineleadingconstant;
@end

@implementation GoodsDetailViewController
-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden=YES;
}

-(instancetype)init{
   if(self=[super init])
       self.automaticallyAdjustsScrollViewInsets=NO;
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
 self.navigationItem.title = @"商品详情";
   self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
      [self getdatafromweb];
    
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initparas{
    goodsdetail=[NSDictionary dictionary];
}

-(void)getdatafromweb{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"goods_id"]= self.goodsid;
    paras[@"market_id"] = self.marketid;
    paras[@"supplier_id"] = self.supplierid;
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]){
        paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
     }
     [HttpTool post:@"get_goods_detail" params:paras success:^(id responseObj) {
      NSLog(@"商品详情 参数=%@,%@",paras,responseObj);
         if([responseObj int32ForKey:@"result"]==0){
      goodsdetail=[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"goods_detail"];
      self.nameLb.text = goodsdetail[@"name"];
      self.specification.text = goodsdetail[@"specifications"];
      self.isFavour = [[responseObj dictionaryForKey:@"data"] int32ForKey:@"is_favour"];
      self.collectionButton.selected = self.isFavour;
       [[DownLoadImageTool singletonInstance]imageWithImage:goodsdetail[@"thumbnailImg"] scaledToWidth:self.goodImg.width imageview:self.goodImg];
         }
       } failure:^(NSError *error) {
      NSLog(@"获取商品详情失败 %@",error);
  }];
}
- (IBAction)collectionButtonClicked:(UIButton *)sender {
    self.isFavour = !self.isFavour;
    self.collectionButton.selected = self.isFavour;
    [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"商品收藏1"] forState:UIControlStateSelected];
    if (self.isFavour) {
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"goods_id"]= self.goodsid;
        paras[@"supplier_id"] = self.supplierid;
        if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"])
            paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
        [HttpTool post:@"add_favour" params:paras success:^(id responseObj) {
            NSLog(@"收藏商品 参数=%@,%@",paras,responseObj);
            if([responseObj int32ForKey:@"result"]==0){
                NSLog(@"已收藏");
            }else{
                NSLog(@"收藏商品失败 %@", responseObj);
                self.isFavour = NO;
                self.collectionButton.selected = self.isFavour;
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText =@"收藏失败，请检查网络连接!";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.0];

            }
        } failure:^(NSError *error) {
            NSLog(@"收藏商品失败 %@",error);
            self.isFavour = NO;
            self.collectionButton.selected = self.isFavour;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText =@"收藏失败，请检查网络连接";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.0];

        }];

    }else{
//        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
//        NSDictionary *dic = [[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"tokenfile.txt"];
//        NSString *str = [dic stringForKey:@"token"];
//        NSLog(@"token:%@", str);
//        paras[@"token"] = [dic stringForKey:@"token"];
//        paras[@"favour_id"] = [self.collectionListArr[self.cancelCollectBt.tag] stringForKey:@"favour_id"];
//        [HttpTool post:@"delete_favour_by_id" params:paras success:^(id responseObj) {
//            NSLog(@"recharge message:%@",responseObj);
//            if([responseObj int32ForKey:@"result"]==0){
//                [self.collectionListArr removeObjectAtIndex:self.cancelCollectBt.tag] ;
//                [self.tableview reloadData];
//                NSLog(@"获取数据成功");
//                return;
//            } else{
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText=[[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
//                hud.margin = 10.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:1.2];
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"获取数据失败");
//            NSLog(@"%@", error);
//        }];

    
    }
    
}

- (IBAction)productBtOrSupplyBtClicked:(UIButton *)sender {
    sender.selected = YES;
    if (sender.tag == 1) {
        self.redlineleadingconstant.constant = 0;
        self.textArea.text = @"产品介绍";
    }else if(sender.tag == 2){
     self.redlineleadingconstant.constant = self.productInstuctionBt.frame.size.width + 30;
        self.textArea.text = @"供应商信息";
    }
    
    [self updateViewConstraints];
    
    
}


//-(void)displaylocalcontent{
//    int i=0;
//    for (NSDictionary *dict in [goodsdetail arrayForKey:@"goodsGalleries"]) {
//        
//             i++;
//    }
//    [self.view bringSubviewToFront:_pagecontrol];
//  
//    
//    _scrollads.contentSize=CGSizeMake(i*MAIN_WIDTH, 0);
//    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[goodsdetail stringForKey:@"name"] length]*17, _namescrollview.height)];
//    
//    lab.text=[goodsdetail stringForKey:@"name"];
//    _namescrollview.contentSize=CGSizeMake(lab.width, 0);
//    [_namescrollview addSubview:lab];
//    _salepricelab.text=[NSString stringWithFormat:@"¥%.1f",[goodsdetail doubleForKey:@"salePrice"]];
//    
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"价格:¥%.1f",[goodsdetail doubleForKey:@"marketPrice"]]];
//    [attributeString addAttribute:NSStrikethroughStyleAttributeName
//                            value:@2
//                            range:NSMakeRange(0, [attributeString length])];
//       _marketpricelab.attributedText=attributeString;
//
//    _firstbrandlab.text=[NSString stringWithFormat:@"品牌:%@",[goodsdetail stringForKey:@"brandName"]];
//    if(inventeroy)
//    _kucunlab.text=@"库存:有";
//    else
//     _kucunlab.text=@"库存:无";
//    _secondbrandlab.text=[goodsdetail stringForKey:@"brandName"];
//    _goodscodelab.text=[goodsdetail stringForKey:@"code"];
//    
//
//}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    int nextpage=(int)(scrollView.contentOffset.x/MAIN_WIDTH);
//    
//    if(nextpage!=[[goodsdetail arrayForKey:@"goodsGalleries"] count]){
//        
//        
//        _pagecontrol.currentPage=nextpage;
//    }
//    else{
//        _pagecontrol.currentPage=0;
//        scrollView.contentOffset=CGPointMake(0, 0);
//    }
//    
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (IBAction)addtocollection:(id)sender {
//}
//
//- (IBAction)buysoonBtnClicked:(id)sender {
//    if(![[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]){
//    LoginViewController *vc1=[[LoginViewController alloc]init];
//    vc1.source=@"buysoon";
//    [self.navigationController pushViewController:vc1 animated:YES];
//        return;
//    }
//    SingleGoodOrderConfirmnationViewController *vc=[[SingleGoodOrderConfirmnationViewController alloc]init];
//    vc.imageurl=[[[goodsdetail arrayForKey:@"goodsGalleries"] firstObject] stringForKey:@"imgOriginal"];
//    NSLog(@"图像链接%@",vc.imageurl);
//    vc.namestr=[goodsdetail stringForKey:@"name"];
//    vc.singleprice=[goodsdetail floatForKey:@"salePrice"];
//    vc.goodsid=[goodsdetail stringForKey:@"id"];
//    
//    
//    [self.navigationController pushViewController:vc animated:YES];
//    
//
//}


//- (IBAction)carBtnClicked:(id)sender {
// 
//}


@end
