//
//  MessageTableViewCell.m
//  一心一田
//
//  Created by xipin on 16/3/9.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "MessageTableViewCell.h"
@interface MessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconimg;
@property (weak, nonatomic) IBOutlet UILabel *msgcontentlab;
@property (weak, nonatomic) IBOutlet UILabel *timelab;

@end
@implementation MessageTableViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame])
        self=[[[NSBundle mainBundle]loadNibNamed:@"MessageTableViewCell" owner:self options:nil] firstObject];
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID=@"msgcell";
    MessageTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        NSLog(@"内存中没找到");
        [tableview registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell=[tableview dequeueReusableCellWithIdentifier:ID];
        
    }
    return cell;
    
    
}
-(void)setIcon:(NSString *)icon{
    [_iconimg sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"defualt"]];
 //   [[DownLoadImageTool singletonInstance]imageWithImage:icon scaledToWidth:_iconimg.width imageview:_iconimg];
}
-(void)setTime:(NSString *)time{
    _timelab.text=time;
}
-(void)setMsgcontent:(NSString *)msgcontent{
    _msgcontentlab.text=msgcontent;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
