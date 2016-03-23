//
//  ShoppingCarTableViewCell.m
//  广盐健康大厨房
//
//  Created by xipin on 15/12/13.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "ShoppingCarTableViewCell.h"
@interface ShoppingCarTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsimage;
@property (weak, nonatomic) IBOutlet UILabel *goodsname;

@property (weak, nonatomic) IBOutlet UILabel *countchooselab;
@property (weak, nonatomic) IBOutlet UILabel *shouldpaylab;
@property (weak, nonatomic) IBOutlet UILabel *shortcommentlab;



@end
@implementation ShoppingCarTableViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame])
        self=[[[NSBundle mainBundle]loadNibNamed:@"ShoppingCarTableViewCell" owner:self options:nil] firstObject];
    return self;
    
}

+(instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID=@"SHOPCAR";
    ShoppingCarTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        NSLog(@"内存中没找到");
        [tableview registerNib:[UINib nibWithNibName:@"ShoppingCarTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell=[tableview dequeueReusableCellWithIdentifier:ID];
        
        
        
    }
    return cell;
    
    
}



-(void)setImage:(NSString *)image{
    [[DownLoadImageTool singletonInstance]imageWithImage:image scaledToWidth:_goodsimage.width imageview:_goodsimage];
    
}

-(void)setName:(NSString *)name{
    _goodsname.text=name;
}


-(void)setThecountchoosed:(NSString *)thecountchoosed{
    _countchooselab.text=thecountchoosed;
}

-(void)setCurrentcount:(NSString *)currentcount{
    _countlab.text=currentcount;
    [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if([currentcount intValue]>0)
        [_minusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else
        [_minusBtn setTitleColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0] forState:UIControlStateNormal];

}

-(void)setShortcomment:(NSString *)shortcomment{
    _shortcommentlab.text=shortcomment;
}

-(void)setShouldpaid:(NSString *)shoulepaid{
    _shouldpaylab.text=shoulepaid;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
