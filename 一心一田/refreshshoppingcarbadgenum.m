//
//  refreshshoppingcarbadgenum.m
//  一心一田餐饮
//
//  Created by xipin on 15/11/21.
//  Copyright © 2015年 yose. All rights reserved.
//

#import "refreshshoppingcarbadgenum.h"

@implementation refreshshoppingcarbadgenum
+(void)refresh:(UITabBarController *)tabbarvc{
    
        NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"token"]=[[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"]stringForKey:@"token"];
    [HttpTool post:@"get_cart_num" params:para success:^(id responseObj) {
        NSLog(@"有的到刷新数字吗  %@",responseObj);
        if(responseObj[@"data"]!=(id)[NSNull null])
        {
            [[tabbarvc.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",[responseObj int32ForKey:@"data"]]];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"得到刷新数字失败 %@",error);
    }];
    
}
@end
