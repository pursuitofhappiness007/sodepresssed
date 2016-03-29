//
//  ShopcarViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/13.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "ShopcarViewController.h"
#import "ShoppingCarTableViewCell.h"
//#import "GoodsDetailViewController.h"
#import "OrderConformationViewController.h"

@interface ShopcarViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *tabledata;
    int previouscount;
    int quantity;
    double totaltopay;
    UIButton *rightBtn;
    UIView *v;
    int tableviewdidfinishloadcount;
    BOOL needrefresh;
}
@property (weak, nonatomic) IBOutlet UITableView *shopcartableview;
@property (weak, nonatomic) IBOutlet UILabel *allmoneytopaylab;
@property (weak, nonatomic) IBOutlet UILabel *paylabtext;
- (IBAction)payBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chooseallBtn;
@property (weak, nonatomic) IBOutlet UIView *optionBar;
- (IBAction)chooseallBtnClicked:(id)sender;

- (IBAction)suredeletedBtnClicked:(id)sender;
- (IBAction)canceldeleteBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *suredeleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *emptynoticelab;
@property (weak, nonatomic) IBOutlet UIButton *paybtn;
@property (weak, nonatomic) IBOutlet UIButton *canceldeleteBtn;

@end

@implementation ShopcarViewController

-(void)viewWillAppear:(BOOL)animated{
    _shopcartableview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tabBarController.tabBar.hidden=NO;
    [LocalAndOnlineFileTool refreshkindnum:self.tabBarController];
}

-(void)viewWillDisappear:(BOOL)animated{
        [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        rightBtn.selected=NO;
    rightBtn.hidden=NO;
        _shopcartableview.editing=NO;
    needrefresh=YES;
        for(int i=0;i<[_shopcartableview numberOfSections];i++){
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            cell.singleBtn.hidden=NO;
            
        }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshgoodnum:) name:@"addorminusClick" object:nil];
    needrefresh=YES;
    [self initparas];
    [self setnavbar];
    [self setbottombar];
}

-(void)refreshgoodnum:(NSNotification *)anote{
    if (needrefresh) {
        [self initparas];
    }
    
    NSArray *idsneedtorefresh=[[anote userInfo] arrayForKey:@"id"];
    for (int i=0; i<[_shopcartableview numberOfSections]; i++) {
        ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        if([idsneedtorefresh containsObject:cell.goodsid])
            cell.countlab.text=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
    }
    [self setbottombar];
}

