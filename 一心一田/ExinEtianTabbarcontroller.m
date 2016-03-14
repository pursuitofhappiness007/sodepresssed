//
//  ExinEtianTabbarcontroller.m
//  一心一田
//
//  Created by xipin on 16/3/7.
//  Copyright © 2016年 xipin. All rights reserved.





#import "ExinEtianTabbarcontroller.h"
#import "HomeViewController.h"
#import "ShopcarViewController.h"
#import "PersonalCenterViewController.h"
#import "LoginViewController.h"
@interface ExinEtianTabbarcontroller ()

@end


@implementation ExinEtianTabbarcontroller

-(instancetype)init{
    if(self=[super init]){
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginbindvc) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutbindvc) name:@"logout" object:nil];
    [self inittabbar];
}

-(void)inittabbar{
    HomeViewController *home=[[HomeViewController alloc]init];
    [self addOneChlildVc:home title:@"首页" imageName:@"首页" selectedImageName:@""];
    //登录过
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]){
        ShopcarViewController *shopcar=[[ShopcarViewController alloc]init];
        [self addOneChlildVc:shopcar title:@"购物车" imageName:@"购物车" selectedImageName:@""];
        PersonalCenterViewController *personinfo=[[PersonalCenterViewController alloc]init];
        [self addOneChlildVc:personinfo title:@"我的" imageName:@"我的" selectedImageName:@""];
        [refreshshoppingcarbadgenum refresh:self];
        
    }
    //没有登录
    else{
        LoginViewController *login1=[[LoginViewController alloc]init];
        LoginViewController *login2=[[LoginViewController alloc]init];
        [self addOneChlildVc:login1 title:@"购物车" imageName:@"购物车" selectedImageName:@""];
        [self addOneChlildVc:login2 title:@"我的" imageName:@"我的" selectedImageName:@""];
        
    }
    
    
}

- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.view.backgroundColor=[UIColor whiteColor];
    
    childVc.tabBarItem=[[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:imageName] tag:0];
    
    // 添加为tabbar控制器的子控制器
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:childVc];
    
    
    
    [self addChildViewController:nav];
}

#pragma mark - didLogined
- (void)loginbindvc{
    ShopcarViewController *vc1=[[ShopcarViewController alloc]init];
    PersonalCenterViewController *vc2=[[PersonalCenterViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc1];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:vc2];
    
    
    NSMutableArray *array=[NSMutableArray arrayWithArray:self.viewControllers];
    [array replaceObjectAtIndex:1 withObject:nav];
    [array replaceObjectAtIndex:2 withObject:nav2];
    [self setViewControllers:array animated:NO];
    UITabBarItem *item1=[self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2=[self.tabBar.items objectAtIndex:2];
    item1.title=@"购物车";
    item1.image=[UIImage imageNamed:@"carnotsel"];
    item1.selectedImage=[UIImage imageNamed:@"car"];
    item2.title=@"我的";
    item2.image=[UIImage imageNamed:@"minenotsel"];
    item2.selectedImage=[UIImage imageNamed:@"mine"];

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
