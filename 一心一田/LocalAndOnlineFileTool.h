//
//  LocalAndOnlineFileTool.h
//  一心一田
//
//  Created by xipin on 16/3/17.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalAndOnlineFileTool : NSObject
+(void)keepthesamewithonline:(NSMutableArray *)onlinegoodlist;
+(int)refreshkindnum:(UITabBarController *)tabbarvc;
+(int)refreshcoungnum;
+(double)calculatesummoneyinshopcar;
+(int)singlegoodcount:(NSString *)goodsid;
+(void)resetaftersuccessfulsubmit:(NSArray *)idstodedelete;
@end
