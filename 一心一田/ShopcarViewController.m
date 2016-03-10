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
//#import "OrderConformationViewController.h"

@interface ShopcarViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *tabledata;
    int previouscount;
    int quantity;
    double totaltopay;
    UIButton *rightBtn;
    UIView *v;
    int tableviewdidfinishloadcount;

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
    self.view.backgroundColor=[UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    tableviewdidfinishloadcount=0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addedtocarclicked) name:@"addedtocar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(piliangtijiaorefresh) name:@"piliangtijiao" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backtocartrefresh) name:@"backtocart" object:nil];
    self.navigationItem.title=@"购物车";
    rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [rightBtn setTitleColor:[UIColor colorWithRed:186.0/255 green:184.0/255 blue:184.0/255 alpha:1.0] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rightBtn.hidden=YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        [self initparas];
    [self getdatafromweb];
    
}

-(void)backtocartrefresh{
    [self getdatafromweb];
}
-(void)addedtocarclicked{
    [self getdatafromweb];
}

-(void)piliangtijiaorefresh{
    
    [self getdatafromweb];
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
 
}

-(void)getdatafromweb{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    paras[@"page_no"]=@"1";
    paras[@"page_size"]=@999999;
    NSLog(@"购物车参数 %@",paras);
    [HttpTool post:@"get_shopping_cart" params:paras success:^(id responseObj) {
        NSLog(@"购物车参数 %@ res=%@",paras,responseObj);
        if([responseObj int32ForKey:@"result"]==0){
            [refreshshoppingcarbadgenum refresh:self.tabBarController];
            //购物车没有商品
            if([[responseObj arrayForKey:@"data"] count]==0){
                _optionBar.hidden=YES;
                _shopcartableview.hidden=YES;
                
            }
            //购物车有商品
            else{
                rightBtn.hidden=NO;
                _emptynoticelab.hidden=YES;
                _shopcartableview.hidden=NO;
                _optionBar.hidden=NO;
            tabledata=[[responseObj arrayForKey:@"data"] mutableCopy];
                [_shopcartableview reloadData];
                [self settotalmoney];
        }
            
        }
    } failure:^(NSError *error) {
        
    }];
}



-(void)settotalmoney{
    _shopcartableview.editing=NO;
    _paybtn.enabled=YES;
    _paylabtext.backgroundColor=[UIColor redColor];
    totaltopay=0;
    quantity=0;
    if(tabledata.count==0)
        _chooseallBtn.selected=YES;
    else
    _chooseallBtn.selected=NO;
    for (int j=0; j<tabledata.count;++j)
    {
        ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:j]];
        cell.singleBtn.hidden=NO;
        cell.singleBtn.selected=NO;
