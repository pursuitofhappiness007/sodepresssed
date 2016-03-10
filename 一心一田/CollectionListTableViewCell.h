//
//  CollectionListTableViewCell.h
//  一心一田餐饮
//
//  Created by xipin on 15/10/29.
//  Copyright © 2015年 yose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodspic;
@property (weak, nonatomic) IBOutlet UILabel *goodsname;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *buySoon;
@property (weak, nonatomic) IBOutlet UIButton *heart;
@property (weak, nonatomic) IBOutlet UIButton *goodsDetailBtn;



@end
