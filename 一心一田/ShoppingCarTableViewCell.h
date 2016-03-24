//
//  ShoppingCarTableViewCell.h
//  广盐健康大厨房
//
//  Created by xipin on 15/12/13.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarTableViewCell : UITableViewCell
//商品的godsid
@property (nonatomic,weak)NSString *goodsid;
//商品的单价
@property (nonatomic,assign)double singleprice;

@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UILabel *countlab;
@property (weak, nonatomic) IBOutlet UIButton *goodspicBtn;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;


@property (weak,nonatomic) NSString *image;
@property (weak,nonatomic) NSString *name;
@property (weak,nonatomic) NSString *shortcomment;
//已选商品数量
@property (weak,nonatomic) NSString *thecountchoosed;
//应付
@property (weak,nonatomic) NSString *shouldpaid;
//当前数量
@property (weak,nonatomic) NSString *currentcount;
@property (weak, nonatomic) IBOutlet UIButton *singleBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath;

@end
