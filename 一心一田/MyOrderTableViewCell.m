//
//  MyOrderTableViewCell.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/13.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "MyOrderTableViewCell.h"
@interface MyOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsimage;

@property (weak, nonatomic) IBOutlet UILabel *goodsnamelab;
@property (weak, nonatomic) IBOutlet UILabel *salespricelab;

@property (weak, nonatomic) IBOutlet UILabel *counttobuylab;
@property (weak, nonatomic) IBOutlet UILabel *totalgoodstobuylab;
@property (weak, nonatomic) IBOutlet UILabel *acctuallypaidlab;

@end

@implementation MyOrderTableViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame])
        self=[[[NSBundle mainBundle]loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil] firstObject];
    return self;
    
}

+(instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID=@"myorder";
    MyOrderTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        NSLog(@"内存中没找到");
        [tableview registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell=[tableview dequeueReusableCellWithIdentifier:ID];
        
        
        
    }
    return cell;
    
    
}

-(void)setActuallypaid:(NSString *)actuallypaid{
    _acctuallypaidlab.text=actuallypaid;
}

-(void)setImage:(NSString *)image{
    [[DownLoadImageTool singletonInstance]imageWithImage:image scaledToWidth:_goodsimage.width imageview:_goodsimage];
}

-(void)setName:(NSString *)name{
    _goodsnamelab.text=name;
}

-(void)setPrice:(NSString *)price{
    _salespricelab.text=price;
}


-(void)setCounttobuy:(NSString *)counttobuy{
    _counttobuylab.text=counttobuy;
}

-(void)setTotalgoodstobuy:(NSString *)totalgoodstobuy{
    _totalgoodstobuylab.text=totalgoodstobuy;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
