//
//  NewFuturesViewController.m
//  一心一田
//
//  Created by xipin on 16/3/7.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "NewFuturesViewController.h"
#import "ExinEtianTabbarcontroller.h"
@interface NewFuturesViewController ()<UIScrollViewDelegate>

@end

@implementation NewFuturesViewController
-(void)viewWillAppear:(BOOL)animated{
    _startBtn.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupScrollView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   ExinEtianTabbarcontroller *vc = [[ExinEtianTabbarcontroller alloc] init];
    

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int pagnum=scrollView.contentOffset.x/scrollView.width;
    _forwardimg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d",pagnum+11]];
    if (pagnum==NewFuturesCount-1){
        _forwardimg.hidden=YES;
        _startBtn.hidden=NO;
    }
    else
    {
        _forwardimg.hidden=NO;
        _startBtn.hidden=YES;
    }
    NSLog(@"当前滚到第%d页",pagnum);

    
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

- (IBAction)startBtnClicked:(id)sender {
    ExinEtianTabbarcontroller *vc = [[ExinEtianTabbarcontroller alloc] init];
    
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;

}
@end

