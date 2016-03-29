//
//  ClassficationViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/8.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "ClassficationViewController.h"
#import "GoodListTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "LoginViewController.h"
#import "SearchResultsViewController.h"
#import "ShopcarViewController.h"
#import "OrderConformationViewController.h"
#import "SubtitleTableViewCell.h"
@interface ClassficationViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *goodslist;
    NSMutableArray *goodstitles;
    int pagenum;
    NSMutableArray *mainclassfication;
    NSString *mainpid;
    NSString *subpid;
    NSMutableArray *subclassfication;
    NSString *goodsname;
    NSString *sorttype;
    NSString *sortfield;
    int previouscount;
    SubtitleTableViewCell *basedcell;
    int totalpage;
    UIView *redline;
    UIView *firstmenu;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightconstraint;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)searchIconClicked:(id)sender;
- (IBAction)showMenuBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *menuArrow;
@property (weak, nonatomic) IBOutlet UITableView *titletableview;
@property (weak, nonatomic) IBOutlet UITableView *fenleitableview;
@property (weak, nonatomic) IBOutlet UILabel *maintitilelab;
- (IBAction)singletapofmask:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numofgoodskindlab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)PayBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *summoneylab;
@property (strong, nonatomic) IBOutlet UITableView *firstclassmenutableview;
//一级菜单按钮
@property (weak, nonatomic) IBOutlet UIButton *showMenuBtn;

//点击了底部购物车小图标
- (IBAction)carIconClicked:(id)sender;

@end

@implementation ClassficationViewController

-(instancetype)init{
   if(self=[super init])
       self.automaticallyAdjustsScrollViewInsets=NO;
       return self;
}

-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *v=[[[NSBundle mainBundle]loadNibNamed:@"NavBar" owner:self options:nil]firstObject];
    v.frame=CGRectMake(0, 0, MAIN_WIDTH, 64);
    [self.view addSubview:v];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshgoodnum:) name:@"addorminusClick" object:nil];
    redline=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, MAIN_HEIGHT*0.07)];
    redline.backgroundColor=[UIColor redColor];
    
    [self initparas];
    [self setbottombar];
    //获取列表之前，先获得一级菜单
    [self getfirstclassfication];
 }
