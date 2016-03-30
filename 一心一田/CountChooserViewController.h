//
//  CountChooserViewController.h
//  一心一田
//
//  Created by xipin on 16/3/30.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum _Celltype{
    homecell,
    goodslistcell,
    shopcarcell
}Celltype;
@interface CountChooserViewController : UIViewController
@property (nonatomic,strong)id cell;
@property (nonatomic,assign) Celltype type;
@end
