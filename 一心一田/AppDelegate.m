//
//  AppDelegate.m
//  一心一田
//
//  Created by xipin on 16/3/7.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "AppDelegate.h"
#import "ExinEtianTabbarcontroller.h"
#import "NewFuturesViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "BPush.h"
@interface AppDelegate ()<UIAlertViewDelegate,WXApiDelegate>{
    NSString *trackViewUrl;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 1.创建窗口
    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setTranslucent:YES];
    
    [[UITabBar appearance]setBackgroundImage:[UIImage new]];
   
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;

    // 2.设置窗口的根控制器
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *lastVersion=[defaults objectForKey:@"CFBundleShortVersionString"];
    NSString *currentVersion=[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    if([currentVersion isEqualToString:lastVersion]){
        
        ExinEtianTabbarcontroller *tabbar=[[ExinEtianTabbarcontroller alloc] init];
        
        self.window.rootViewController =tabbar;
       
        
    }
    else {
        if([[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] floatValue]){
            
        }
        self.window.rootViewController = [[NewFuturesViewController alloc] init];
        [defaults setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [defaults synchronize];
    }
    // 3.显示窗口(成为主窗口)
    [self.window makeKeyAndVisible];
    [WXApi registerApp:@"wx7ee078d8ecadd895" withDescription:@"demo 2.0"];
    //消息推送设置
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#warning 上线 AppStore 时需要修改BPushMode为BPushModeProduction 需要修改Apikey为自己的Apikey
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    //发布版的apikey:wDt15ieXbXdDK3BeWAyhgo7x 测试版的apikey:Wz3bMSQYj3WnBI0kTX5affpR
    [BPush registerChannel:launchOptions apiKey:@"PwzNahGc3smzCmnM1GG2dgtI" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
        //注释
    }
    //角标清0
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]){
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[[SaveFileAndWriteFileToSandBox singletonInstance] getfilefromsandbox:@"pushinfo.txt"] count]];
        NSLog(@"fjoqwierie");
    }
//    [self VersionUpdate];
    return YES;
}

-(void)VersionUpdate{
    NSError *error;
    NSString *urlStr=[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=1076231575"];
    if(urlStr.length==0){
        NSLog(@"没有地址");
        return;
    }
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *appInDict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"appindict=%@",appInDict);
    if(error){
        NSLog(@"errorooooo :%@",[error description]);
        return ;
        
    }
    
    NSArray *resultsArray=[appInDict objectForKey:@"results"];
    if(![resultsArray count])
    {
        NSLog(@"error :resultsArray==nil");
        return ;
    }
    //app store中的最新版本信息
    NSDictionary *infoDic=resultsArray[0];
    NSString *lastestversion=infoDic[@"version"];
    NSLog(@"商店中的版本＝＝%@",lastestversion);
    trackViewUrl=infoDic[@"trackViewUrl"];
    NSString *trackname=infoDic[@"trackName"];
    //当前版本信息
    NSDictionary *currentinfoDict=[[NSBundle mainBundle]infoDictionary];
    NSString *currentVersion=currentinfoDict[@"CFBundleVersion"];
    NSArray *currentnums=[currentVersion componentsSeparatedByString:@"."];
    NSArray *lastestnums=[lastestversion componentsSeparatedByString:@"."];
    if([[currentnums objectAtIndex:0] intValue]<[[lastestnums objectAtIndex:0]  intValue]){
        NSString *titleStr=[NSString stringWithFormat:@"检查更新:%@",trackname];
        NSString *messageStr=[NSString stringWithFormat:@"发现新版本(%@),是否升级?",lastestversion];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
        alert.tag=100;
        [alert show];
        
        
    }
    
    else if ([[currentnums objectAtIndex:0] intValue]==[[lastestnums objectAtIndex:0]  intValue]){
        if([currentnums[1] intValue]<[lastestnums[1] intValue]){
            NSString *titleStr=[NSString stringWithFormat:@"检查更新:%@",trackname];
            NSString *messageStr=[NSString stringWithFormat:@"发现新版本(%@),是否升级?",lastestversion];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
            alert.tag=100;
            [alert show];
            
        }
        
        if([currentnums[1] intValue]==[lastestnums[1] intValue]){
            if([currentnums[2] intValue]<[lastestnums[2] intValue]){
                NSString *titleStr=[NSString stringWithFormat:@"检查更新:%@",trackname];
                NSString *messageStr=[NSString stringWithFormat:@"发现新版本(%@),是否升级?",lastestversion];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
                alert.tag=100;
                [alert show];
                
            }
            if([currentnums[2] intValue]>[lastestnums[2] intValue]){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"已经是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
            
            
            
        }
        
        
    }
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 打印到日志 textView 中
    
    NSLog(@"收到的消息 %@",userInfo);
    
    if([UIApplication sharedApplication].applicationState==UIApplicationStateBackground)
    {
        
        NSLog(@"退入后台调用");
        
    }
    if([UIApplication sharedApplication].applicationState==UIApplicationStateActive){
       NSLog(@"通知栏点击了消息");
    completionHandler(UIBackgroundFetchResultNewData);
  }
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
    
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        
    }];
    
    
    
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"device toekn获取失败  原因: %@",error);
    
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    
    NSLog(@"=================%@",userInfo);
    
    
    [BPush handleNotification:userInfo];
    
    
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return  [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return  [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp *)resp{
    NSLog(@"appdelegate中接受通知");
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"paysucceed" object:nil];
                
                break;
            }
            default:{
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"payfailed" object:nil];
                
                break;
            }
        }
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
