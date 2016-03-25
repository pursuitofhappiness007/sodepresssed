//
//  SearchResultsViewController.m
//  kitchen
//
//  Created by xipin on 15/12/16.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "GoodLIstTableViewCell.h"
#import "GoodsDetailViewController.h"

@interface SearchResultsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *goodslist;
    int pagenum;
    int previouscount;
    UIView *v;
    UITableView *table;
    UIView *pricechooserview;
   
    NSString *minprice;
    NSString *maxprice;
    NSString *sortorder;
    NSString *sortfield;
    UIView *filterv;
    UIButton *selectedBtn;
    
   
}
- (IBAction)tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *minpricetf;
@property (weak, nonatomic) IBOutlet UITextField *maxpricetf;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)filterBtnClicked:(id)sender;
- (IBAction)resetBtnClicked:(id)sender;
- (IBAction)priceareasureBtnClicked:(id)sender;

- (IBAction)lastestBtnClicked:(id)sender;

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
@property (weak, nonatomic) IBOutlet UIView *redline;


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
    _zongheBtn.selected=YES;
    selectedBtn=_zongheBtn;
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
        GoodListTableViewCell *cell=[GoodListTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
        NSDictionary *dict=goodslist[indexPath.row];
        NSLog(@"dict==%@",dict);
        cell.goodsid=[dict stringForKey:@"goodsId"];
        cell.price=[dict stringForKey:@"price"];
        cell.goodimg=[dict stringForKey:@"thumbnailImg"];
        cell.goodname=[dict stringForKey:@"name"];
        cell.specific=[dict stringForKey:@"specifications"];
        cell.counthasbeensaled=[NSString stringWithFormat:@"本市场今日已销售%@瓶",[dict stringForKey:@"dailySales"]];
        cell.shortcomment=[dict stringForKey:@"commentary"];
        NSArray *array=[dict arrayForKey:@"goodsRangePrice"];
        switch (array.count) {
            case 0:
            {
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
    
        cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
        cell.minusBtn.tag=indexPath.row;
        cell.addBtn.tag=indexPath.row;
        [cell.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    
}
-(void)addBtnClicked:(UIButton *)sender{
    GoodListTableViewCell *cell=[table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    cell.count=[NSString stringWithFormat:@"%d",i+1];
    [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i+1 tabbar:self.tabBarController];
}
-(void)minusBtnClicked:(UIButton *)sender{
    GoodListTableViewCell *cell=[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    if(i>0){
        if(i==1)
            [cell.minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255  blue:163.0/255  alpha:1.0] forState:UIControlStateNormal];
        cell.count=[NSString stringWithFormat:@"%d",i-1];
        
        [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i-1 tabbar:self.tabBarController];
        
        
    }
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
    [self.view addSubview:table];
    }


-(void)getdatafromweb:(int)page_no keywords:(NSString *)keywords minprice:(NSString *)minprice maxprice:(NSString *)maxprice sortorder:(NSString *)order sortfield:(NSString *)sortfield{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    
    paras[@"page_no"]=[NSString stringWithFormat:@"%d",page_no];
    paras[@"goodsName"]=_keywords;
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    paras[@"minSalePrice"]=minprice;
    paras[@"maxSalePrice"]=maxprice;
    paras[@"sortOrder"]=sortorder;
    paras[@"sortField"]=sortfield;
    [HttpTool post:@"get_goods_list" params:paras success:^(id responseObj) {
        NSLog(@"搜索的到的json %@ 参数=%@",responseObj,paras);
        if(goodslist.count>0){
            previouscount=goodslist.count;
            if([[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]count]>0)
            [goodslist addObjectsFromArray:[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]];
          
            NSMutableArray *indexs=[NSMutableArray array];
            for(int i=0;i<[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count];i++){
                NSIndexPath *index=[NSIndexPath indexPathForRow:previouscount+i inSection:0];
                [indexs addObject:index];
            }
          
            [table beginUpdates];
            [table insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationAutomatic];
            [table endUpdates];
            
            
            
        }
        else{
        
            if([[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]count]>0)
            goodslist=[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] mutableCopy];
            NSLog(@"没有扶植成功吗=%@",goodslist);
            [table reloadData];
        }
      
        
        
    } failure:^(NSError *error) {
        NSLog(@"获得促销失败%@",error);
    } controler:self];
}

-(void)initparas{
    minprice=nil;
    maxprice=nil;
    sortorder=nil;
    sortfield=@"sort";
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
       return NO;
    else
        return YES;
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
//最新
- (IBAction)lastestBtnClicked:(UIButton *)sender {
    [self removepricechooser:nil];
    CGPoint temp=_redline.center;
    temp.x=sender.center.x;
    _redline.center=temp;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [goodslist removeAllObjects];
    pagenum=1;
    sortorder=nil;
    sortfield=@"edit_time";
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];

}

- (IBAction)priceBtnClicked:(UIButton *)sender {
    pricechooserview=[[[NSBundle mainBundle]loadNibNamed:@"pricechooser" owner:self options:nil]firstObject];
    pricechooserview.frame=CGRectMake(0, _titileview.y+_titileview.height, MAIN_WIDTH, MAIN_HEIGHT-pricechooserview.y-49);
    [self.view addSubview:pricechooserview];
    CGPoint temp=_redline.center;
    temp.x=sender.center.x;
    _redline.center=temp;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
}
//价格从低到高
- (IBAction)shenxuBtnClicked:(id)sender {
    [self removepricechooser:nil];
    pagenum=1;
    sortorder=@"asc";
    sortfield=@"price";
    [_zongheBtn setTitle:@"从低到高" forState:UIControlStateSelected];
    _lowtohighlab.textColor=[UIColor redColor];
    _hightolowlab.textColor=[UIColor blackColor];
    [goodslist removeAllObjects];
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}
//价格从高到低
- (IBAction)jiangxuBtnClicked:(id)sender {
    [self removepricechooser:nil];
    pagenum=1;
    sortorder=@"desc";
    sortfield=@"price";
    [_zongheBtn setTitle:@"从高到低" forState:UIControlStateSelected];
    _lowtohighlab.textColor=[UIColor blackColor];
    _hightolowlab.textColor=[UIColor redColor];
    [goodslist removeAllObjects];
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}
- (IBAction)removepricechooser:(id)sender {
    [pricechooserview removeFromSuperview];
}
//销量优先
- (IBAction)amountpirorityBtnClicked:(UIButton *)sender {
    [self removepricechooser:nil];
    CGPoint temp=_redline.center;
    temp.x=sender.center.x;
    _redline.center=temp;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
   [goodslist removeAllObjects];
    pagenum=1;
    sortorder=@"desc";
    sortfield=@"daily_sales";
    _pricelab.text=@"价格";
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}
//综合排序
- (IBAction)zongheBtnClicked:(UIButton *)sender {
    [self removepricechooser:nil];
    CGPoint temp=_redline.center;
    temp.x=sender.center.x;
    _redline.center=temp;
    if(sender.selected)
        sender.selected=NO;
    else
    {   sender.selected=YES;
        selectedBtn.selected=NO;
        selectedBtn=sender;
    }
    [goodslist removeAllObjects];
    pagenum=1;
    sortorder=nil;
    sortfield=@"sort";
    [self getdatafromweb:1 keywords:_keywords minprice:minprice maxprice:maxprice sortorder:sortorder sortfield:sortfield];
}
- (IBAction)tapped:(id)sender {
    [filterv removeFromSuperview];
}
@end
