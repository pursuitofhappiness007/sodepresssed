//
//  UsuallyBuyViewController.m
//  一心一田
//
//  Created by xipin on 16/3/22.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "UsuallyBuyViewController.h"
#import "HomeTableViewCell.h"
@interface UsuallyBuyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tablelist;
    int pagenum;
    int previouscount;
    int totalpage;
}
//点击底部购物车小按钮
- (IBAction)carIconClicked:(id)sender;

@end

@implementation UsuallyBuyViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"常购";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [self initparas];
    [self getdataformweb];
    [self setbottombar];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initparas{
    tablelist=[NSMutableArray array];
    pagenum=1;
}

-(void)setbottombar{

}
-(void)getdataformweb{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return tablelist.count;
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell=[HomeTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
//    NSDictionary *good = tablelist[indexPath.row];
//    cell.goodsid=[good stringForKey:@"id"];
//    cell.goodname = good[@"name"];
//    cell.shortcomment = good[@"commentary"];
//    cell.specific = good[@"specifications"];
//    cell.goodimg = good[@"thumbnailImg"];
//    NSArray *array=[good arrayForKey:@"goodsRangePrices"];
//    switch (array.count) {
//        case 0:
//        {
//        }
//            break;
//        case 1:
//        {
//            cell.range1lab.hidden=NO;
//            cell.price1lab.hidden=NO;
//            cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
//            cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
//            
//        }
//            break;
//        case 2:
//        {
//            cell.range1lab.hidden=NO;
//            cell.price1lab.hidden=NO;
//            cell.range2lab.hidden=NO;
//            cell.price2lab.hidden=NO;
//            cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
//            cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
//            cell.range2=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
//            cell.price2=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
//        }
//            break;
//        case 3:
//        {
//            cell.range1lab.hidden=NO;
//            cell.price1lab.hidden=NO;
//            cell.range2lab.hidden=NO;
//            cell.price2lab.hidden=NO;
//            cell.range3lab.hidden=NO;
//            cell.price3lab.hidden=NO;
//            cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
//            cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
//            cell.range2=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
//            cell.price2=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
//            cell.range3=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
//            cell.price3=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
//        }
//            break;
//        case 4:
//        {
//            cell.range1lab.hidden=NO;
//            cell.price1lab.hidden=NO;
//            cell.range2lab.hidden=NO;
//            cell.price2lab.hidden=NO;
//            cell.range3lab.hidden=NO;
//            cell.price3lab.hidden=NO;
//            cell.range4lab.hidden=NO;
//            cell.price4lab.hidden=NO;
//            cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
//            cell.range2=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
//            cell.range3=[NSString stringWithFormat:@"%@-%@",[array[2] stringForKey:@"minNum"],[array[2] stringForKey:@"maxNum"]];
//            cell.range4=[NSString stringWithFormat:@"%@-%@",[array[3] stringForKey:@"minNum"],[array[3] stringForKey:@"maxNum"]];
//            cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
//            cell.price2=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
//            cell.price3=[NSString stringWithFormat:@"¥%@",[array[2] stringForKey:@"price"]];
//            cell.price4=[NSString stringWithFormat:@"¥%@",[array[3] stringForKey:@"price"]];
//        }
//            break;
//        default:
//            break;
//    }
//    //到沙盒文件里去取数量
//    cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
//    cell.addBtn.tag=indexPath.row;
//    cell.minusBtn.tag=indexPath.row;
//    [cell.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.25;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"goodslist=%d",tablelist.count);
    
    if(pagenum<totalpage){
        pagenum++;
        NSLog(@"huadongdi %d",pagenum);
//        [self getTableListDataFromSever:pagenum];
    }
    
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

- (IBAction)carIconClicked:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}
@end
