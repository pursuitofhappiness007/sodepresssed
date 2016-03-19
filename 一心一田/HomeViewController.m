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
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    NSMutableArray *tablelist;
    NSMutableArray *navigationArr;
    NSMutableArray *noticeArr;
    UIView *searchview;
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
    [self customernavbar];
    [self setNeedsStatusBarAppearanceUpdate];
    [self initdata];
    [self getdatafromserver];
    [self getTableListDataFromSever];
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
}

-(void)getdatafromserver{
    //获取首页广告及公告信息
   NSMutableDictionary *paras=[NSMutableDictionary dictionary];
 [HttpTool post:@"index" params:paras success:^(id responseObj) {
     if([responseObj int32ForKey:@"result"]==0){
         NSLog(@"---------------------------------------------------------------");
         NSLog(@"首页数据%@",responseObj);
         NSLog(@"---------------------------------------------------------------");
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
 }];
}

- (void)getTableListDataFromSever{
    // 获取商品列表数据
   NSMutableDictionary *paras=[NSMutableDictionary dictionary];
   paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    [HttpTool post:@"get_goods_list" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==0){
            NSLog(@"---------------------------------------------------------------");
            NSLog(@"首页商品列表信息%@",responseObj);
            NSLog(@"---------------------------------------------------------------");
            NSMutableArray *listArr= responseObj[@"data"][@"goods_list"];
            tablelist = [listArr mutableCopy];
            [self.tableview reloadData];
        }else{
            NSLog(@"请求首页商品列表数据有误%@", responseObj);
        }
    } failure:^(NSError *error) {
        NSLog(@"---------------------------------------------------------------");
        NSLog(@"请求首页商品列表数据失败%@",error);
        NSLog(@"---------------------------------------------------------------");
    }];

}

- (void)setUpScrollerView{
    self.noticeLb.text = [noticeArr.firstObject stringForKey:@"title"];
    NSMutableArray *arry = [NSMutableArray array];
    for (int i = 0; i<navigationArr.count; i++) {
        NSDictionary *pollImg = navigationArr[i];
        NSURL *image = pollImg[@"adCode"];
        [arry addObject:image];
    }
    SDCycleScrollView *scrollView =[[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.scrollview.bounds.size.width, self.scrollview.frame.size.height)];
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
        }];

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
    cell.goodname = good[@"name"];
    cell.shortcomment = good[@"commentary"];
    cell.specific = good[@"specifications"];
    cell.goodimg = good[@"thumbnailImg"];
    return cell;
}

//代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *good = tablelist[indexPath.row];
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc]init];
    detailVC.goodsid = good[@"goodsId"];
    detailVC.supplierid = good[@"supplierId"];
    detailVC.marketid = good[@"marketId"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

//1.加载头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *view=[[[NSBundle mainBundle]loadNibNamed:@"tableviewheader" owner:self options:nil]firstObject];
    view.frame=CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT*0.58);
     [self setUpScrollerView];
      return view;
}
//2.每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.25;
}
//3.header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MAIN_HEIGHT*0.58;
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

- (IBAction)phoneBtnClicked:(id)sender {
    
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
}

- (IBAction)xinpinClicked:(id)sender {
}

- (IBAction)changgouBtnClicked:(id)sender {
    
}
@end
