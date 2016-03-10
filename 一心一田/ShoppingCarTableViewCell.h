//
//  ShoppingCarTableViewCell.h
//  广盐健康大厨房
//
//  Created by xipin on 15/12/13.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UILabel *countlab;
@property (weak, nonatomic) IBOutlet UIButton *goodspicBtn;


@property (weak,nonatomic) NSString *image;
@property (weak,nonatomic) NSString *name;
@property (weak,nonatomic) NSString *goodsfenlei;
@property (weak,nonatomic) NSString *pricebefore;
@property (weak,nonatomic) NSString *originalprice;
@property (weak,nonatomic) NSString *currentprice;
@property (weak,nonatomic) NSString *thecountchoosed;
@property (weak,nonatomic) NSString *acctuallypaid;
@property (weak,nonatomic) NSString *currentcount;
@property (weak, nonatomic) IBOutlet UIButton *singleBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath;

@end
