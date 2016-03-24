//
//  UsuallyBuyViewController.m
//  一心一田
//
//  Created by xipin on 16/3/22.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "UsuallyBuyViewController.h"
#import "HomeTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "OrderConformationViewController.h"
@interface UsuallyBuyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tablelist;
    int pagenum;
    int previouscount;
    int totalpage;
}
//点击底部购物车小按钮
- (IBAction)carIconClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *numofgoodskindlab;
@property (weak, nonatomic) IBOutlet UILabel *summoneylab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshgoodnum) name:@"addorminusClick" object:nil];

    [self initparas];
    [self getdataformweb:1];
    [self setbottombar];
}
-(void)refreshgoodnum:(NSNotification *)anote{
    NSArray *idsneedtorefresh=[[anote userInfo] arrayForKey:@"id"];
    for (int i=0; i<tablelist.count; i++) {
        HomeTableViewCell *cell=[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if([idsneedtorefresh containsObject:cell.goodsid])
            cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
    }
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
    //设置种类
    _numofgoodskindlab.text=[NSString stringWithFormat:@"%d种商品",[LocalAndOnlineFileTool refreshkindnum:self.tabBarController]];
    //设置商品数量
    [_payBtn setTitle:[NSString stringWithFormat:@"去支付(%d)",[LocalAndOnlineFileTool refreshcoungnum]] forState:UIControlStateNormal];
    //设置参考价格
    _summoneylab.text=[NSString stringWithFormat:@"¥%.2f",[LocalAndOnlineFileTool calculatesummoneyinshopcar]];
}
-(void)getdataformweb:(int)pageno{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    paras[@"page_size"]=@10;
    paras[@"page_no"]=[NSString stringWithFormat:@"%d",pageno];
    [HttpTool post:@"query_always_buy_goods" params:paras success:^(id responseObj) {
        NSLog(@"wwwwwwwwww%@", responseObj);
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
        NSLog(@"hhhhhhhhhhh%@",error);
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tablelist.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell=[HomeTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    NSDictionary *good = tablelist[indexPath.row];
    cell.goodsid=[good stringForKey:@"id"];
    cell.goodname = good[@"name"];
    cell.shortcomment = good[@"commentary"];
    cell.specific = good[@"specifications"];
    cell.goodimg = [good stringForKey:@"thumbnailImg"];
    cell.detailBtn.tag = indexPath.row;
    [cell.detailBtn addTarget:self action:@selector(goToDetailVC:)  forControlEvents:UIControlEventTouchUpInside];
    NSArray *array=[good arrayForKey:@"goodsRangePrices"];
    switch (array.count) {
        case 0:
        {
            cell.price1lab.hidden = NO;
            cell.price1lab.text = [NSString stringWithFormat:@"¥%@", [good stringForKey:@"price"]];
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
    cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
    cell.addBtn.tag=indexPath.row;
    cell.minusBtn.tag=indexPath.row;
    [cell.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.25;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"goodslist=%lu",(unsigned long)tablelist.count);
    
    if(pagenum<totalpage){
        pagenum++;
        NSLog(@"huadongdi %d",pagenum);
       [self getdataformweb:pagenum];
     }
}



-(void)addBtnClicked:(UIButton *)sender{
    HomeTableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    cell.count=[NSString stringWithFormat:@"%d",i+1];
    [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i+1 tabbar:self.tabBarController];
    [self setbottombar];
    
}

-(void)minusBtnClicked:(UIButton *)sender{
    HomeTableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    if(i>0){
        if(i==1)
            [cell.minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255  blue:163.0/255  alpha:1.0] forState:UIControlStateNormal];
        cell.count=[NSString stringWithFormat:@"%d",i-1];
        [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i-1 tabbar:self.tabBarController];
        [self setbottombar];
    }
}


- (void)goToDetailVC:(UIButton *)send{
    NSDictionary *good = tablelist[send.tag];
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc]init];
    detailVC.goodsid = good[@"goodsId"];
    detailVC.supplierid = good[@"supplierId"];
    detailVC.marketid = good[@"marketId"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)carClicked:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

- (IBAction)payBtnClicked:(id)sender {
    OrderConformationViewController *vc=[[OrderConformationViewController alloc]init];
    vc.tabledata=[[LocalAndOnlineFileTool getbuyinggoodslist] mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
    
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
