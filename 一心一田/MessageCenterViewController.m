//
//  MessageCenterViewController.m
//  一心一田
//
//  Created by xipin on 16/3/9.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageTableViewCell.h"
@interface MessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tablelist;
}
@property (weak, nonatomic) IBOutlet UILabel *emptynoticeLab;

@end

@implementation MessageCenterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"消息中心";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [self initdata];
}
-(void)initdata{
    tablelist=[NSMutableArray array];
    if(tablelist.count>0){
        _emptynoticeLab.hidden=YES;
    }
    else{
        _emptynoticeLab.hidden=NO;
    }
}
- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tablelist.count;
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell=[MessageTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.105;
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
