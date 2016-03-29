//
//  SubtitleTableViewCell.m
//  一心一田
//
//  Created by xipin on 16/3/29.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "SubtitleTableViewCell.h"
@interface SubtitleTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *subtitlelab;

@end

@implementation SubtitleTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self=[[[NSBundle mainBundle]loadNibNamed:@"SubtitleTableViewCell" owner:self options:nil] firstObject];
        
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID=@"subtitle";
    SubtitleTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        NSLog(@"内存中没找到");
        [tableview registerNib:[UINib nibWithNibName:@"SubtitleTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell=[tableview dequeueReusableCellWithIdentifier:ID];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

-(void)setText:(NSString *)text{
    _subtitlelab.text=text;
}

-(void)setColor:(UIColor *)color{
    _subtitlelab.textColor=color;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
