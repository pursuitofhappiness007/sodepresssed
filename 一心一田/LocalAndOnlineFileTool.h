//
//  LocalAndOnlineFileTool.h
//  一心一田
//
//  Created by xipin on 16/3/17.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalAndOnlineFileTool : NSObject
@property (nonatomic,weak)NSMutableArray *localarray;
//取出本地数组
//根据goodsis定位到本地下标
+(int)getindexoflocal:(NSString *)goodsid;
//让线上和本地的商品种类一致
+(void)keepthesamewithonline:(NSMutableArray *)onlinegoodlist;
//刷新购物车中的种类
+(int)refreshkindnum:(UITabBarController *)tabbarvc;
//刷新购物车中买了多少件商品
+(int)refreshcoungnum;
//计算购物车中的总金额
+(float)calculatesummoneyinshopcar;
//计算某个商品买了多少件
+(int)singlegoodcount:(NSString *)goodsid;
//立即购买支付成功后，所有商品数量清零
+(void)resetaftersuccessfulsubmit:(NSArray *)idstodedelete;
//点击加减按钮刷新本地的商品数量
+(void)addOrMinusBtnClickedToRefreshlocal:(NSString *)goodsid withcount:(int)i tabbar:(UITabBarController *)tabbarvc;
@end
