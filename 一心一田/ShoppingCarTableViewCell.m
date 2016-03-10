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
@property (weak, nonatomic) IBOutlet UILabel *goodsprice;
@property (weak, nonatomic) IBOutlet UILabel *originalpricelab;
@property (weak, nonatomic) IBOutlet UILabel *currentpricelab;
@property (weak, nonatomic) IBOutlet UILabel *countchooselab;
@property (weak, nonatomic) IBOutlet UILabel *reallypaidlab;
@property (weak, nonatomic) IBOutlet UILabel *goodsleibielab;

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

-(void)setGoodsfenlei:(NSString *)goodsfenlei{
    _goodsleibielab.text=goodsfenlei;

}

-(void)setPricebefore:(NSString *)pricebefore{
    if ([pricebefore rangeOfString:@"."].location == NSNotFound) {
        _goodsprice.text=pricebefore;
    }
    else{
        int location=[pricebefore rangeOfString:@"."].location;
        
        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString: pricebefore];
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont systemFontOfSize:12]
                          range: NSMakeRange(0,1)];
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont systemFontOfSize:17]
                          range: NSMakeRange(1,location-1)];
        
        [attString addAttribute: NSFontAttributeName
         
                          value:  [UIFont systemFontOfSize:12]
                          range: NSMakeRange(location+1,pricebefore.length-location-1)];
        
        
        _goodsprice.attributedText=attString;
    }
}

-(void)setOriginalprice:(NSString *)originalprice{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:originalprice];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [attributeString length])];
    
    _originalpricelab.attributedText=attributeString;
    
    
}

-(void)setCurrentprice:(NSString *)currentprice{
   
    
        int location=[currentprice rangeOfString:@":"].location;
        
        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString: currentprice];
    //首先将:后面的文字全部设定为红色且17号字体
    [attString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor redColor]
                      range:NSMakeRange(location+1,currentprice.length-location-1)];
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont systemFontOfSize:12]
                      range: NSMakeRange(location+1,1)];
    
    [attString addAttribute: NSFontAttributeName
                          value:  [UIFont systemFontOfSize:17]
                          range: NSMakeRange(location+2,currentprice.length-location-2)];
    
    
    if ([currentprice rangeOfString:@"."].location == NSNotFound) {
       
    }
    else{
        int location2=[currentprice rangeOfString:@"."].location;
        
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont systemFontOfSize:12]
                          range: NSMakeRange(location2+1,1)];
        
    }
    
        _currentpricelab.attributedText=attString;
   

    
}

-(void)setThecountchoosed:(NSString *)thecountchoosed{
    _countchooselab.text=thecountchoosed;
}

-(void)setAcctuallypaid:(NSString *)acctuallypaid{
    int location=[acctuallypaid rangeOfString:@":"].location;
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString: acctuallypaid];
    //首先将:后面的文字全部设定为红色且17号字体
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont systemFontOfSize:12]
                      range: NSMakeRange(location+1,1)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont systemFontOfSize:17]
                      range: NSMakeRange(location+2,acctuallypaid.length-location-2)];
    
    
    if ([acctuallypaid rangeOfString:@"."].location == NSNotFound) {
        
    }
    else{
        int location2=[acctuallypaid rangeOfString:@"."].location;
        
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont systemFontOfSize:12]
                          range: NSMakeRange(location2+1,1)];
        
    }
    
    _reallypaidlab.attributedText=attString;

}

-(void)setCurrentcount:(NSString *)currentcount{
    _countlab.text=currentcount;
    int i=[currentcount intValue];
    if(i==1){
        [_minusBtn setTitleColor:[UIColor colorWithRed:163.0/255 green:163.0/255  blue:163.0/255  alpha:1.0] forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
           }
    if(i>1){
        [_minusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
