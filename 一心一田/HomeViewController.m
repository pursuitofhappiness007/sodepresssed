//
//  HomeViewController.m
//  一心一田
//
//  Created by xipin on 16/3/7.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "ClassficationViewController.h"
#import "LoginViewController.h"
#import "SDCycleScrollView.h"
#import "GoodsDetailViewController.h"
#import "SearchViewController.h"
#import "OriginalCollectionListViewController.h"
#import "newProductViewController.h"
#import "UsuallyBuyViewController.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *tablelist;
    NSMutableArray *navigationArr;
    NSMutableArray *noticeArr;
    UIView *searchview;
    NSString *phonenum;
    int previouscount;
    int totalpage;
    int pagenum;
}
- (IBAction)phoneBtnClicked:(id)sender;
- (IBAction)searchBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)shucaishuiguoBtnClicked:(id)sender;
- (IBAction)shoucangBtnClicked:(id)sender;
- (IBAction)xinpinClicked:(id)sender;
- (IBAction)changgouBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIView *scrollview;

@property (weak, nonatomic) IBOutlet UILabel *noticeLb;

@property (weak, nonatomic) IBOutlet UIImageView *dynamicpicimg;


@property (weak, nonatomic) IBOutlet UILabel *dynamictitlelab;
@property (strong, nonatomic) UIActivityIndicatorView *activit;
@end

@implementation HomeViewController

-(instancetype)init{
  if(self=[super init])
      self.automaticallyAdjustsScrollViewInsets=NO;
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshgoodnum:) name:@"addorminusClick" object:nil];
    [self customernavbar];
    [self setNeedsStatusBarAppearanceUpdate];
    [self initdata];
    [self getdatafromserver];
    [self getTableListDataFromSever:1];
  }

