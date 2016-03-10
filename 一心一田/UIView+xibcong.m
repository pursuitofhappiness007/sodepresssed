//
//  UIView+xibcong.m
//  kitchen
//
//  Created by xipin on 15/12/15.
//  Copyright © 2015年 gy. All rights reserved.
//

#import "UIView+xibcong.h"

@implementation UIView (xibcong)
@dynamic borderColor,borderWidth,cornerRadius;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}
@end
