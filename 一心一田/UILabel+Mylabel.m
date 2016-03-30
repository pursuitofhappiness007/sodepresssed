//
//  UILabel+Mylabel.m
//  一心一田
//
//  Created by xipin on 16/3/30.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "UILabel+Mylabel.h"

@implementation UILabel (Mylabel)
@dynamic aligntobottom;
-(void)setAligntobottom:(BOOL)aligntobottom{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    
    
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    
    for(int i=0; i< newLinesToPad; i++)
    {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}
@end
