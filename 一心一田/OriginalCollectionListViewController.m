//
//  OriginalCollectionListViewController.m
//  一心一田
//
//  Created by user on 16/3/11.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "OriginalCollectionListViewController.h"
#import "CollectionListTableViewCell.h"
@interface OriginalCollectionListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *firstbt;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeadingConstrains;
@property (nonatomic,strong)UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *collectionListArr;
@end

@implementation OriginalCollectionListViewController
- (NSMutableArray *)collectionListArr{
    if (!_collectionListArr) {
        _collectionListArr = [[NSMutableArray alloc]init];
    }
    return _collectionListArr;
}

- (void)viewWillAppear:(BOOL)animated{
  //  self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品列表";
    UIButton  *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backBtn setImage:[UIImage imageNamed:@"backpretty"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.selectedButton = self.firstbt;
    self.selectedButton.selected = YES;
    self.coverView.hidden = YES;
    self.bottomView.hidden = YES;
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(function) name:@"ButtonClicked" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)function{
    self.coverView.hidden = NO;
    self.bottomView.hidden = NO;
   // self.bottomView.layer.zPosition = 1000;
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    }];
}
#pragma mark - UITableViewataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return tablelist.count;
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionListTableViewCell    *cell=[CollectionListTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

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
- (IBAction)addToShoppingCar:(id)sender {
    NSLog(@"加入购物车");
}
- (IBAction)cancelCollection:(id)sender {
    NSLog(@"取消收藏");
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
