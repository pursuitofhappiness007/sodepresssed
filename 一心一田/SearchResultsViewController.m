//
//  SearchResultsViewController.m
//  kitchen
//
//  Created by xipin on 15/12/16.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "HomeTableViewCell.h"
#import "GoodsDetailViewController.h"

@interface SearchResultsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *goodslist;
    int pagenum;
    int previouscount;
    UICollectionView *cv;
    UIView *v;
    UITableView *table;
    UIView *pricechooserview;
   
    NSString *minprice;
    NSString *maxprice;
    NSString *sortorder;
    NSString *sortfield;
    UIView *filterv;
    
   
}
- (IBAction)tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *minpricetf;
@property (weak, nonatomic) IBOutlet UITextField *maxpricetf;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)filterBtnClicked:(id)sender;

- (IBAction)tubiaoClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tubiaoBtn;
- (IBAction)resetBtnClicked:(id)sender;
- (IBAction)priceareasureBtnClicked:(id)sender;


- (IBAction)priceBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;
- (IBAction)shenxuBtnClicked:(id)sender;
- (IBAction)jiangxuBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lowtohighlab;
@property (weak, nonatomic) IBOutlet UILabel *hightolowlab;
@property (weak, nonatomic) IBOutlet UIView *titileview;
- (IBAction)removepricechooser:(id)sender;
- (IBAction)amountpirorityBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *zongheBtn;
- (IBAction)zongheBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *amountpriorityBtn;


@end

