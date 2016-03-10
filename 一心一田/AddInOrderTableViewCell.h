//
//  AddInOrderTableViewCell.h
//  kitchen
//
//  Created by xipin on 15/12/16.
//  Copyright © 2015年 gy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInOrderTableViewCell : UITableViewCell
@property (nonatomic,weak)NSString *receiver;
@property (nonatomic,weak)NSString *phone;
@property (nonatomic,weak)NSString *address;

+ (instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath;

@end