-(void)refreshgoodnum:(NSNotification *)anote{
    NSArray *idsneedtorefresh=[[anote userInfo] arrayForKey:@"id"];
    for (int i=0; i<tablelist.count; i++) {
        HomeTableViewCell *cell=[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if([idsneedtorefresh containsObject:cell.goodsid])
            cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
    }
}
-(void)customernavbar{
    
    UIView *v=[[[NSBundle mainBundle]loadNibNamed:@"NavBarForHome" owner:self options:nil] firstObject];
    v.frame=CGRectMake(0, 0, MAIN_WIDTH, 64);
    [self.view addSubview:v];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)initdata{
   tablelist = [NSMutableArray array];
   navigationArr = [NSMutableArray array];
    noticeArr = [NSMutableArray array];
    pagenum=1;
}

-(void)getdatafromserver{
    //获取首页广告及公告信息
   NSMutableDictionary *paras=[NSMutableDictionary dictionary];
 [HttpTool post:@"index" params:paras success:^(id responseObj) {
     if([responseObj int32ForKey:@"result"]==0){
         
         phonenum=[[responseObj dictionaryForKey:@"data"]stringForKey:@"tel_phone"];
         NSMutableArray *naArr= responseObj[@"data"][@"navigation"];
         NSMutableArray *noArr = responseObj[@"data"][@"notice"];
         noticeArr = [noArr mutableCopy];
         navigationArr = [naArr mutableCopy];
        [self setUpScrollerView];
     }
 } failure:^(NSError *error) {
       NSLog(@"---------------------------------------------------------------");
     NSLog(@"请求首页数据失败%@",error);
       NSLog(@"---------------------------------------------------------------");
 } controler:self];
}

- (void)getTableListDataFromSever:(int)pageno{
    // 获取商品列表数据
   NSMutableDictionary *paras=[NSMutableDictionary dictionary];
   paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    //每次请求的数量
    paras[@"page_size"]=@10;
    paras[@"page_no"]=[NSString stringWithFormat:@"%d",pageno];
    
    [HttpTool post:@"get_goods_list" params:paras success:^(id responseObj) {
        if(tablelist.count>0){
            previouscount=tablelist.count;
            if([[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count]>0)
                [tablelist addObjectsFromArray:[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]];
            //局部刷新
            NSMutableArray *indexs=[NSMutableArray array];
            for(int i=0;i<[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count];i++){
                NSIndexPath *index=[NSIndexPath indexPathForRow:previouscount+i inSection:0];
                [indexs addObject:index];
                //每次从线上请求新的数据都要喝本地同步
                [LocalAndOnlineFileTool keepthesamewithonline:tablelist];
                
            }
            [_tableview beginUpdates];
            [_tableview insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationAutomatic];
            [_tableview endUpdates];
            
            
        }
        else
        {
            if([[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_list"] count]>0){
                _tableview.hidden=NO;
                
                tablelist=[[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_list"] mutableCopy];
                //每次从线上请求新的数据都要喝本地同步
                [LocalAndOnlineFileTool keepthesamewithonline:tablelist];
                NSLog(@"when next can come to here?");
                totalpage=[[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"page"] doubleForKey:@"total_page"];
                NSLog(@"总页数%d",totalpage);
                [_tableview reloadData];
            }
            else
            {
//                _tableview.hidden=YES;
                
            }
            
        }

} failure:^(NSError *error) {

}controler:self];

}

- (void)setUpScrollerView{
    self.noticeLb.text = [noticeArr.firstObject stringForKey:@"title"];
    NSMutableArray *arry = [NSMutableArray array];
    for (int i = 0; i<navigationArr.count; i++) {
        NSDictionary *pollImg = navigationArr[i];
        NSURL *image =  [pollImg stringForKey:@"adCode"];
        [arry addObject:image];
    }
    SDCycleScrollView *scrollView =[[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height*0.58*0.4)];
    [self.scrollview addSubview:scrollView];
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    scrollView.delegate = self;
    scrollView.dotColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        scrollView.imageURLStringsGroup = arry;
    });
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSDictionary *pollImg = navigationArr[index];
    NSString *responsType = pollImg[@"type"];
     NSInteger responsTypeNum = [responsType intValue];
    NSString *constent = pollImg[@"goodsId"];
     [self  responsType:responsTypeNum responsContent:constent];
    
}
- (void)responsType:(NSInteger)responsTypeNum responsContent:(NSString *)content{
    if (responsTypeNum == 1) {
        NSLog(@"1");
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        NSDictionary *dic = [[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"tokenfile.txt"];
        paras[@"token"] = [dic stringForKey:@"token"];
        paras[@"goods_id"] = @"1002";
        paras[@"market_id"] = @"58";
        paras[@"supplier_id"] = @"25";
        [HttpTool post:@"get_goods_detail" params:paras success:^(id responseObj) {
            if([responseObj int32ForKey:@"result"]==0){
                NSLog(@"---------------------------------------------------------------");
                NSLog(@"%@",responseObj);
                 NSLog(@"1");
                NSLog(@"---------------------------------------------------------------");
            }else{
                NSLog(@"%@",responseObj);
            }
        } failure:^(NSError *error) {
            NSLog(@"---------------------------------------------------------------");
            NSLog(@"请求商品详情数据失败%@",error);
            NSLog(@"---------------------------------------------------------------");
        } controler:self];

    }else{
        NSLog(@"2");
    }

}

//数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return tablelist.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell=[HomeTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    NSDictionary *good = tablelist[indexPath.row];
    NSLog(@"%@",good);
    cell.goodsid=[good stringForKey:@"id"];
    cell.goodname = good[@"name"];
    cell.shortcomment = good[@"commentary"];
    cell.detailBtn.tag = indexPath.row;
    [cell.detailBtn addTarget:self action:@selector(goToDetailVC:)  forControlEvents:UIControlEventTouchUpInside];
    cell.specific = good[@"specifications"];
    cell.goodimg = good[@"thumbnailImg"];
    cell.dailysales=[NSString stringWithFormat:@"本市场今日已售%@件",[good stringForKey:@"dailySales"]];
    NSArray *array=[good arrayForKey:@"goodsRangePrices"];
    switch (array.count) {
        case 0:
        {
            cell.pricelab.hidden = NO;
            cell.pricelab.text = [NSString stringWithFormat:@"¥%@", [good stringForKey:@"price"]];
        }
            break;
        case 1:
        {
            cell.range1lab.hidden=NO;
            cell.price1lab.hidden=NO;
            cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
            cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
            
        }
            break;
        case 2:
        {
            cell.range1lab.hidden=NO;
            cell.price1lab.hidden=NO;
            cell.range2lab.hidden=NO;
            cell.price2lab.hidden=NO;
            cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
            cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
            cell.range2=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
            cell.price2=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
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
            cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
            cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
            cell.range2=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
            cell.price2=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
            cell.range3=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
            cell.price3=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
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
            cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
            cell.range2=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
            cell.range3=[NSString stringWithFormat:@"%@-%@",[array[2] stringForKey:@"minNum"],[array[2] stringForKey:@"maxNum"]];
            cell.range4=[NSString stringWithFormat:@"%@-%@",[array[3] stringForKey:@"minNum"],[array[3] stringForKey:@"maxNum"]];
            cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
            cell.price2=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
            cell.price3=[NSString stringWithFormat:@"¥%@",[array[2] stringForKey:@"price"]];
            cell.price4=[NSString stringWithFormat:@"¥%@",[array[3] stringForKey:@"price"]];
        }
            break;
        default:
            break;
    }
    //到沙盒文件里去取数量
    int kcount=[LocalAndOnlineFileTool singlegoodcount:cell.goodsid];
    cell.count=[NSString stringWithFormat:@"%d",kcount];
   
    cell.addBtn.tag=indexPath.row;
    cell.minusBtn.tag=indexPath.row;
    [cell.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)goToDetailVC:(UIButton *)send{
    NSDictionary *good = tablelist[send.tag];
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc]init];
    detailVC.goodsid = good[@"goodsId"];
    detailVC.supplierid = good[@"supplierId"];
    detailVC.marketid = good[@"marketId"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
//代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *good = tablelist[indexPath.row];
//    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc]init];
//    detailVC.goodsid = good[@"goodsId"];
//    detailVC.supplierid = good[@"supplierId"];
//    detailVC.marketid = good[@"marketId"];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)setdynamicpic{
    NSDictionary *dict=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]dictionaryForKey:@"member_info"]dictionaryForKey:@"goodsType"];
    _dynamicpicimg.layer.cornerRadius=_dynamicpicimg.width*0.5;
    _dynamicpicimg.layer.masksToBounds=YES;
    [_dynamicpicimg sd_setImageWithURL:[NSURL URLWithString:[dict stringForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"defualt"]];
    
    _dynamictitlelab.text=[dict stringForKey:@"name"];

}

//1.加载头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[[NSBundle mainBundle]loadNibNamed:@"tableviewheader" owner:self options:nil]firstObject];
    view.frame=CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT*0.58);
    [self setdynamicpic];
    [self setUpScrollerView];
      return view;
}
//2.每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.25;
}
//3.header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MAIN_HEIGHT*0.43;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
        if(pagenum<totalpage&&indexPath.row==tablelist.count-1){
            pagenum++;
            [self getTableListDataFromSever:pagenum];
        }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBtnClicked:(UIButton *)sender{
    HomeTableViewCell *cell=[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    cell.count=[NSString stringWithFormat:@"%d",i+1];
    [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i+1 tabbar:self.tabBarController];
    
}

-(void)minusBtnClicked:(UIButton *)sender{
   HomeTableViewCell *cell=[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    if(i>0){
        if(i==1)
            [cell.minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255  blue:163.0/255  alpha:1.0] forState:UIControlStateNormal];
        cell.count=[NSString stringWithFormat:@"%d",i-1];
        [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i-1 tabbar:self.tabBarController];
    }
}


- (IBAction)phoneBtnClicked:(id)sender {
    if (phonenum.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂未提供客服电话";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.0];
        return;
    }
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phonenum]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"无SIM卡";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.0];
    }

    
}

