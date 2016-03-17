//
//  GoodListTableViewCell.m
//  一心一田
//
//  Created by xipin on 16/3/14.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "GoodListTableViewCell.h"
@interface GoodListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsimageview;
@property (weak, nonatomic) IBOutlet UILabel *goodnamelab;
@property (weak, nonatomic) IBOutlet UILabel *shortcommentlab;
@property (weak, nonatomic) IBOutlet UILabel *specificlab;
@property (weak, nonatomic) IBOutlet UILabel *counthasbeensaledlab;


@end
@implementation GoodListTableViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame])
        self=[[[NSBundle mainBundle]loadNibNamed:@"GoodListTableViewCell" owner:self options:nil] firstObject];
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableview cellwithIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID=@"listcell";
    GoodListTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        NSLog(@"内存中没找到");
        [tableview registerNib:[UINib nibWithNibName:@"GoodListTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell=[tableview dequeueReusableCellWithIdentifier:ID];
        
    }
    return cell;
    
    
}

-(void)setGoodimg:(NSString *)goodimg{
    [[DownLoadImageTool singletonInstance]imageWithImage:goodimg scaledToWidth:_goodsimageview.width imageview:_goodsimageview];
}
-(void)setGoodname:(NSString *)goodname{
    _goodnamelab.text=goodname;
}
-(void)setShortcomment:(NSString *)shortcomment{
    _shortcommentlab.text=shortcomment;
}
-(void)setSpecific:(NSString *)specific{
    _specificlab.text=specific;
}
-(void)setRange1:(NSString *)range1{
    _range1lab.text=range1;
}
-(void)setRange2:(NSString *)range2{
    _range2lab.text=range2;
}
-(void)setRange3:(NSString *)range3{
    _range3lab.text=range3;
}
-(void)setRange4:(NSString *)range4{
    _range4lab.text=range4;
}
-(void)setPrice1:(NSString *)price1{
    _price1lab.text=price1;
}
-(void)setPrice2:(NSString *)price2{
    _price2lab.text=price2;
}
-(void)setPrice3:(NSString *)price3{
    _price3lab.text=price3;
}
-(void)setPrice4:(NSString *)price4{
    _price4lab.text=price4;
}
-(void)setCount:(NSString *)count{
    _countlab.text=count;
}

-(void)setCounthasbeensaled:(NSString *)counthasbeensaled{
    _counthasbeensaledlab.text=counthasbeensaled;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
