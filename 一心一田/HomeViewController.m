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
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *tablelist;
    UIView *searchview;
}
- (IBAction)phoneBtnClicked:(id)sender;
- (IBAction)searchBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)shucaishuiguoBtnClicked:(id)sender;
- (IBAction)shoucangBtnClicked:(id)sender;
- (IBAction)xinpinClicked:(id)sender;
- (IBAction)changgouBtnClicked:(id)sender;

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
    [self customernavbar];
    [self setNeedsStatusBarAppearanceUpdate];
    [self initdata];
    [self getdatafromserver];
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
    tablelist=[NSMutableArray array];
}

-(void)getdatafromserver{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
 [HttpTool post:@"index" params:paras success:^(id responseObj) {
     if([responseObj int32ForKey:@"result"]==0){
     
     }
 } failure:^(NSError *error) {
     NSLog(@"请求首页数据失败%@",error);
 }];
}

//数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return tablelist.count;
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell=[HomeTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    return cell;

}
//代理方法
//1.加载头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[[NSBundle mainBundle]loadNibNamed:@"tableviewheader" owner:self options:nil]firstObject];
    view.frame=CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT*0.58);
    
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
