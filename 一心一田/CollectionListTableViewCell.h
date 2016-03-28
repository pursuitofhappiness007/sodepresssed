//
//  CollectionListTableViewCell.h
//  一心一田
//
//  Created by xipin on 16/3/8.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionListTableViewCell : UITableViewCell
@property (nonatomic,copy)NSString *goodimage;
@property (nonatomic,copy)NSString *goodname;
@property (nonatomic,copy)NSString *shortcomment;
@property (weak, nonatomic) IBOutlet UIButton *actionBt;

//规格
@property (nonatomic,copy)NSString *specific;
//购买数量
@property (nonatomic,copy)NSString *count;
//区间和区间价格
@property (weak, nonatomic) IBOutlet UILabel *range1lab;
@property (weak, nonatomic) IBOutlet UILabel *range2lab;
@property (weak, nonatomic) IBOutlet UILabel *range3lab;
@property (weak, nonatomic) IBOutlet UILabel *range4lab;
@property (weak, nonatomic) IBOutlet UILabel *price1lab;
@property (weak, nonatomic) IBOutlet UILabel *price2lab;
@property (weak, nonatomic) IBOutlet UILabel *price3lab;
@property (weak, nonatomic) IBOutlet UILabel *price4lab;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;


+ (instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath;

@end
