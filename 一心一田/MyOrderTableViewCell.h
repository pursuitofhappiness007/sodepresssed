//
//  MyOrderTableViewCell.h
//  广盐健康大厨房
//
//  Created by xipin on 15/12/13.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell

@property (weak,nonatomic) NSString *image;
@property (weak,nonatomic) NSString *name;
@property (weak,nonatomic) NSString *status;
@property (weak,nonatomic) NSString *leibie;
@property (weak,nonatomic) NSString *shortcomment;
@property (weak,nonatomic) NSString *totalgoodstobuy;
@property (weak,nonatomic) NSString *summary;
@property (weak,nonatomic) NSString *actuallypaid;


+ (instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath;

@end
