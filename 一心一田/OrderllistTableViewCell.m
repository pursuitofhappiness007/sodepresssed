//
//  OrderllistTableViewCell.m
//  kitchen
//
//  Created by xipin on 15/12/16.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "OrderllistTableViewCell.h"
@interface OrderllistTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsimage;

@property (weak, nonatomic) IBOutlet UILabel *namelab;

@property (weak, nonatomic) IBOutlet UILabel *totalmoneylab;
//yi

@end
@implementation OrderllistTableViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame])
        self=[[[NSBundle mainBundle]loadNibNamed:@"OrderllistTableViewCell" owner:self options:nil] firstObject];
    return self;
    
}

+(instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID=@"ORDER";
    OrderllistTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        NSLog(@"内存中没找到");
        [tableview registerNib:[UINib nibWithNibName:@"OrderllistTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell=[tableview dequeueReusableCellWithIdentifier:ID];
    }
    return cell;

}

-(void)setImage:(NSString *)image{
    [_goodsimage sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"defualt"]];
    //[[DownLoadImageTool singletonInstance]imageWithImage:image scaledToWidth:_goodsimage.width imageview:_goodsimage];
    
}

-(void)setName:(NSString *)name{
    _namelab.text=name;
}

-(void)setPrice:(NSString *)price{
    _pricelab.text=price;
}

-(void)setCount:(NSString *)count{
    _countlab.text=count;
}

-(void)setToatalmoney:(NSString *)toatalmoney{
    _totalmoneylab.text=toatalmoney;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
