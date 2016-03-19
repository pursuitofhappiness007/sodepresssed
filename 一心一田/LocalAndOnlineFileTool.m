//
//  LocalAndOnlineFileTool.m
//  一心一田
//
//  Created by xipin on 16/3/17.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "LocalAndOnlineFileTool.h"
@implementation LocalAndOnlineFileTool

-(void)setLocalarray:(NSMutableArray *)localarray{
    self.localarray=localarray;
}
-(NSMutableArray *)localarray{
    NSMutableArray *local=[NSMutableArray array];
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    return local;
}
+(int)getindexoflocal:(NSString *)goodsid{
    NSMutableArray *local=[NSMutableArray array];
    NSMutableArray *localids=[NSMutableArray array];
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    for (NSArray *array in local)
        [localids addObject:array[0]];
    if([localids containsObject:goodsid])
        return [localids indexOfObject:goodsid];
    else
        return -1;
}
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
   //将线上的id到本地文件中遍历一次，找不到就加到本地文件
        for (NSDictionary *dict in onlinegoodlist) {
            [onlineids addObject:[dict stringForKey:@"id"]];
            if(![localids containsObject:[dict stringForKey:@"id"]]){
                [localids addObject:[dict stringForKey:@"id"]];
                [local addObject:@[[dict stringForKey:@"id"],@"0",[dict stringForKey:@"price"],dict]];
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
            [sum addObject:@[[dict stringForKey:@"id"],@"0",[dict stringForKey:@"price"],[DictionaryToJsonStr dictToJsonStr:dict]]];
        }
        
        
        //最后再将更新的文件存入沙盒
        NSLog(@"第一次存到沙盒之前的数组%@",sum);
        [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:@{@"goodscount":sum} filepath:@"goodscount.txt"];
        
        
    }
    
    
    
    
    
}
+(int)refreshkindnum:(UITabBarController *)tabbarvc{
    //统计最新的种类数量
    
    NSMutableArray *local=[NSMutableArray array];
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    //统计种类
    int kindcount=0;
    for (NSArray *array in local){
        if([array[1]intValue]>0)
            kindcount++;
    }
    [[tabbarvc.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d种商品",kindcount]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addorminusClick" object:nil];
    

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
+(float)calculatesummoneyinshopcar{
    NSMutableArray *local=[NSMutableArray array];
    float sum=0.00;
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    for (NSArray *array in local) {
        sum+=[array[1] doubleValue]*[array[2]doubleValue];
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
    for (NSArray *array in local)
        [localids addObject:array[0]];
    
    for (NSString *str in idstodedelete) {
        if([localids containsObject:str]){
            int deleteindex=[localids indexOfObject:str];
            NSArray *temp=[local objectAtIndex:deleteindex];
            NSArray *new=@[temp[0],@"0",temp[2],temp[3]];
            [local replaceObjectAtIndex:deleteindex withObject:new];
        }
            }
    //重置数据后再次写入沙盒
    [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:@{@"goodscount":local} filepath:@"goodscount.txt"];
}
+(void)addOrMinusBtnClickedToRefreshlocal:(NSString *)goodsid withcount:(int)i tabbar:(UITabBarController *)tabbarvc{
    
    NSMutableArray *local=[NSMutableArray array];
    local=[[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"goodscount.txt"]mutableArrayValueForKey:@"goodscount"]mutableCopy];
    for (NSArray *array in local) {
        if([goodsid isEqualToString:array[0]]){
            //刷新本地数据
            NSArray *temp=@[goodsid,[NSString stringWithFormat:@"%d",i],array[2],array[3]];
            //定位本地数据
            [local replaceObjectAtIndex:[self getindexoflocal:goodsid] withObject:temp];
            NSLog(@"点击增加时原来=%@ 现在=%@",array,temp);
            //刷新购物车badgenum
            //统计种类
            int kindcount=0;
            for (NSArray *array in local){
                if([array[1]intValue]>0)
                    kindcount++;
            }
            
            [[SaveFileAndWriteFileToSandBox singletonInstance]savefiletosandbox:[@{@"goodscount":local} mutableCopy] filepath:@"goodscount.txt"];
            [self refreshkindnum:tabbarvc];
            
            break;
        }
    }
    

}
@end