- (IBAction)searchBtnClicked:(id)sender {
   searchview=[[[NSBundle mainBundle]loadNibNamed:@"NavBarSearchForHome" owner:self options:nil]firstObject];
    searchview.frame=CGRectMake(MAIN_WIDTH, StatusBarH, MAIN_WIDTH*0.83, 44);
    [self.view addSubview:searchview];

    [UIView animateWithDuration:.4 animations:^{
        searchview.x=MAIN_WIDTH*0.16;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)cancelBtnClicked:(id)sender {
    [UIView animateWithDuration:.4 animations:^{
        searchview.x=MAIN_WIDTH;
        
    } completion:^(BOOL finished) {
        [searchview removeFromSuperview];
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    SearchViewController *vc=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    return NO;
}

- (IBAction)shucaishuiguoBtnClicked:(id)sender {
    if(![[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]){
        LoginViewController *vc=[[LoginViewController alloc]init];
        vc.source=@"back";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    ClassficationViewController *vc=[[ClassficationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)shoucangBtnClicked:(id)sender {
    OriginalCollectionListViewController *colletionVC = [[OriginalCollectionListViewController alloc]init];
    [self.navigationController pushViewController:colletionVC animated:YES];
}

- (IBAction)xinpinClicked:(id)sender {
    newProductViewController *nVC = [[newProductViewController alloc]init];
    [self.navigationController pushViewController:nVC animated:YES];
}

- (IBAction)changgouBtnClicked:(id)sender {
    UsuallyBuyViewController *vc=[[UsuallyBuyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
