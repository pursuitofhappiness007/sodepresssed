//
//  ClassficationViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/8.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "ClassficationViewController.h"
#import "HomeTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "ShopcarViewController.h"

@interface ClassficationViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSMutableArray *goodslist;
    NSMutableArray *goodstitles;
    int pagenum;
    NSString *pids;
    int previouscount;
    UITableViewCell *basedcell;
    int totalpage;
}


@property (weak, nonatomic) IBOutlet UITableView *titletableview;
@property (weak, nonatomic) IBOutlet UITableView *fenleitableview;

@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;

@end

@implementation ClassficationViewController

-(instancetype)init{
   if(self=[super init])
       self.automaticallyAdjustsScrollViewInsets=NO;
       return self;
}

-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftView:[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"searchIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]]];
    _searchbar.placeholder=@"搜索您喜欢的商品、品牌";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:@"" target:self action:@selector(backBtnClicked)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshfenleivc) name:@"refreshfenleivc" object:nil];
    
    
    self.navigationItem.title=@"分类";
        [self initparas];
    [self getdatafromweb:1 pids:nil];
    
    
}

-(void)refreshfenleivc{
   [self getdatafromweb:1 pids:nil];

}

-(void)initparas{
    goodslist=[NSMutableArray array];
    goodstitles=[NSMutableArray array];
    pagenum=1;
    pids=nil;
    
}

-(void)getdatafromweb:(int)page_no pids:(NSString *)goodstype{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    
    paras[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"] stringForKey:@"token"];
    paras[@"page_size"]=@6;
    paras[@"page_no"]=[NSString stringWithFormat:@"%d",page_no];
    if(goodstype.length>0)
        paras[@"goodsTypeIds"]=goodstype;
    [HttpTool post:@"get_classification" params:paras success:^(id responseObj) {
        NSLog(@"第%d页面 获得的分类数据为%@",page_no,responseObj);
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
            totalpage=[[responseObj dictionaryForKey:@"data"] int32ForKey:@"total"];
                NSLog(@"总页数%d",totalpage);

                [_fenleitableview reloadData];
            }
            else
            {
                _fenleitableview.hidden=YES;
            }
            
        }
            
        
       
        if(goodstitles.count==0){
        
        [goodstitles addObject:@{@"name":@"全部分类"}];
            [goodstitles addObjectsFromArray: [[responseObj dictionaryForKey:@"data"] mutableArrayValueForKey:@"goods_categories"]];
            [_titletableview reloadData];
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
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
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
        HomeTableViewCell *cell=[HomeTableViewCell cellWithTableView:tableView cellwithIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    
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
        [self getdatafromweb:pagenum pids:pids];
        }
      
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==11){
        [goodslist removeAllObjects];
        pagenum=1;
        basedcell.textLabel.textColor=[UIColor blackColor];
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        cell.textLabel.textColor=[UIColor redColor];
        basedcell=cell;

        if(indexPath.row==0){
            pids=nil;
            [self getdatafromweb:pagenum pids:pids];
        
        }
        else{
            pids=[goodstitles[indexPath.row] stringForKey:@"pids"];
            [self getdatafromweb:pagenum pids:pids];
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
        if(MAIN_HEIGHT==480)
            return MAIN_HEIGHT*0.22;
        else
      return MAIN_HEIGHT*0.16;
    }
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
