//
//  LocalAndOnlineFileTool.m
//  一心一田
//
//  Created by xipin on 16/3/17.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "LocalAndOnlineFileTool.h"

@implementation LocalAndOnlineFileTool
+(void)keepthesamewithonline:(NSMutableArray *)onlinegoodlist{
    //如果已经存储过加入购物车的数量，就将本地和线上的同步
    
    if([[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"])
    {
        //取出本地文件
        
        NSMutableArray *local=[NSMutableArray array];
        local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
        NSLog(@"有本地文件%@",local);
        //将local里面的所有id提取出来，存到一个数组
        NSMutableArray *localids=[NSMutableArray array];
        NSMutableArray *onlineids=[NSMutableArray array];
        for (NSArray *array in local)
            [localids addObject:array[0]];
        ////        //将线上的id到本地文件中遍历一次，找不到就加到本地文件
        
        
        for (NSDictionary *dict in onlinegoodlist) {
            [onlineids addObject:[dict stringForKey:@"goodsId"]];
            if(![localids containsObject:[dict stringForKey:@"goodsId"]]){
                NSArray *temp=@[[dict stringForKey:@"goodsId"],@"0"];
                [localids addObject:[dict stringForKey:@"goodsId"]];
                [local addObject:temp];
            }
            
        }
        //再将本地的拿到线上遍历一遍，找不到就删除
        int currentIndex=0;
        for (NSString *str in localids) {
            if(![onlineids containsObject:str])
                [local removeObjectAtIndex:currentIndex];
            currentIndex++;
        }
        NSLog(@"存入沙盒的数据与线上匹配后的%@",local);
        [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:[@{@"goodscount":local} mutableCopy] filepath:@"goodscount.txt"];
        
        
    }
    
    
    //如果没有存储过，初始化本地数组
    else{
        NSMutableArray *sum=[NSMutableArray array];
        for (NSDictionary *dict in onlinegoodlist){
            [sum addObject:@[[dict stringForKey:@"goodsId"],@"0",[dict stringForKey:@"price"]]];
        }
        
        
        //最后再将更新的文件存入沙盒
        NSLog(@"第一次存到沙盒之前的数组%@",sum);
        [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:@{@"goodscount":sum} filepath:@"goodscount.txt"];
        
        
    }
    
    
    
    
    
}
+(int)refreshkindnum:(UITabBarController *)tabbarvc{
    //统计最新的种类数量
    //统计种类
    int kindcount=0;
    NSMutableArray *local=[NSMutableArray array];
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    for (NSArray *array in local){
        if([array[1]intValue]>0)
            kindcount++;
    }
    [[tabbarvc.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d种商品",kindcount]];

    return kindcount;
}
+(int)refreshcoungnum{
    int kindcount=0;
    NSMutableArray *local=[NSMutableArray array];
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    for (NSArray *array in local){
        if([array[1]intValue]>0)
            kindcount+=[array[1]intValue];
    }
    
    return kindcount;
}
+(double)calculatesummoneyinshopcar{
    NSMutableArray *local=[NSMutableArray array];
    double sum=0;
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    for (NSArray *array in local) {
        sum+=[array[1] doubleValue]*[array[2]intValue];
    }
    return sum;
}
+(int)singlegoodcount:(NSString *)goodsid{
    NSMutableArray *local=[NSMutableArray array];
    int count=0;
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    for (NSArray *array in local){
        if([array[0] isEqualToString:goodsid]){
            count=[array[1] intValue];
        break;
        }
    }
    return count;
}
+(void)resetaftersuccessfulsubmit:(NSArray *)idstodedelete{
    NSMutableArray *local=[NSMutableArray array];
    NSMutableArray *localids=[NSMutableArray array];
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    for (NSArray *array in local) {
        [localids addObject:array[0]];
    }
    
    for (NSString *str in idstodedelete) {
        if([localids containsObject:str]){
            int deleteindex=[localids indexOfObject:str];
            NSArray *temp=[local objectAtIndex:deleteindex];
            NSArray *new=@[temp[0],@"0",temp[2]];
            [local replaceObjectAtIndex:deleteindex withObject:new];
        }
            }
    //重置数据后再次写入沙盒
    [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:@{@"goodscount":local} filepath:@"goodscount.txt"];
}
@end
