//
//  MessageTableViewCell.h
//  一心一田
//
//  Created by xipin on 16/3/9.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *msgcontent;
@property (weak, nonatomic) IBOutlet UIView *redcircle;
+ (instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath;
@end
