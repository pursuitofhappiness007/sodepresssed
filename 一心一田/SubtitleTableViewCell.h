//
//  SubtitleTableViewCell.h
//  一心一田
//
//  Created by xipin on 16/3/29.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubtitleTableViewCell : UITableViewCell
@property (nonatomic,copy)NSString *text;
@property (nonatomic,strong)UIColor *color;
+ (instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath;
@end
