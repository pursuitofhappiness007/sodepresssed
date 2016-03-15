//
//  EditNickNameViewController.h
//  kitchen
//
//  Created by xipin on 15/12/17.
//  Copyright © 2015年 gy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum _ChangeType{
    Nickname,
    Phone1,
    Phone2,
    Phone3
}ChangeType;
@interface EditNickNameViewController : UIViewController
@property (nonatomic,strong) NSString *stringtobechanged;
@property (nonatomic,assign) ChangeType type;
@end