//
        totaltopay+=[tabledata[j] int32ForKey:@"quantity"]*[tabledata[j] doubleForKey:@"salePrice"];
        
        NSLog(@"cell%d的 数量＝%d,salprice=%f totaltopay=%f",j,[cell.countlab.text intValue],[tabledata[j] doubleForKey:@"salePrice"],totaltopay);
        quantity+=[tabledata[j] int32ForKey:@"quantity"];
        
    }
    NSLog(@"最后的totaltopay=%d",totaltopay);
    _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
    _paylabtext.text=[NSString stringWithFormat:@"去支付(%d)",quantity];
  
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
    cell.image=[tabledata[indexPath.section] stringForKey:@"thumbnailImg"];
    cell.name=[tabledata[indexPath.section] stringForKey:@"goodsName"];
    cell.pricebefore=[NSString stringWithFormat:@"¥%.1f",[tabledata[indexPath.section] doubleForKey:@"salePrice"]];
    
    cell.originalprice=[NSString stringWithFormat:@"原价:¥%.1f",[tabledata[indexPath.section] doubleForKey:@"marketPrice"]];

    cell.currentprice=[NSString stringWithFormat:@"现价:¥%.1f",[tabledata[indexPath.section] doubleForKey:@"salePrice"]];
    cell.thecountchoosed=[NSString stringWithFormat:@"已选%@件商品",[tabledata[indexPath.section] stringForKey:@"quantity"]];
    cell.currentcount=[NSString stringWithFormat:@"%@",[tabledata[indexPath.section] stringForKey:@"quantity"]];
    if([tabledata[indexPath.section] int32ForKey:@"quantity"]==1){
        [cell.minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255  blue:163.0/255  alpha:1.0] forState:UIControlStateNormal];
        [cell.addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    if([tabledata[indexPath.section] int32ForKey:@"quantity"]>1){
        [cell.minusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    cell.acctuallypaid=[NSString stringWithFormat:@"实付:¥%.1f",[tabledata[indexPath.section] doubleForKey:@"salePrice"]*[tabledata[indexPath.section] int32ForKey:@"quantity"]];
    cell.minusBtn.tag=indexPath.section;
    cell.addBtn.tag=indexPath.section;
    cell.singleBtn.tag=indexPath.section;
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
        totaltopay=[_allmoneytopaylab.text doubleValue]-[cell.countlab.text intValue]*[tabledata[sender.tag] doubleForKey:@"salePrice"];
       _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
        quantity-=[cell.countlab.text intValue];
        if(quantity==0)
        {
            _paybtn.enabled=NO;
            _paylabtext.backgroundColor=[UIColor grayColor];

        }
       _paylabtext.text=[NSString stringWithFormat:@"去支付(%d)",quantity];

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
        totaltopay=[_allmoneytopaylab.text doubleValue]+[cell.countlab.text intValue]*[tabledata[sender.tag] doubleForKey:@"salePrice"];
        _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
        quantity+=[cell.countlab.text intValue];
        _paylabtext.text=[NSString stringWithFormat:@"去支付(%d)",quantity];

    }
    


}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)minusBtnClicked:(UIButton *)sender{
    ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    if(cell.singleBtn.selected)return;
    int i=[cell.countlab.text intValue];
    if(i>1){
        if(i==2)
            [cell.minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255  blue:163.0/255  alpha:1.0] forState:UIControlStateNormal];
        cell.countlab.text=[NSString stringWithFormat:@"%d",i-1];
        
        NSMutableDictionary *para=[NSMutableDictionary dictionary];
        
        para[@"goodsId"]=[tabledata[sender.tag] stringForKey:@"goodsId"];
        para[@"quantity"]=[NSString stringWithFormat:@"%d",i-1];
        para[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
        [HttpTool post:@"update_cart_goods_number" params:para success:^(id responseObj) {
            cell.thecountchoosed=[NSString stringWithFormat:@"已选%d件商品",i-1];
            
          cell.acctuallypaid=[NSString stringWithFormat:@"实付:¥%.1f",[tabledata[sender.tag] doubleForKey:@"salePrice"]*(i-1)];
            totaltopay-=[tabledata[sender.tag] doubleForKey:@"salePrice"];
            _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
            quantity--;
            _paylabtext.text=[NSString stringWithFormat:@"去支付(%d)",quantity] ;
            [refreshshoppingcarbadgenum refresh:self.tabBarController];
           
        } failure:^(NSError *error) {
            
        }];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(MAIN_HEIGHT==480)
        return MAIN_HEIGHT*0.37;
    else
    return  MAIN_HEIGHT*0.27;
}

-(void)addBtnClicked:(UIButton *)sender{
    ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    if(cell.singleBtn.selected)return;
    int i=[cell.countlab.text intValue];
    
        
        cell.countlab.text=[NSString stringWithFormat:@"%d",i+1];
        NSMutableDictionary *para=[NSMutableDictionary dictionary];
        
        para[@"goodsId"]=[tabledata[sender.tag] stringForKey:@"goodsId"];
        para[@"quantity"]=[NSString stringWithFormat:@"%d",i+1];
        para[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    
        [HttpTool post:@"update_cart_goods_number" params:para success:^(id responseObj) {
            cell.thecountchoosed=[NSString stringWithFormat:@"已选%d件商品",i+1];
            
            cell.acctuallypaid=[NSString stringWithFormat:@"实付:¥%.1f",[tabledata[sender.tag] doubleForKey:@"salePrice"]*(i+1)];
            totaltopay+=[tabledata[sender.tag] doubleForKey:@"salePrice"];
            _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
            quantity++;
            _paylabtext.text=[NSString stringWithFormat:@"去支付(%d)",quantity];
            [refreshshoppingcarbadgenum refresh:self.tabBarController];
            
        } failure:^(NSError *error) {
            
        }];
        
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)payBtnClicked:(id)sender {
    
//    OrderConformationViewController *vc=[[OrderConformationViewController alloc]init];
//    NSMutableArray *temp=[NSMutableArray array];
//    for (NSInteger j=0; j<[_shopcartableview numberOfSections];j++)
//    {
//        
//        ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:j]];
//        
//        if(!cell.singleBtn.selected){
//            NSMutableDictionary *dict=[tabledata[j] mutableCopy];
//            [dict setValue:cell.countlab.text forKey:@"quantity"];
//            [temp addObject:dict];
//        }
//        vc.tabledata=[temp mutableCopy];
//    
//    }
//    [self.navigationController pushViewController:vc animated:YES];
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
            _paylabtext.text=[NSString stringWithFormat:@"去支付(%d)",quantity];
        }
    }
    else{
        sender.selected=NO;
        _paybtn.enabled=YES;
        _paylabtext.backgroundColor=[UIColor redColor];
        quantity=0;
        totaltopay=0;
        NSLog(@"tabledata=%@",tabledata);
        for (NSInteger j=0; j<[_shopcartableview numberOfSections];j++)
        {
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:j]];
            cell.singleBtn.selected=NO;
            totaltopay+=[cell.countlab.text intValue]*[tabledata[j] doubleForKey:@"salePrice"];
                        quantity+=[cell.countlab.text intValue];

           
            _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
            _paylabtext.text=[NSString stringWithFormat:@"去支付(%d)",quantity];
            
        }
    }
}

