//
//  OriginalCollectionListViewController.m
//  一心一田
//
//  Created by user on 16/3/11.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "OriginalCollectionListViewController.h"
#import "CollectionListTableViewCell.h"
#import "GoodsDetailViewController.h"
@interface OriginalCollectionListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *firstbt;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeadingConstrains;
@property (nonatomic,strong)UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *collectionListArr;
@property (weak, nonatomic) IBOutlet UIButton *addToShopCarBt;
@property (weak, nonatomic) IBOutlet UIButton *cancelCollectBt;

@end

@implementation OriginalCollectionListViewController

- (NSMutableArray *)collectionListArr{
    if (!_collectionListArr) {
        _collectionListArr = [[NSMutableArray alloc]init];
    }
    return _collectionListArr;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品收藏";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(goBack)];
    self.selectedButton = self.firstbt;
    self.selectedButton.selected = YES;
    self.coverView.hidden = YES;
    self.bottomView.hidden = YES;
    [self getData];
    self.tableview.tableFooterView = [UIView new];
    // Do any additional setup after loading the view from its nib.
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//数据方法
- (void)getData{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    NSDictionary *dic = [[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"tokenfile.txt"];
    NSString *str = [dic stringForKey:@"token"];
    NSLog(@"token:%@", str);
    paras[@"token"] = [dic stringForKey:@"token"];
    [HttpTool post:@"get_favour_list" params:paras success:^(id responseObj) {
        NSLog(@"recharge message:%@",responseObj);
        if([responseObj int32ForKey:@"result"]==0){
        NSMutableArray *arr = [[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"favour"] ;
            self.collectionListArr = [arr mutableCopy] ;
            [self.firstbt setTitle:[NSString stringWithFormat:@"全部商品(%ld)",self.collectionListArr.count] forState:UIControlStateNormal];
            if (!self.collectionListArr.count) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText=@"暂无收藏商品";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.2];
               // self.noticeLab.hidden = NO;
            }
             [self.tableview reloadData];
            NSLog(@"获取数据成功");
            return;
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
#pragma mark - UITableViewataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.collectionListArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.selectedButton.tag) {
        case 0:{
            self.tableview.hidden = NO;
            CollectionListTableViewCell    *cell=[CollectionListTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
            NSDictionary *dic = self.collectionListArr[indexPath.row];
            NSLog(@"%@",[dic dictionaryForKey:@"goods"]);
            cell.goodname = [[dic dictionaryForKey:@"goods"]stringForKey:@"name"];
            cell.shortcomment = [[dic dictionaryForKey:@"goods"]stringForKey:@"commentary"];
            cell.specific = [[dic dictionaryForKey:@"goods"]stringForKey:@"specifications"];
            cell.goodimage = [[dic dictionaryForKey:@"goods"]stringForKey:@"thumbnailImg"];
            //cell.goodimage = @"http://static.exinetian.com/b2v/goods/image/source/2016328/1459159512201771.jpg";
            cell.actionBt.tag = indexPath.row;
            [cell.actionBt addTarget:self action:@selector(function:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailBtn.tag = indexPath.row;
            [cell.detailBtn addTarget:self action:@selector(goToDetailVC:) forControlEvents:UIControlEventTouchUpInside];
            NSArray *array=[[dic dictionaryForKey:@"goods"] arrayForKey:@"goodsRangePrices"];
            switch (array.count) {
                case 0:
                {
                   
                    cell.pricelab.hidden = NO;
                    cell.pricelab.text = [NSString stringWithFormat:@"¥%@", [[dic dictionaryForKey:@"goods"] stringForKey:@"price"]];
                }
                    break;
                case 1:
                {
                    cell.range1lab.hidden=NO;
                    cell.price1lab.hidden=NO;
                    cell.range1lab.text=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
                    cell.price1lab.text=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
                    
                }
                    break;
                case 2:
                {
                    cell.range1lab.hidden=NO;
                    cell.price1lab.hidden=NO;
                    cell.range2lab.hidden=NO;
                    cell.price2lab.hidden=NO;
                    cell.range1lab.text=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
                    cell.price1lab.text=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
                    cell.range2lab.text=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
                    cell.price2lab.text=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
                }
                    break;
                case 3:
                {
                    cell.range1lab.hidden=NO;
                    cell.price1lab.hidden=NO;
                    cell.range2lab.hidden=NO;
                    cell.price2lab.hidden=NO;
                    cell.range3lab.hidden=NO;
                    cell.price3lab.hidden=NO;
                    cell.range1lab.text=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
                    cell.price1lab.text=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
                    cell.range2lab.text=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
                    cell.price2lab.text=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
                    cell.range3lab.text=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
                    cell.price3lab.text=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
                }
                    break;
                case 4:
                {
                    cell.range1lab.hidden=NO;
                    cell.price1lab.hidden=NO;
                    cell.range2lab.hidden=NO;
                    cell.price2lab.hidden=NO;
                    cell.range3lab.hidden=NO;
                    cell.price3lab.hidden=NO;
                    cell.range4lab.hidden=NO;
                    cell.price4lab.hidden=NO;
                    cell.range1lab.text=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
                    cell.range2lab.text=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
                    cell.range3lab.text=[NSString stringWithFormat:@"%@-%@",[array[2] stringForKey:@"minNum"],[array[2] stringForKey:@"maxNum"]];
                    cell.range4lab.text=[NSString stringWithFormat:@"%@-%@",[array[3] stringForKey:@"minNum"],[array[3] stringForKey:@"maxNum"]];
                    cell.price1lab.text=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
                    cell.price2lab.text=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
                    cell.price3lab.text=[NSString stringWithFormat:@"¥%@",[array[2] stringForKey:@"price"]];
                    cell.price4lab.text=[NSString stringWithFormat:@"¥%@",[array[3] stringForKey:@"price"]];
                }
                    break;
                default:
                    break;
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            CollectionListTableViewCell    *cell=[CollectionListTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
            NSDictionary *dic = self.collectionListArr[indexPath.row];
            NSLog(@"%@",[dic dictionaryForKey:@"goods"]);
            self.tableview.hidden = YES;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText=@"暂无降价／失效宝贝！";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.2];
            return cell;
        }
            break;
        default:
            break;
      }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.25;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//       [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSDictionary *good = [_collectionListArr[indexPath.row] dictionaryForKey:@"goods"];
//    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc]init];
//    detailVC.goodsid = good[@"goodsId"];
//    detailVC.supplierid = good[@"supplierId"];
//    detailVC.marketid = good[@"marketId"];
//    [self.navigationController pushViewController:detailVC animated:YES];
//}

- (void)goToDetailVC:(UIButton *)sender{
    NSDictionary *good = [_collectionListArr[sender.tag] dictionaryForKey:@"goods"];
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc]init];
    detailVC.goodsid = good[@"goodsId"];
    detailVC.supplierid = good[@"supplierId"];
    detailVC.marketid = good[@"marketId"];
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)function:(UIButton *)sender{
    self.coverView.hidden = NO;
    self.bottomView.hidden = NO;
    self.addToShopCarBt.tag = sender.tag;
    self.cancelCollectBt.tag = sender.tag;
}

//全部商品和降价宝贝按钮的点击
- (IBAction)buttonClicked:(UIButton *)sender {
    self.selectedButton.selected = NO;
    self.selectedButton = sender;
    self.selectedButton.selected = YES;
    self.labelLeadingConstrains.constant =  5+self.firstbt.frame.size.width*sender.tag;
    [self updateViewConstraints];
    [self.tableview reloadData];

}
- (IBAction)cancel:(id)sender {
    NSLog(@"取消");
    self.bottomView.hidden = YES;
    self.coverView.hidden = YES;
}
- (IBAction)addToShoppingCar:(UIButton *)sender {
    NSLog(@"加入购物车");
    self.bottomView.hidden = YES;
    self.coverView.hidden = YES;
    NSLog(@"%@",_collectionListArr[self.addToShopCarBt.tag]);
//    if ([LocalAndOnlineFileTool singlegoodcount:[_collectionListArr[self.addToShopCarBt.tag]  stringForKey:@"id"]] == 0) {
//          [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:[_collectionListArr[self.addToShopCarBt.tag]  stringForKey:@"id"] withcount:1 tabbar:self.tabBarController];
//    }
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText= @"已加入购物车";
//    hud.margin = 10.f;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:1.2];
}

//取消收藏按钮
- (IBAction)cancelCollection:(id)sender {
    NSLog(@"取消收藏");
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    NSDictionary *dic = [[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"tokenfile.txt"];
    paras[@"token"] = [dic stringForKey:@"token"];
    NSDictionary *collect = [self.collectionListArr[self.cancelCollectBt.tag] dictionaryForKey:@"goods"];
    NSLog(@"token:%@", collect);
    paras[@"goodsId"] = [collect stringForKey:@"goodsId"];
    paras[@"supplierId"] = [collect stringForKey:@"supplierId"];
    paras[@"marketId"] = [collect stringForKey:@"marketId"];
      [HttpTool post:@"delete_favour_by_id" params:paras success:^(id responseObj) {
        NSLog(@"recharge message:%@",responseObj);
        if([responseObj int32ForKey:@"result"]==0){
           [self.collectionListArr removeObjectAtIndex:self.cancelCollectBt.tag] ;
            [self.tableview reloadData];
            NSLog(@"获取数据成功");
            return;
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
    self.bottomView.hidden = YES;
    self.coverView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
