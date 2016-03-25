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
#import "OrderConformationViewController.h"
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
@property (weak, nonatomic) IBOutlet UILabel *range1;
@property (weak, nonatomic) IBOutlet UILabel *range2;
@property (weak, nonatomic) IBOutlet UILabel *range3;
@property (weak, nonatomic) IBOutlet UILabel *range4;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (assign, nonatomic)BOOL  isFavour;
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UILabel *saleNumber;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;

@property (weak, nonatomic) IBOutlet UIButton *productInstuctionBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redlineleadingconstant;
//加减按钮以及数量
- (IBAction)minusBtnClicked:(id)sender;
- (IBAction)addBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countlab;
//底部控件
@property (weak, nonatomic) IBOutlet UILabel *sumkindlab;
@property (weak, nonatomic) IBOutlet UILabel *summoneylab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnClicked:(id)sender;


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
   self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(backBtnClicked)];
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
      self.isFavour = [[responseObj dictionaryForKey:@"data"] int32ForKey:@"is_favour"];
             [self setlocalcontent];
         }
       } failure:^(NSError *error) {
      NSLog(@"获取商品详情失败 %@",error);
  } controler:self];
}

-(void)setlocalcontent{
    self.nameLb.text = goodsdetail[@"name"];
    self.specification.text = goodsdetail[@"specifications"];
    self.collectionButton.selected = self.isFavour;
    [_goodImg sd_setImageWithURL:[NSURL URLWithString:[goodsdetail stringForKey:@"thumbnailImg"]] placeholderImage:[UIImage imageNamed:@"default"]];
    
    //self.saleNumber.text = [NSString stringWithFormat:@"本市场已销售%@件", [goodsdetail stringForKey:@"dailySales"]];
    NSLog(@"%@",goodsdetail);
    NSArray *array=[goodsdetail arrayForKey:@"goodsRangePrices"];
    switch (array.count) {
        case 0:
        {
            _pricelab.hidden = NO;
            _pricelab.text = [NSString stringWithFormat:@"¥%@",[goodsdetail stringForKey:@"price"]];
        }
            break;
        case 1:
        {
            _range1.hidden=NO;
            _price1.hidden=NO;
            _range1.text=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
            _price1.text=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
            
        }
            break;
        case 2:
        {
            _range1.hidden=NO;
            _price1.hidden=NO;
            _range2.hidden=NO;
            _price2.hidden=NO;
            _range1.text=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
            _price1.text=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
            _range2.text=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
            _price2.text=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
        }
            break;
        case 3:
        {
            _range1.hidden=NO;
            _price1.hidden=NO;
            _range2.hidden=NO;
            _price2.hidden=NO;
            _range3.hidden=NO;
            _price3.hidden=NO;
            _range1.text=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
            _price1.text=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
            _range2.text=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
            _price2.text=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
            _range3.text=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
            _price3.text=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
        }
            break;
        case 4:
        {
            _range1.hidden=NO;
            _price1.hidden=NO;
            _range2.hidden=NO;
            _price2.hidden=NO;
            _range3.hidden=NO;
            _price3.hidden=NO;
            _range4.hidden=NO;
            _price4.hidden=NO;
            _range1.text=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
            _range2.text=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
            _range3.text=[NSString stringWithFormat:@"%@-%@",[array[2] stringForKey:@"minNum"],[array[2] stringForKey:@"maxNum"]];
            _range4.text=[NSString stringWithFormat:@"%@-%@",[array[3] stringForKey:@"minNum"],[array[3] stringForKey:@"maxNum"]];
            _price1.text=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
            _price2.text=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
            _price3.text=[NSString stringWithFormat:@"¥%@",[array[2] stringForKey:@"price"]];
            _price4.text=[NSString stringWithFormat:@"¥%@",[array[3] stringForKey:@"price"]];
        }
            break;
        default:
            break;
    }
    _countlab.text=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:[goodsdetail stringForKey:@"id"]]];
    [self setbottombar];
}

-(void)setbottombar{
    //设置种类
    _sumkindlab.text=[NSString stringWithFormat:@"%d种商品",[LocalAndOnlineFileTool refreshkindnum:self.tabBarController]];
    //设置商品数量
    [_payBtn setTitle:[NSString stringWithFormat:@"去支付(%d)",[LocalAndOnlineFileTool refreshcoungnum]] forState:UIControlStateNormal];
    //设置参考价格
    _summoneylab.text=[NSString stringWithFormat:@"¥%.2f",[LocalAndOnlineFileTool calculatesummoneyinshopcar]];
}
- (IBAction)collectionButtonClicked:(UIButton *)sender {
    
    [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"商品收藏1"] forState:UIControlStateSelected];
    if (!self.isFavour) {
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"goods_id"]= self.goodsid;
        paras[@"supplierId"] = self.supplierid;
        if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"])
            paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
        [HttpTool post:@"add_favour" params:paras success:^(id responseObj) {
            NSLog(@"收藏商品 参数=%@,%@",paras,responseObj);
            if([responseObj int32ForKey:@"result"]==0){
                NSLog(@"已收藏");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText =@"商品收藏成功！";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.0];
                self.isFavour = YES;
                self.collectionButton.selected = self.isFavour;
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

        } controler:self];

    }else{
        //取消收藏
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        NSDictionary *dic = [[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"tokenfile.txt"];
        NSLog(@"dic%@", dic);
        paras[@"token"] = [dic stringForKey:@"token"];
        paras[@"goodsId"] = [goodsdetail stringForKey:@"goodsId"];
        paras[@"supplierId"] = [goodsdetail stringForKey:@"supplierId"];
        paras[@"marketId"] = [goodsdetail stringForKey:@"marketId"];
        [HttpTool post:@"delete_favour_by_id" params:paras success:^(id responseObj) {
            NSLog(@"recharge message:%@",responseObj);
            if([responseObj int32ForKey:@"result"]==0){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText= @"已取消收藏";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.2];
                self.isFavour = NO;
                self.collectionButton.selected = self.isFavour;
            } else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText=[[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.2];
            }
        } failure:^(NSError *error) {
            NSLog(@"获取数据失败");
            NSLog(@"%@", error);
        } controler:self];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)minusBtnClicked:(id)sender {
    int i=[_countlab.text intValue];
    if(i>0){
        _countlab.text=[NSString stringWithFormat:@"%d",i-1];
        [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:[goodsdetail stringForKey:@"id"] withcount:i-1 tabbar:self.tabBarController];
        [self setbottombar];
    }

}

- (IBAction)addBtnClicked:(id)sender {
    int i=[_countlab.text intValue];
    _countlab.text=[NSString stringWithFormat:@"%d",i+1];
    [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:[goodsdetail stringForKey:@"id"] withcount:i+1 tabbar:self.tabBarController];
    [self setbottombar];
}
- (IBAction)payBtnClicked:(id)sender {
    OrderConformationViewController *vc=[[OrderConformationViewController alloc]init];
    vc.tabledata=[[LocalAndOnlineFileTool getbuyinggoodslist] mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