- (IBAction)suredeletedBtnClicked:(UIButton *)sender {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    paras[@"cart_id"]=[tabledata[sender.tag] stringForKey:@"id"];
    [HttpTool post:@"delete_cart" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==0){
            ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
            if(!cell.singleBtn.selected){
            quantity-=[cell.countlab.text intValue];
            totaltopay-=[cell.countlab.text intValue]*[tabledata[sender.tag] doubleForKey:@"salePrice"];
                NSLog(@"当前cell的数量%d,价格=%f",[cell.countlab.text intValue],[tabledata[sender.tag] doubleForKey:@"salePrice"]);
            _allmoneytopaylab.text=[NSString stringWithFormat:@"¥%.2f",totaltopay];
            _paylabtext.text=[NSString stringWithFormat:@"去支付(%d)",quantity];
            }
            
            [tabledata removeObjectAtIndex:sender.tag];
            if(tabledata.count==0){
                rightBtn.hidden=YES;
                _emptynoticelab.hidden=NO;
                [_shopcartableview setEditing:NO];
                _optionBar.hidden=YES;
                _chooseallBtn.selected=YES;}
            [_shopcartableview deleteSections:[NSIndexSet indexSetWithIndex:sender.tag]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            rightBtn.selected=NO;
            _shopcartableview.editing=NO;
            for(int i=0;i<tabledata.count;i++){
                ShoppingCarTableViewCell *cell=[_shopcartableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
                cell.singleBtn.hidden=NO;
                
            }
            
            [v removeFromSuperview];
            
       //刷新购物车badgenum
            [refreshshoppingcarbadgenum refresh:self.tabBarController];
            
            
        }
    } failure:^(NSError *error) {
        NSLog(@"购物车删除失败 %@",error);
    }];
    

}



- (IBAction)canceldeleteBtnClicked:(UIButton *)sender {
    [_shopcartableview reloadData];
    [v removeFromSuperview];
}
@end
