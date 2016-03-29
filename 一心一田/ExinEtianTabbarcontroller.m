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
@interface ExinEtianTabbarcontroller ()<UITabBarControllerDelegate>{
    UINavigationController *nav1;
    UINavigationController *nav2;
    UINavigationController *nav3;
}

@end


@implementation ExinEtianTabbarcontroller

-(instancetype)init{
    if(self=[super init]){
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginbindvc) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutbindvc) name:@"logout" object:nil];
    self.delegate=self;
    [self inittabbar];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
   
    UINavigationController *nav=(UINavigationController *)viewController;
    [nav popToRootViewControllerAnimated:YES];

}
-(void)inittabbar{
    
    //登录过
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]){
        HomeViewController *home=[[HomeViewController alloc]init];
        [self addOneChlildVc:home title:@"首页" imageName:@"首页" selectedImageName:@""];
        ShopcarViewController *shopcar=[[ShopcarViewController alloc]init];
        [self addOneChlildVc:shopcar title:@"购物车" imageName:@"购物车" selectedImageName:@""];
        PersonalCenterViewController *personinfo=[[PersonalCenterViewController alloc]init];
        [self addOneChlildVc:personinfo title:@"我的" imageName:@"我的" selectedImageName:@""];
         [LocalAndOnlineFileTool refreshkindnum:self];
         NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
        
    }
    //没有登录
    else{
        LoginViewController *login1=[[LoginViewController alloc]init];
        LoginViewController *login2=[[LoginViewController alloc]init];
        LoginViewController *login3=[[LoginViewController alloc]init];
       [self addOneChlildVc:login1 title:@"首页" imageName:@"首页" selectedImageName:@""];
        [self addOneChlildVc:login2 title:@"购物车" imageName:@"购物车" selectedImageName:@""];
        [self addOneChlildVc:login3 title:@"我的" imageName:@"我的" selectedImageName:@""];
        
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
    HomeViewController *vc1=[[HomeViewController alloc]init];
    ShopcarViewController *vc2=[[ShopcarViewController alloc]init];
    PersonalCenterViewController *vc3=[[PersonalCenterViewController alloc]init];
    nav1=[[UINavigationController alloc]initWithRootViewController:vc1];
    nav2=[[UINavigationController alloc]initWithRootViewController:vc2];
    nav3=[[UINavigationController alloc]initWithRootViewController:vc3];
    
    
    NSMutableArray *array=[NSMutableArray arrayWithArray:self.viewControllers];
    [array replaceObjectAtIndex:0 withObject:nav1];
    [array replaceObjectAtIndex:1 withObject:nav2];
    [array replaceObjectAtIndex:2 withObject:nav3];
    [self setViewControllers:array animated:NO];
    UITabBarItem *item0=[self.tabBar.items objectAtIndex:0];
    UITabBarItem *item1=[self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2=[self.tabBar.items objectAtIndex:2];
    item0.title=@"首页";
    item0.image=[UIImage imageNamed:@"首页"];
    item1.title=@"购物车";
    item1.image=[UIImage imageNamed:@"购物车"];
//    item1.selectedImage=[UIImage imageNamed:@"car"];
    item2.title=@"我的";
    item2.image=[UIImage imageNamed:@"我的"];
//    item2.selectedImage=[UIImage imageNamed:@"mine"];
    [LocalAndOnlineFileTool refreshkindnum:self];

}
-(void)logoutbindvc{
    LoginViewController *vc0=[[LoginViewController alloc]init];
    LoginViewController *vc1=[[LoginViewController alloc]init];
    LoginViewController *vc2=[[LoginViewController alloc]init];
   nav1=[[UINavigationController alloc]initWithRootViewController:vc0];
 nav2=[[UINavigationController alloc]initWithRootViewController:vc1];
 nav3=[[UINavigationController alloc]initWithRootViewController:vc2];
    
    
    NSMutableArray *array=[NSMutableArray arrayWithArray:self.viewControllers];
    [array replaceObjectAtIndex:0 withObject:nav1];
    [array replaceObjectAtIndex:1 withObject:nav2];
    [array replaceObjectAtIndex:2 withObject:nav3];
    [self setViewControllers:array animated:NO];
    UITabBarItem *item0=[self.tabBar.items objectAtIndex:0];
    UITabBarItem *item1=[self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2=[self.tabBar.items objectAtIndex:2];
    item0.title=@"首页";
    item0.image=[UIImage imageNamed:@"首页"];
    item1.title=@"购物车";
    item1.image=[UIImage imageNamed:@"购物车"];
//    item1.selectedImage=[UIImage imageNamed:@"car"];
    item2.title=@"我的";
    item2.image=[UIImage imageNamed:@"我的"];
//    item2.selectedImage=[UIImage imageNamed:@"mine"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