-(void)setnavbar{
    self.navigationItem.title=@"购物车";
    rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [rightBtn setTitleColor:[UIColor colorWithRed:107.0/255 green:103.0/255 blue:103.0/255 alpha:1.0] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

-(void)setbottombar{
    quantity=0;
    totaltopay=0;
    for (int i=0; i<[_shopcartableview numberOfSections]; i++) {
        ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        if(!cell.singleBtn.selected)
        {
            quantity+=[cell.countlab.text intValue];
            totaltopay+=cell.singleprice*[cell.countlab.text intValue];
        }
    }
    _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
    
    [_paybtn setTitle:[NSString stringWithFormat:@"去支付(%d)",quantity] forState:UIControlStateNormal];
    [LocalAndOnlineFileTool refreshkindnum:self.tabBarController];
}

-(void)backBtnClicked{
    
    if(self.tabBarController.selectedIndex==2){
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView =[[self.tabBarController.viewControllers objectAtIndex:0] view];
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(0>self.tabBarController.selectedIndex? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        if (finished) {
                            [self.tabBarController setSelectedIndex:0];
                            self.tabBarController.tabBar.hidden=NO;
                        }
                    }];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden=NO;
}

-(void)editBtnClicked:(UIButton *)sender{
    if(!sender.selected){
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        sender.selected=YES;
        _shopcartableview.editing=YES;
        for(int i=0;i<[_shopcartableview numberOfSections];i++){
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            cell.singleBtn.hidden=YES;
            
        }
    }
    else{
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        sender.selected=NO;
     _shopcartableview.editing=NO;
        for(int i=0;i<[_shopcartableview numberOfSections];i++){
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            cell.singleBtn.hidden=NO;
            
        }
    }
    
    
    
}

-(void)initparas{
    
    tabledata=[NSMutableArray array];
   
    tabledata=[[LocalAndOnlineFileTool getbuyinggoodslist]mutableCopy];
    
    if(tabledata.count==0){
        _emptynoticelab.hidden=NO;
        _optionBar.hidden=YES;
    _shopcartableview.hidden=YES;
    }
    else{
        _emptynoticelab.hidden=YES;
        rightBtn.hidden=NO;
        _optionBar.hidden=NO;
        _shopcartableview.hidden=NO;
        [self setbottombar];
        [_shopcartableview reloadData];
    
    }

 
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return tabledata.count;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
      v=[[[NSBundle mainBundle]loadNibNamed:@"deleteview" owner:self options:nil]firstObject];
        v.frame=self.view.bounds;
        [self.view addSubview:v];
        _suredeleteBtn.tag=indexPath.section;
        _canceldeleteBtn.tag=indexPath.section;
        ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
        
        NSLog(@"将要删除的cell的index=%d 商品的数量=%d",indexPath.section,[cell.countlab.text intValue]);
       
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    ShoppingCarTableViewCell *cell=[ShoppingCarTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dict=tabledata[indexPath.section];
    
    cell.goodsid=[dict stringForKey:@"id"];
    cell.image=[dict stringForKey:@"thumbnailImg"];
    cell.name=[dict stringForKey:@"name"];
    int kcount=[LocalAndOnlineFileTool singlegoodcount:cell.goodsid];
    cell.thecountchoosed=[NSString stringWithFormat:@"已选%d件商品",kcount];
    
    cell.currentcount=[NSString stringWithFormat:@"%d",kcount];
    cell.shortcomment=[dict stringForKey:@"commentary"];
    cell.singleprice=[LocalAndOnlineFileTool singlegoodprice:cell.goodsid];
    cell.shouldpaid=[NSString stringWithFormat:@"应付:¥%.2f", cell.singleprice*kcount];
    cell.minusBtn.tag=indexPath.section;
    cell.addBtn.tag=indexPath.section;
    cell.singleBtn.tag=indexPath.section;
    cell.singleBtn.selected=NO;
    cell.goodspicBtn.tag=indexPath.section;
    [cell.goodspicBtn addTarget:self action:@selector(goodspicBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.singleBtn addTarget:self action:@selector(singleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



-(void)goodspicBtnClicked:(UIButton *)sender{
//    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
//    vc.goodsid=[tabledata[sender.tag] stringForKey:@"goodsId"];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)singleBtnClicked:(UIButton *)sender{
    if(!sender.selected){
        sender.selected=YES;
        _chooseallBtn.selected=YES;
        ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
        
        _allmoneytopaylab.text=[_allmoneytopaylab.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        totaltopay=[_allmoneytopaylab.text doubleValue]-[cell.countlab.text intValue]*cell.singleprice;
       _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
        quantity-=[cell.countlab.text intValue];
        if(quantity==0)
        {
            _paybtn.enabled=NO;
            _paylabtext.backgroundColor=[UIColor grayColor];

        }
        [_paybtn setTitle:[NSString stringWithFormat:@"去支付(%d)",quantity] forState:UIControlStateNormal];

    }
    else{
        
        sender.selected=NO;
        _paybtn.enabled=YES;
        _paylabtext.backgroundColor=[UIColor redColor];
        

        for (NSInteger j=0; j<[_shopcartableview numberOfSections];j++)
        {
            
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:j]];
            
            if(!cell.singleBtn.selected){
                NSLog(@"yekongzhong %d",j);
                if(j==[_shopcartableview numberOfSections]-1){
                    _chooseallBtn.selected=NO;
                    _paybtn.enabled=YES;
                    _paylabtext.backgroundColor=[UIColor redColor];

                    break;
                }
                continue;
            }
            else{
                _chooseallBtn.selected=YES;
                break;
            }
            
        }
        
        ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
        _allmoneytopaylab.text=[_allmoneytopaylab.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        totaltopay=[_allmoneytopaylab.text doubleValue]+[cell.countlab.text intValue]*cell.singleprice;
        _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
        quantity+=[cell.countlab.text intValue];
        
       [_paybtn setTitle:[NSString stringWithFormat:@"去支付(%d)",quantity] forState:UIControlStateNormal];

    }
    


}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)minusBtnClicked:(UIButton *)sender{
    NSLog(@"点了见好 cell=%d",sender.tag);
    needrefresh=NO;
    ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    if(cell.singleBtn.selected)return;
    
    int i=[cell.countlab.text intValue];
    if(i>0){
        cell.currentcount=[NSString stringWithFormat:@"%d",i-1];
        if(i==1){
            cell.singleBtn.hidden=NO;
            [tabledata removeObjectAtIndex:sender.tag];
            [_shopcartableview beginUpdates];
            [_shopcartableview deleteSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
          
            [_shopcartableview endUpdates];
            NSInteger sectionCount = [tabledata count];
            NSIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionCount)];
            [_shopcartableview reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];
            if(tabledata.count==0){
                rightBtn.hidden=YES;
                _emptynoticelab.hidden=NO;
                [_shopcartableview setEditing:NO];
                _optionBar.hidden=YES;
                _chooseallBtn.selected=NO;
            }
           
            

        }
        
        [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i-1 tabbar:self.tabBarController];
        [self setbottombar];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(MAIN_HEIGHT==480)
        return MAIN_HEIGHT*0.39;
    else
    return  MAIN_HEIGHT*0.22;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 5)];
    v.backgroundColor=[UIColor groupTableViewBackgroundColor];
    return v;
}

-(void)addBtnClicked:(UIButton *)sender{
    needrefresh=NO;
    ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    if(cell.singleBtn.selected)return;
    int i=[cell.countlab.text intValue];
    cell.currentcount=[NSString stringWithFormat:@"%d",i+1];
    [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i+1 tabbar:self.tabBarController];
    [self setbottombar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)payBtnClicked:(id)sender {
    OrderConformationViewController *vc=[[OrderConformationViewController alloc]init];
    NSMutableArray *temp=[NSMutableArray array];
    for (NSInteger j=0; j<[_shopcartableview numberOfSections];j++)
    {
    ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:j]];
        
        if(!cell.singleBtn.selected)
            [temp addObject:tabledata[j]];
    }
    vc.tabledata=[temp mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)chooseallBtnClicked:(UIButton *)sender {
    if(!sender.selected){
        sender.selected=YES;
        totaltopay=0;
        quantity=0;
        for (NSInteger j=0; j<[_shopcartableview numberOfSections];j++)
        {
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:j]];
            cell.singleBtn.selected=YES;
            
            _paybtn.enabled=NO;
            _paylabtext.backgroundColor=[UIColor grayColor];
    _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
            [_paybtn setTitle:[NSString stringWithFormat:@"去支付(%d)",quantity] forState:UIControlStateNormal];
        }
    }
    else{
        sender.selected=NO;
        _paybtn.enabled=YES;
        for (int i=0; i<tabledata.count; i++) {
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            cell.singleBtn.selected=NO;
        }
        
        _paylabtext.backgroundColor=[UIColor redColor];
        totaltopay=[LocalAndOnlineFileTool calculatesummoneyinshopcar];
        quantity=[LocalAndOnlineFileTool refreshcoungnum];
        NSLog(@"tabledata=%@",tabledata);
        _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
        [_paybtn setTitle:[NSString stringWithFormat:@"去支付(%d)",quantity] forState:UIControlStateNormal];
    }
}

- (IBAction)suredeletedBtnClicked:(UIButton *)sender {
        ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
        [tabledata removeObjectAtIndex:sender.tag];
    cell.singleBtn.hidden=NO;
        if(tabledata.count==0){
            rightBtn.hidden=YES;
            _emptynoticelab.hidden=NO;
            [_shopcartableview setEditing:NO];
            _optionBar.hidden=YES;
            _chooseallBtn.selected=NO;
        }
    [_shopcartableview beginUpdates];
        [_shopcartableview deleteSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
       [_shopcartableview endUpdates];
    NSInteger sectionCount = [tabledata count];
    NSIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionCount)];
    [_shopcartableview reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];

    [LocalAndOnlineFileTool resetaftersuccessfulsubmit:@[cell.goodsid]];
    [self setbottombar];
        [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        rightBtn.selected=NO;
        _shopcartableview.editing=NO;
        for(int i=0;i<tabledata.count;i++){
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            cell.singleBtn.hidden=NO;
            
        }
        
        [v removeFromSuperview];
        //刷新购物车种类
        [LocalAndOnlineFileTool refreshkindnum:self.tabBarController];
        
    
}



- (IBAction)canceldeleteBtnClicked:(UIButton *)sender {
    [_shopcartableview reloadData];
    [v removeFromSuperview];
}
@end
