//
//  newProductViewController.m
//  一心一田
//
//  Created by user on 16/3/22.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "newProductViewController.h"
#import "HomeTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "OrderConformationViewController.h"
@interface newProductViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    int pagenum;
    int totalpage;
    int previouscount;
}
@property (strong, nonatomic) NSMutableArray *productArr;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (strong, nonatomic)UIImageView *nodataImageView;
@property (weak, nonatomic) IBOutlet UILabel *numofgoodskindlab;
@property (weak, nonatomic) IBOutlet UILabel *summoneylab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UILabel *noticeLab;

@end

@implementation newProductViewController

- (NSMutableArray *)productArr{
    if (!_productArr) {
        _productArr = [NSMutableArray array];
    }
    return _productArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
   }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"新品";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"backpretty" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshgoodnum:) name:@"addorminusClick" object:nil];
    pagenum = 1;
     [self setbottombar];
    [self getProductDataFromSever:1];
    
}

-(void)refreshgoodnum:(NSNotification *)anote{
    NSArray *idsneedtorefresh=[[anote userInfo] arrayForKey:@"id"];
    for (int i=0; i<_productArr.count; i++) {
        HomeTableViewCell *cell=[_tabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if([idsneedtorefresh containsObject:cell.goodsid])
            cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
    }
    [self setbottombar];
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getProductDataFromSever:(int)pageno{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    paras[@"page_size"]=@10;
    paras[@"page_no"]=[NSString stringWithFormat:@"%d",pageno];
    paras[@"sortField"]=@"edit_time";
    [HttpTool post:@"get_goods_list" params:paras success:^(id responseObj) {
        if(self.productArr.count>0){
            previouscount=self.productArr.count;
            if([[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count]>0)
                [self.productArr addObjectsFromArray:[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]];
            //局部刷新
            NSMutableArray *indexs=[NSMutableArray array];
            for(int i=0;i<[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count];i++){
                NSIndexPath *index=[NSIndexPath indexPathForRow:previouscount+i inSection:0];
                [indexs addObject:index];
                //每次从线上请求新的数据都要和本地同步
                [LocalAndOnlineFileTool keepthesamewithonline:self.productArr];
            }
            [self.tabelView beginUpdates];
            [self.tabelView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tabelView endUpdates];
        }
        else
        {
            if([[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_list"] count]>0){
                self.tabelView.hidden=NO;
                
                self.productArr=[[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_list"] mutableCopy];
                //每次从线上请求新的数据都要喝本地同步
                [LocalAndOnlineFileTool keepthesamewithonline:self.productArr];
                NSLog(@"when next can come to here?");
                totalpage=[[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"page"] doubleForKey:@"total_page"];
                NSLog(@"总页数%d",totalpage);
                [self.tabelView reloadData];
            }
            else
            {
                //                self.tabelView.hidden=YES;
                if (!self.productArr.count) {
                    self.noticeLab.hidden = NO;
                }
        
            }
        }
    } failure:^(NSError *error) {
    } controler:self];
    

}

//2.每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MAIN_HEIGHT*0.2;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"goodslist=%ld",self.productArr.count);
    
    if(pagenum<totalpage&&indexPath.row==_productArr.count-1){
        pagenum++;
        [self getProductDataFromSever:pagenum];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell=[HomeTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    NSDictionary *good = self.productArr[indexPath.row];
    cell.goodsid=[good stringForKey:@"id"];
    cell.goodname = good[@"name"];
    cell.shortcomment = good[@"commentary"];
    cell.specific = good[@"specifications"];
    cell.goodimg = good[@"thumbnailImg"];
    cell.detailBtn.tag = indexPath.row;
    [cell.detailBtn addTarget:self action:@selector(goToDetailVC:)  forControlEvents:UIControlEventTouchUpInside];
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
    cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
    cell.addBtn.tag=indexPath.row;
    cell.minusBtn.tag=indexPath.row;
    [cell.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setbottombar{
    //设置种类
    _numofgoodskindlab.text=[NSString stringWithFormat:@"%d种商品",[LocalAndOnlineFileTool refreshkindnum:self.tabBarController]];
    //设置商品数量
    [_payBtn setTitle:[NSString stringWithFormat:@"去支付(%d)",[LocalAndOnlineFileTool refreshcoungnum]] forState:UIControlStateNormal];
    //设置参考价格
    _summoneylab.text=[NSString stringWithFormat:@"¥%.2f",[LocalAndOnlineFileTool calculatesummoneyinshopcar]];
}


-(void)addBtnClicked:(UIButton *)sender{
    HomeTableViewCell *cell=[self.tabelView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    cell.count=[NSString stringWithFormat:@"%d",i+1];
    [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i+1 tabbar:self.tabBarController];
     [self setbottombar];
    
}

-(void)minusBtnClicked:(UIButton *)sender{
    HomeTableViewCell *cell=[self.tabelView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
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
    NSDictionary *good = self.productArr[send.tag];
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

@end