@implementation SearchResultsViewController
-(instancetype)init{
    if(self=[super init]){
        self.automaticallyAdjustsScrollViewInsets=NO;
       
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    v=[[[NSBundle mainBundle]loadNibNamed:@"titileaftersearch" owner:self options:nil] firstObject];
    v.frame=CGRectMake(0, StatusBarH, MAIN_WIDTH, NaviBarH);
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
    [self.view addSubview:v];

    [self initparas];
    [self creattableview];
    [self getdatafromweb:1 keywords:_keywords minprice:nil maxprice:nil sortorder:nil sortfield:nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return goodslist.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell=[HomeTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
}

-(void)showgoodsdetail:(UIButton *)sender{
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    vc.goodsid=[goodslist[sender.tag] stringForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==goodslist.count-1){
        pagenum++;
        [self getdatafromweb:pagenum keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
    }}

-(void)creattableview{
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 108, MAIN_WIDTH, MAIN_HEIGHT-108-49) style:UITableViewStylePlain];
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    table.dataSource=self;
    table.delegate = self;
    }


-(void)getdatafromweb:(int)page_no keywords:(NSString *)keywords minprice:(NSString *)minprice maxprice:(NSString *)maxprice sortorder:(NSString *)order sortfield:(NSString *)sortfield{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    
    paras[@"page_no"]=[NSString stringWithFormat:@"%d",page_no];
    paras[@"keyword"]=_keywords;
    paras[@"minSalePrice"]=minprice;
    paras[@"maxSalePrice"]=maxprice;
    paras[@"sortOrder"]=sortorder;
    paras[@"sortField"]=sortfield;
    [HttpTool post:@"get_goods_list" params:paras success:^(id responseObj) {
        NSLog(@"搜索的到的json %@",responseObj);
        if(goodslist.count>0){
            previouscount=goodslist.count;
            if([[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]!=nil)
            [goodslist addObjectsFromArray:[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]];
            NSMutableArray *indexs=[NSMutableArray array];
            for(int i=0;i<[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count];i++){
                NSIndexPath *index=[NSIndexPath indexPathForRow:previouscount+i inSection:0];
                [indexs addObject:index];
            }
           
            [cv performBatchUpdates:^{
                [cv insertItemsAtIndexPaths:indexs];
            } completion:^(BOOL finished) {
                
            }];
         
            [table beginUpdates];
            [table insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationAutomatic];
            [table endUpdates];
            
            
            
        }
        else{
        
            if([[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]!=nil)
            goodslist=[[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_list"] mutableCopy];
            [cv reloadData];
            [table reloadData];
        }
      
        
        
    } failure:^(NSError *error) {
        NSLog(@"获得促销失败%@",error);
    }];
}

-(void)initparas{
    minprice=nil;
    maxprice=nil;
    sortorder=nil;
    sortfield=nil;
    goodslist=[NSMutableArray array];
    pagenum=1;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return MAIN_HEIGHT*0.21;
}

- (IBAction)backBtnClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backtofirstsearch" object:nil];
    [v removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self backBtnClicked:nil];
    return NO;
}



- (IBAction)filterBtnClicked:(UIButton *)sender {
    
    filterv=[[[NSBundle mainBundle]loadNibNamed:@"filterwindow" owner:self options:nil]firstObject];
    filterv.frame=CGRectMake(0, StatusBarH+NaviBarH, MAIN_WIDTH, MAIN_HEIGHT-StatusBarH-NaviBarH-49);
    [self.view addSubview:filterv];
    


    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
   if(touch.view.tag==88)
       return YES;
    else
        return NO;
}

- (IBAction)tubiaoClicked:(UIButton *)sender {
    NSLog(@"点了没有");
    if(!sender.selected){
        NSLog(@"是图标点了");
        [self.view addSubview:table];
        table.delegate=self;
        table.dataSource=self;
        sender.selected=YES;
    }
    
    else{
        NSLog(@"不是图标点了");
        [table removeFromSuperview];
        sender.selected=NO;
    }
}


- (IBAction)resetBtnClicked:(id)sender {
    _minpricetf.text=nil;
    _maxpricetf.text=nil;
}

- (IBAction)priceareasureBtnClicked:(id)sender {
    [filterv removeFromSuperview];
    if(_maxpricetf.text.length==0||_minpricetf.text.length==0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText =@"价格输入有误";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.0];
        return ;
    
    }
       pagenum=1;
    minprice=_minpricetf.text;
    maxprice=_maxpricetf.text;
        [goodslist removeAllObjects];
        [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}

- (IBAction)priceBtnClicked:(id)sender {
    pricechooserview=[[[NSBundle mainBundle]loadNibNamed:@"pricechooser" owner:self options:nil]firstObject];
    pricechooserview.frame=CGRectMake(0, _titileview.y+_titileview.height, MAIN_WIDTH, MAIN_HEIGHT-pricechooserview.y-49);
    [self.view addSubview:pricechooserview];
    _amountpriorityBtn.titleLabel.textColor=[UIColor blackColor];
    _zongheBtn.titleLabel.textColor=[UIColor blackColor];
}
- (IBAction)shenxuBtnClicked:(id)sender {
    [pricechooserview removeFromSuperview];
    pagenum=1;
    sortorder=@"asc";
    sortfield=@"sale_price";
    _pricelab.text=@"价格从低到高";
    _pricelab.textColor=[UIColor redColor];
    _lowtohighlab.textColor=[UIColor redColor];
    _hightolowlab.textColor=[UIColor blackColor];
    [goodslist removeAllObjects];
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}

- (IBAction)jiangxuBtnClicked:(id)sender {
    [pricechooserview removeFromSuperview];
    pagenum=1;
    sortorder=@"desc";
    sortfield=@"sale_price";
    _pricelab.text=@"价格从高到低";
    _pricelab.textColor=[UIColor redColor];
    _lowtohighlab.textColor=[UIColor blackColor];
    _hightolowlab.textColor=[UIColor redColor];
    [goodslist removeAllObjects];
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}
- (IBAction)removepricechooser:(id)sender {
    [pricechooserview removeFromSuperview];
}

- (IBAction)amountpirorityBtnClicked:(UIButton *)sender {
    [pricechooserview removeFromSuperview];
    pagenum=1;
    sortorder=@"asc";
    sortfield=@"sales_count";
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _pricelab.textColor=[UIColor blackColor];
    _pricelab.text=@"价格";
    _lowtohighlab.textColor=[UIColor blackColor];
    _hightolowlab.textColor=[UIColor blackColor];
    _lowtohighlab.textColor=[UIColor blackColor];
    _hightolowlab.textColor=[UIColor redColor];
    _zongheBtn.titleLabel.textColor=[UIColor blackColor];
    
    [goodslist removeAllObjects];
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}
- (IBAction)zongheBtnClicked:(UIButton *)sender {
    [pricechooserview removeFromSuperview];
    pagenum=1;
    sortorder=nil;
    sortfield=nil;
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _amountpriorityBtn.titleLabel.textColor=[UIColor blackColor];
    _pricelab.textColor=[UIColor blackColor];
    _pricelab.text=@"价格";
    _lowtohighlab.textColor=[UIColor blackColor];
    _hightolowlab.textColor=[UIColor blackColor];
    [goodslist removeAllObjects];
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}
- (IBAction)tapped:(id)sender {
    [filterv removeFromSuperview];
}
@end
