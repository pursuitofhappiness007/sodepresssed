//
//  SearchViewController.m
//  广盐健康大厨房
//
//  Created by xipin on 15/11/25.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSMutableArray *history;
    NSMutableArray *historydata;
    UIView *v;
    UITableView *historylisttableview;
    UIButton *clearhistory;

}

- (IBAction)searchBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

@end

@implementation SearchViewController
-(instancetype)init{
    if(self=[super init]){
        self.automaticallyAdjustsScrollViewInsets=NO;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden=YES;
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backtofirstsearchrefresh) name:@"backtofirstsearch" object:nil];
    
    self.view.backgroundColor=[UIColor whiteColor];
    v=[[[NSBundle mainBundle]loadNibNamed:@"titileForSearchVC" owner:self options:nil] firstObject];
    v.frame=CGRectMake(0, StatusBarH, MAIN_WIDTH, NaviBarH);
    
    history=[NSMutableArray array];
    historydata=[NSMutableArray array];
    [self.view addSubview:v];
   
    

}

-(void)backtofirstsearchrefresh{
    [self.view addSubview:v];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return historydata.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *idenfi=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idenfi];
    if(!cell)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfi];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[historydata[indexPath.section] stringForKey:@"history"];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section!=0)
        
    _searchBar.text=[historydata[indexPath.section] stringForKey:@"history"];

}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [clearhistory removeFromSuperview];
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"history.txt"]){
        
        historydata=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"history.txt"] mutableArrayValueForKey:@"history"] mutableCopy];
        [historydata insertObject:@{@"history":@"历史搜索"} atIndex:0];
        
        if(historydata.count>1){
            if(70+historydata.count*30+54+49<=MAIN_HEIGHT){
            historylisttableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, MAIN_WIDTH, historydata.count*30) style:UITableViewStylePlain];
            historylisttableview.dataSource=self;
            historylisttableview.delegate=self;
            [self.view addSubview:historylisttableview];
            
           clearhistory=[[UIButton alloc]initWithFrame:CGRectMake(MAIN_WIDTH*0.15, historylisttableview.y+historylisttableview.height+10, MAIN_WIDTH*0.7, NaviBarH)];
            clearhistory.layer.masksToBounds=YES;
            clearhistory.layer.cornerRadius=5;
            clearhistory.layer.borderWidth=1;
            clearhistory.layer.borderColor=[[UIColor blueColor] CGColor];
            
            [clearhistory setTitle:@"清除历史纪录" forState:UIControlStateNormal];
            [clearhistory setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [clearhistory addTarget:self action:@selector(clearhistoryClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:clearhistory];
            }
            else{
                historylisttableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, MAIN_WIDTH, MAIN_HEIGHT-70-49-54) style:UITableViewStylePlain];
                historylisttableview.dataSource=self;
                historylisttableview.delegate=self;
                [self.view addSubview:historylisttableview];
                
                clearhistory=[[UIButton alloc]initWithFrame:CGRectMake(MAIN_WIDTH*0.15, historylisttableview.y+historylisttableview.height+10, MAIN_WIDTH*0.7, NaviBarH)];
                clearhistory.layer.masksToBounds=YES;
                clearhistory.layer.cornerRadius=5;
                clearhistory.layer.borderWidth=1;
                clearhistory.layer.borderColor=[[UIColor blueColor] CGColor];
                
                [clearhistory setTitle:@"清除历史纪录" forState:UIControlStateNormal];
                [clearhistory setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [clearhistory addTarget:self action:@selector(clearhistoryClicked) forControlEvents:UIControlEventTouchUpInside];
                
                [self.view addSubview:clearhistory];
              
            }

            
        }
        
    }
    
    return YES;
}

-(void)clearhistoryClicked{
    [[SaveFileAndWriteFileToSandBox singletonInstance]removefile:@"history.txt"];
    [historylisttableview removeFromSuperview];
    [clearhistory removeFromSuperview];
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        NSLog(@"点几了delete");
        
        
            [history removeObjectAtIndex:indexPath.section];
       
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

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




- (IBAction)searchBtnClicked:(id)sender {
    [v removeFromSuperview];
    SearchResultsViewController *vc=[[SearchResultsViewController alloc]init];
    vc.keywords=_searchBar.text;
   
    [self.navigationController pushViewController:vc animated:YES];
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"history.txt"]){
        NSMutableArray *temp=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"history.txt"] mutableArrayValueForKey:@"history"] mutableCopy];
        if(_searchBar.text.length!=0){
            
            
                [temp insertObject:@{@"history":_searchBar.text} atIndex:0];
            NSSet *set=[NSSet setWithArray:temp];
           
            NSLog(@"打印set %@", [set allObjects]);
                [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:@{@"history":[set allObjects]} filepath:@"history.txt"];
            
        }
        
    }
    else{
        if(_searchBar.text.length!=0){
        [history insertObject:@{@"history":_searchBar.text} atIndex:0];
        [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:@{@"history":history} filepath:@"history.txt"];
        }
    }

}

- (IBAction)backBtnClicked:(id)sender {
    if([self.tabBarController selectedIndex]==0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"backtohome" object:nil];
        [v removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBtnClicked:nil];
}
@end
