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
#import "SearchViewController.h"
#import "ShopcarViewController.h"

@interface ClassficationViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSMutableArray *goodslist;
    NSMutableArray *goodstitles;
    int pagenum;
    NSString *mainpids;
    NSString *subpids;
    NSString *goodsname;
    NSString *sorttype;
    NSString *sortfield;
    int previouscount;
    UITableViewCell *basedcell;
    int totalpage;
    UIView *redline;
}


- (IBAction)backBtnClicked:(id)sender;
- (IBAction)searchIconClicked:(id)sender;
- (IBAction)showMenuBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *menuArrow;
@property (weak, nonatomic) IBOutlet UITableView *titletableview;
@property (weak, nonatomic) IBOutlet UITableView *fenleitableview;

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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshfenleivc) name:@"refreshfenleivc" object:nil];
    
    
    [self initparas];
    [self getdatafromweb:1 mainpids:mainpids subpids:subpids goodsname:goodsname sorttype:sorttype sortfield:sortfield];
    
    
}

-(void)refreshfenleivc{
   [self getdatafromweb:1 mainpids:mainpids subpids:subpids goodsname:goodsname sorttype:sorttype sortfield:sortfield];

}

-(void)initparas{
    goodslist=[NSMutableArray array];
    goodstitles=[NSMutableArray array];
    pagenum=1;
    mainpids=nil;
    subpids=nil;
    sorttype=nil;
    sortfield=nil;
    redline=[[UIView alloc]initWithFrame:CGRectMake(0, 64, 2, MAIN_HEIGHT*0.07)];
    [self.view addSubview:redline];
    
}

-(void)getdatafromweb:(int)page_no mainpids:(NSString *)goodstype subpids:(NSString *)goodstype2 goodsname:(NSString *)goodsname sorttype:(NSString *)sorttype sortfield:(NSString *)sortfield{
    
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    paras[@"page_size"]=@6;
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
            NSMutableArray *indexs=[NSMutableArray array];
            for(int i=0;i<[[[responseObj dictionaryForKey:@"data"] arrayForKey:@"goods_list"] count];i++){
                NSIndexPath *index=[NSIndexPath indexPathForRow:previouscount+i inSection:0];
                [indexs addObject:index];
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
            totalpage=[[[responseObj dictionaryForKey:@"data"] dictionaryForKey:@"page"] doubleForKey:@"total_page"];
                NSLog(@"总页数%d",totalpage);

                [_fenleitableview reloadData];
            }
            else
            {
                _fenleitableview.hidden=YES;
            }
            
        }
            
        
       
        if(goodstitles.count==0){
        
//        [goodstitles addObject:@{@"name":@"全部分类"}];
//            [goodstitles addObjectsFromArray: [[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_categories"]];
//            [_titletableview reloadData];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"获取分类失败 %@",error);
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==11)
        return goodstitles.count;
    else
        return goodslist.count;
    
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"点击了搜索框");

    SearchViewController *vc=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    
    
    return NO;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==11){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"titile"];
        if(!cell)
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titile"];
        if(indexPath.row==0){
        
            cell.textLabel.textColor=[UIColor redColor];
            basedcell=cell;
        }
        cell.textLabel.text=[goodstitles[indexPath.row] stringForKey:@"name"];
       cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.font=[UIFont systemFontOfSize:12.0];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.width, 1.5)];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
        [cell addSubview:line];
        if(indexPath.row==goodstitles.count-1){
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, cell.height-1.5, cell.width, 1.5)];
            line.backgroundColor=[UIColor groupTableViewBackgroundColor];
            [cell addSubview:line];
        }
        
        return cell;
    }
    
    else{
        GoodListTableViewCell *cell=[GoodListTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
        NSDictionary *dict=goodslist[indexPath.row];
        cell.goodimg=[dict stringForKey:@"thumbnailImg"];
        cell.goodname=[dict stringForKey:@"name"];
        cell.specific=[dict stringForKey:@"specifications"];
        NSArray *array=[dict arrayForKey:@"goodsRangePrice"];
        cell.range1=[NSString stringWithFormat:@"%@-%@",[array[0] stringForKey:@"minNum"],[array[0] stringForKey:@"maxNum"]];
        cell.range2=[NSString stringWithFormat:@"%@-%@",[array[1] stringForKey:@"minNum"],[array[1] stringForKey:@"maxNum"]];
        cell.range3=[NSString stringWithFormat:@"%@-%@",[array[2] stringForKey:@"minNum"],[array[2] stringForKey:@"maxNum"]];
        cell.range4=[NSString stringWithFormat:@"%@-%@",[array[3] stringForKey:@"minNum"],[array[3] stringForKey:@"maxNum"]];
        cell.price1=[NSString stringWithFormat:@"¥%@",[array[0] stringForKey:@"price"]];
        cell.price2=[NSString stringWithFormat:@"¥%@",[array[1] stringForKey:@"price"]];
        cell.price3=[NSString stringWithFormat:@"¥%@",[array[2] stringForKey:@"price"]];
        cell.price4=[NSString stringWithFormat:@"¥%@",[array[3] stringForKey:@"price"]];
        cell.count=@"1";
        cell.minusBtn.tag=indexPath.row;
        cell.addBtn.tag=indexPath.row;
        [cell.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

-(void)minusBtnClicked:(UIButton *)sender{
    GoodListTableViewCell *cell=[_fenleitableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    int i=[cell.count intValue];
    if(i>1){
        if(i==2)
    [cell.minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255  blue:163.0/255  alpha:1.0] forState:UIControlStateNormal];
        cell.count=[NSString stringWithFormat:@"%d",i-1];
}
}

-(void)addBtnClicked:(UIButton *)sender{
    GoodListTableViewCell *cell=[_fenleitableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    int i=[cell.count intValue];
    cell.count=[NSString stringWithFormat:@"%d",i+1];

}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    if(tableView.tag==11){
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor whiteColor] ForCell:cell];
        //highlight colour
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag==11){
    // Reset Colour.
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0] ForCell:cell];
        //normal color
    }
    
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
                [refreshshoppingcarbadgenum refresh:self.tabBarController];
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
            
        }];
        
        
    }

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"goodslist=%d",goodslist.count);
    
    if(tableView.tag==22&&(indexPath.row==goodslist.count-1)){
       
        if(pagenum<totalpage){
        pagenum++;
        NSLog(@"huadongdi %d",pagenum);
            [self getdatafromweb:pagenum mainpids:mainpids subpids:subpids goodsname:goodsname sorttype:sorttype sortfield:sortfield];
        }
      
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==11){
        redline.y=64+indexPath.row*MAIN_HEIGHT*0.07;
        [goodslist removeAllObjects];
        pagenum=1;
        basedcell.textLabel.textColor=[UIColor blackColor];
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        cell.textLabel.textColor=[UIColor redColor];
        basedcell=cell;

        if(indexPath.row==0){
            mainpids=nil;
            subpids=nil;
            [self getdatafromweb:pagenum mainpids:mainpids subpids:subpids goodsname:goodsname sorttype:sorttype sortfield:sortfield];
        
        }
        else{
            mainpids=[goodstitles[indexPath.row] stringForKey:@"pids"];
           [self getdatafromweb:pagenum mainpids:mainpids subpids:subpids goodsname:goodsname sorttype:sorttype sortfield:sortfield];
        }
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
    if(tableView.tag==11)
        return MAIN_HEIGHT*0.07;
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
}

- (IBAction)searchIconClicked:(id)sender {
}

- (IBAction)showMenuBtnClicked:(id)sender {
}
@end
