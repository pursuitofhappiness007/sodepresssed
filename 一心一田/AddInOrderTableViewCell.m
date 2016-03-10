//
//  AddInOrderTableViewCell.m
//  kitchen
//
//  Created by xipin on 15/12/16.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "AddInOrderTableViewCell.h"
@interface AddInOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *receiverlab;
@property (weak, nonatomic) IBOutlet UILabel *phonelab;
@property (weak, nonatomic) IBOutlet UILabel *addresslab;

@end
@implementation AddInOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame])
        self=[[[NSBundle mainBundle]loadNibNamed:@"AddInOrderTableViewCell" owner:self options:nil] firstObject];
    return self;
    
}

+(instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID=@"DELIVERY";
    AddInOrderTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        NSLog(@"内存中没找到");
        [tableview registerNib:[UINib nibWithNibName:@"AddInOrderTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell=[tableview dequeueReusableCellWithIdentifier:ID];
        
        
        
    }
    return cell;
    
    
}


-(void)setReceiver:(NSString *)receiver{
    _receiverlab.text=receiver;
    _receiverlab.font=[UIFont systemFontOfSize:12.0*(MAIN_WIDTH/375.0)];
}

-(void)setPhone:(NSString *)phone{
    _phonelab.text=phone;
    _phonelab.font=[UIFont systemFontOfSize:12.0*(MAIN_WIDTH/375.0)];

}

-(void)setAddress:(NSString *)address{
    _addresslab.text=address;
    _addresslab.font=[UIFont systemFontOfSize:12.0*(MAIN_WIDTH/375.0)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
