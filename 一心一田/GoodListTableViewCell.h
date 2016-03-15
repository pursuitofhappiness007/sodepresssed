//
//  GoodListTableViewCell.h
//  一心一田
//
//  Created by xipin on 16/3/14.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodListTableViewCell : UITableViewCell
@property (nonatomic,copy)NSString *goodimg;
@property (nonatomic,copy)NSString *goodname;
@property (nonatomic,copy)NSString *shortcomment;
//规格
@property (nonatomic,copy)NSString *specific;
//区间和区间价格
@property (nonatomic,copy)NSString *range1;
@property (nonatomic,copy)NSString *range2;
@property (nonatomic,copy)NSString *range3;
@property (nonatomic,copy)NSString *range4;
@property (nonatomic,copy)NSString *price1;
@property (nonatomic,copy)NSString *price2;
@property (nonatomic,copy)NSString *price3;
@property (nonatomic,copy)NSString *price4;
//购买数量
@property (nonatomic,copy)NSString *count;
//加减按钮
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath;
@end