-(void)refreshgoodnum:(NSNotification *)anote{
    NSArray *idsneedtorefresh=[[anote userInfo] arrayForKey:@"id"];
    for (int i=0; i<[_fenleitableview numberOfRowsInSection:0]; i++) {
        GoodListTableViewCell *cell=[_fenleitableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if([idsneedtorefresh containsObject:cell.goodsid])
            cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
    }
    [self setbottombar];
}

-(void)setbottombar{
    int kindcount=[LocalAndOnlineFileTool refreshkindnum:self.tabBarController];
    if(kindcount==0){
        _numofgoodskindlab.backgroundColor=[UIColor lightGrayColor];
        _summoneylab.textColor=[UIColor lightGrayColor];
        _payBtn.backgroundColor=[UIColor lightGrayColor];
        _payBtn.enabled=NO;
    }
    else{
        _numofgoodskindlab.backgroundColor=[UIColor redColor];
        _summoneylab.textColor=[UIColor redColor];
        _payBtn.backgroundColor=[UIColor redColor];
        _payBtn.enabled=YES;

    }
    //设置种类
    _numofgoodskindlab.text=[NSString stringWithFormat:@"%d种商品",kindcount];
    //设置商品数量
    [_payBtn setTitle:[NSString stringWithFormat:@"去支付(%d)",[LocalAndOnlineFileTool refreshcoungnum]] forState:UIControlStateNormal];
    //设置参考价格
    _summoneylab.text=[NSString stringWithFormat:@"¥%.2f",[LocalAndOnlineFileTool calculatesummoneyinshopcar]];
}
-(void)getfirstclassfication{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    [HttpTool post:@"get_first_classification" params:paras success:^(id responseObj) {
        if([responseObj int32ForKey:@"result"]==0){
            if([[responseObj arrayForKey:@"data"]count]==0)
                return ;
            mainclassfication=[[responseObj arrayForKey:@"data"]mutableCopy];
            //初始化一级分类的id
            mainpid=[mainclassfication[0] stringForKey:@"id"];
            _maintitilelab.text=[mainclassfication[0] stringForKey:@"name"];
           
            NSLog(@"初始化的值为:%@",mainpid);
            
            //获取二级菜单
            [self getsubclassfication:mainpid];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"获取一级分类失败%@",error);
    } controler:self];
}
//获取二级分类
-(void)getsubclassfication:(NSString *)firstpids {
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"first_classify_id"]=firstpids;
    [HttpTool post:@"get_second_classification" params:paras success:^(id responseObj) {
        NSLog(@"获取二级分类%@ 参数=%@",responseObj,paras);
        if([responseObj int32ForKey:@"result"]==0){
            if([[responseObj arrayForKey:@"data"] count]>0){
                subclassfication=[[responseObj arrayForKey:@"data"]mutableCopy];
                NSLog(@"打印二级fenlei%@",subclassfication);
                [_titletableview reloadData];
                subpid=[subclassfication[0] stringForKey:@"id"];
                [self getdatafromweb:1 mainpids:mainpid subpids:subpid goodsname:goodsname sorttype:sorttype sortfield:sortfield];
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"获取一级分类失败%@",error);
    }controler:self];

}
-(void)refreshfenleivc{
   [self getdatafromweb:1 mainpids:mainpid subpids:subpid goodsname:goodsname sorttype:sorttype sortfield:sortfield];

}

-(void)initparas{
    _titletableview.backgroundColor=[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
    goodslist=[NSMutableArray array];
    goodstitles=[NSMutableArray array];
    pagenum=1;
    mainpid=nil;
    subpid=nil;
    mainclassfication=[NSMutableArray array];
    subclassfication=[NSMutableArray array];
    sorttype=nil;
    sortfield=nil;
    _showMenuBtn.selected=NO;
    
    
}

-(void)getdatafromweb:(int)page_no mainpids:(NSString *)goodstype subpids:(NSString *)goodstype2 goodsname:(NSString *)goodsname sorttype:(NSString *)sorttype sortfield:(NSString *)sortfield{
    
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"page_size"]=@10;
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    paras[@"page_no"]=[NSString stringWithFormat:@"%d",page_no];
    paras[@"goodsTypeLv1Id"]=goodstype;
    paras[@"goodsTypeLv2Id"]=goodstype2;
    paras[@"sortType"]=sorttype;
    paras[@"sortField"]=sortfield;
    [HttpTool post:@"get_goods_list" params:paras success:^(id responseObj) {
        NSLog(@"第%d页面 获得的分类数据为%@ 参数=%@",page_no,responseObj,paras);
                if(goodslist.count>0){
            previouscount=goodslist.count;
            if([[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count]>0)
            [goodslist addObjectsFromArray:[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"]];
            //局部刷新
            NSMutableArray *indexs=[NSMutableArray array];
            for(int i=0;i<[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count];i++){
                NSIndexPath *index=[NSIndexPath indexPathForRow:previouscount+i inSection:0];
                [indexs addObject:index];
                //每次从线上请求新的数据都要喝本地同步
                [LocalAndOnlineFileTool keepthesamewithonline:goodslist];
            }
            [_fenleitableview beginUpdates];
            [_fenleitableview insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [_fenleitableview endUpdates];


        }
        else
        {
            if([[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_list"] count]>0){
                _fenleitableview.hidden=NO;
                
            goodslist=[[[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_list"] mutableCopy];
                //每次从线上请求新的数据都要喝本地同步
                [LocalAndOnlineFileTool keepthesamewithonline:goodslist];
                NSLog(@"when next can come to here?");
            totalpage=[[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"page"] doubleForKey:@"total_page"];
                NSLog(@"总页数%d",totalpage);
                [_fenleitableview reloadData];
            }
            else
            {
                _fenleitableview.hidden=YES;
            }
            
        }
            
        
    } failure:^(NSError *error) {
        NSLog(@"获取分类失败 %@",error);
    }controler:self];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //二级标题
    if(tableView.tag==11){
        NSLog(@"二级标题为%@",subclassfication);
        return subclassfication.count;}
    //一级标题
    else if (tableView.tag==99)return  mainclassfication.count;
    else
        return goodslist.count;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //二级标题
    if(tableView.tag==11){
        SubtitleTableViewCell *cell=[SubtitleTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
        
        cell.backgroundColor=[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
        cell.text=[subclassfication[indexPath.row] stringForKey:@"name"];

        if(indexPath.row==0){
           [cell addSubview:redline];
            cell.color=[UIColor redColor];
            cell.backgroundColor=[UIColor whiteColor];
        }
        return cell;
    }
    //一级标题
    else if (tableView.tag==99){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"maintitile"];
        if(!cell)
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"maintitile"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.text=[mainclassfication[indexPath.row]stringForKey:@"name"];
        cell.textLabel.textColor=[UIColor colorWithRed:208.0/255 green:87.0/255 blue:40.0/255 alpha:1.0];
        cell.textLabel.font=[UIFont systemFontOfSize:12.0*(MAIN_WIDTH/375)];
        return cell;
        
    }
    //商品列表
    else{
        GoodListTableViewCell *cell=[GoodListTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
        NSDictionary *dict=goodslist[indexPath.row];
        NSLog(@"dict==%@",dict);
        cell.detailBtn.tag = indexPath.row;
        [cell.detailBtn addTarget:self action:@selector(goToDetailVC:)  forControlEvents:UIControlEventTouchUpInside];
        cell.goodsid=[dict stringForKey:@"id"];
        cell.count=[NSString stringWithFormat:@"%d",[LocalAndOnlineFileTool singlegoodcount:cell.goodsid]];
        cell.price=[dict stringForKey:@"price"];
        cell.goodimg=[dict stringForKey:@"thumbnailImg"];
        cell.goodname=[dict stringForKey:@"name"];
        cell.specific=[dict stringForKey:@"specifications"];
        
        cell.counthasbeensaled=[NSString stringWithFormat:@"本市场今日已销售%@件",[dict stringForKey:@"dailySales"]];
        cell.shortcomment=[dict stringForKey:@"commentary"];
        NSArray *array=[dict arrayForKey:@"goodsRangePrice"];
        switch (array.count) {
            case 0:
            {
                cell.range1lab.hidden = YES;
                cell.range2lab.hidden = YES;
                cell.range3lab.hidden = YES;
                cell.range4lab.hidden = YES;
                cell.price1lab.hidden = YES;
                cell.price2lab.hidden = YES;
                cell.price3lab.hidden = YES;
                cell.price4lab.hidden = YES;
                cell.pricelab.hidden = NO;
                cell.pricelab.text = [NSString stringWithFormat:@"¥%@", [dict stringForKey:@"price"]];
            }
                break;
            case 1:
            {
                cell.range2lab.hidden = YES;
                cell.range3lab.hidden = YES;
                cell.range4lab.hidden = YES;
                cell.price2lab.hidden = YES;
                cell.price3lab.hidden = YES;
                cell.price4lab.hidden = YES;
                cell.pricelab.hidden = YES;
                cell.range1lab.hidden=NO;
                cell.price1lab.hidden=NO;
                cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
                cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
                
            }
                break;
            case 2:
            {
                cell.range3lab.hidden = YES;
                cell.range4lab.hidden = YES;
                cell.price3lab.hidden = YES;
                cell.price4lab.hidden = YES;
                cell.pricelab.hidden = YES;
                cell.range1lab.hidden=NO;
                cell.price1lab.hidden=NO;
                cell.range2lab.hidden=NO;
                cell.price2lab.hidden=NO;                cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
                cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
                cell.range2=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
                cell.price2=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
            }
                break;
            case 3:
            {
                cell.range4lab.hidden = YES;
                cell.price4lab.hidden = YES;
                cell.pricelab.hidden = YES;
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
                cell.pricelab.hidden = YES;
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
}

- (void)goToDetailVC:(UIButton *)sender{
    NSDictionary *good = goodslist[sender.tag];
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc]init];
    detailVC.goodsid = good[@"goodsId"];
    detailVC.supplierid = good[@"supplierId"];
    detailVC.marketid = good[@"marketId"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)minusBtnClicked:(UIButton *)sender{
    GoodListTableViewCell *cell=[_fenleitableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    if(i>0){
        if(i==1)
    [cell.minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255  blue:163.0/255  alpha:1.0] forState:UIControlStateNormal];
        cell.count=[NSString stringWithFormat:@"%d",i-1];
        [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i-1 tabbar:self.tabBarController];
        [self setbottombar];
}
}

-(void)addBtnClicked:(UIButton *)sender{
    GoodListTableViewCell *cell=[_fenleitableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    int i=[cell.countlab.text intValue];
    cell.count=[NSString stringWithFormat:@"%d",i+1];
    [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:i+1 tabbar:self.tabBarController];
    [self setbottombar];

}


- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}
-(void)showgoodsdetail:(UIButton *)sender{
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    vc.goodsid=[goodslist[sender.tag] stringForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)buysoonBtnClicked:(UIButton *)sender{

}

-(void)addtoshopcarBtnClicked:(UIButton *)sender{
    if(![[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"])
    {
        LoginViewController *vc=[[LoginViewController alloc]init];
        vc.source=@"xinpin";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        NSMutableDictionary *paras=[NSMutableDictionary dictionary];
        paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
        
        paras[@"goodsId"]=[goodslist[sender.tag] stringForKey:@"id"];
        paras[@"quantity"]=@"1";
        [HttpTool post:@"add_to_cart" params:paras success:^(id responseObj) {
            if([responseObj int32ForKey:@"result"]==0){
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addedtocar" object:nil];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已加入购物车";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:1.5];
            }
            else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText =[[responseObj dictionaryForKey:@"data"] stringForKey:@"error_msg"];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:1.0];
                
            }
        } failure:^(NSError *error) {
            
        }controler:self];
        
        
    }

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"goodslist=%d",goodslist.count);
    
    if(tableView.tag==22&&(indexPath.row==goodslist.count-1)){
       
        if(pagenum<totalpage){
        pagenum++;
        NSLog(@"huadongdi %d",pagenum);
    [self getdatafromweb:pagenum mainpids:mainpid subpids:subpid goodsname:goodsname sorttype:sorttype sortfield:sortfield];
        }
      
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //二级标题
    if(tableView.tag==11){
        SubtitleTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        [cell addSubview:redline];
        //如果点击的不是第一个，将第一个手动设定为为选中状态
        if(indexPath.row){
          SubtitleTableViewCell *cell0=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell0.backgroundColor=[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
            cell0.color=[UIColor colorWithRed:19.0/255 green:19.0/255 blue:19.0/255 alpha:1.0];
        }
        cell.backgroundColor=[UIColor whiteColor];
        [goodslist removeAllObjects];
        pagenum=1;
        cell.color=[UIColor redColor];
        [cell addSubview:redline];
        subpid=[subclassfication[indexPath.row] stringForKey:@"id"];
           [self getdatafromweb:pagenum mainpids:mainpid subpids:subpid goodsname:goodsname sorttype:sorttype sortfield:sortfield];
       
   }
    //一级标题
    if(tableView.tag==99){
        GoodListTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor=[UIColor colorWithRed:254.0/255 green:147.0/255 blue:147.0/255 alpha:1.0];
        [self singletapofmask:nil];
        [goodslist removeAllObjects];
        [subclassfication removeAllObjects];
        pagenum=1;
        mainpid=[mainclassfication[indexPath.row] stringForKey:@"id"];
        _maintitilelab.text=[mainclassfication[indexPath.row] stringForKey:@"name"];
        [self getsubclassfication:mainpid];
        
        
        
    }
        

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==11){
        SubtitleTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
         cell.backgroundColor=[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
        cell.color=[UIColor colorWithRed:19.0/255 green:19.0/255 blue:19.0/255 alpha:1.0];
    }
    if(tableView.tag==99){
        GoodListTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor=[UIColor whiteColor];
    }
}
-(void)backBtnClicked{
    if(self.tabBarController.selectedIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden=YES;
    }
    else{
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
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //二级标题
    if(tableView.tag==11)
        return MAIN_HEIGHT*0.07;
    //一级标题
    else if (tableView.tag==99)
        return MAIN_HEIGHT*0.058;
    else
    {
        return MAIN_HEIGHT*0.24;
    }
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtnClicked:(id)sender {
//   [[SaveFileAndWriteFileToSandBox singletonInstance]removefile:@"goodscount.txt"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchIconClicked:(id)sender {
    SearchResultsViewController *vc=[[SearchResultsViewController alloc]init];
    vc.keywords=nil;
    [self.navigationController pushViewController:vc animated:YES];
}
//弹出一级菜单
- (IBAction)showMenuBtnClicked:(UIButton *)sender {
    if (!sender.selected) {
        _menuArrow.image=[UIImage imageNamed:@"defaultarrow"];
        firstmenu=[[[NSBundle mainBundle]loadNibNamed:@"popfirstclassficationmenu" owner:self options:nil]firstObject];
        firstmenu.frame=CGRectMake(0, 64, MAIN_WIDTH, MAIN_HEIGHT-64);
        _heightconstraint.active=NO;
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_firstclassmenutableview
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:MAIN_HEIGHT*0.058*[mainclassfication count]];
        
        [firstmenu addConstraint:heightConstraint];
        [self.view addSubview:firstmenu];
        _showMenuBtn.selected=YES;
    }
    else{
        [self singletapofmask:nil];
        _showMenuBtn.selected=NO;
    }
   
    
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
   if(touch.view.tag==99||touch.view.tag==66)
       return NO;
    else
        return YES;
}
- (IBAction)singletapofmask:(id)sender {
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         firstmenu.alpha = 0;
                     }completion:^(BOOL finished){
                         [firstmenu removeFromSuperview];
                         _menuArrow.image=[UIImage imageNamed:@"clickarrow"];
                     }];}
- (IBAction)PayBtnClicked:(id)sender {
    OrderConformationViewController *vc=[[OrderConformationViewController alloc]init];
    vc.tabledata=[[LocalAndOnlineFileTool getbuyinggoodslist] mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)carIconClicked:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}
@end
