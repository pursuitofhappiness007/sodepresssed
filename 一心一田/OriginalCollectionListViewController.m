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
@end

@implementation OriginalCollectionListViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedButton = self.firstbt;
    self.selectedButton.selected = YES;
    self.coverView.hidden = YES;
    self.bottomView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(function) name:@"ButtonClicked" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)function{
    self.coverView.hidden = NO;
    self.bottomView.hidden = NO;
   // self.bottomView.layer.zPosition = 1000;
  
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
