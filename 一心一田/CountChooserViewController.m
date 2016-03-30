//
//  CountChooserViewController.m
//  一心一田
//
//  Created by xipin on 16/3/30.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "CountChooserViewController.h"
#import "HomeTableViewCell.h"
#import "GoodListTableViewCell.h"
#import "ShoppingCarTableViewCell.h"
@interface CountChooserViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
- (IBAction)minusBtnClicked:(id)sender;
- (IBAction)addBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *counttf;
- (IBAction)sureBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;
//容器
@property (weak, nonatomic) IBOutlet UIView *containerview;



@end

@implementation CountChooserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initlocal];
   
    
}


-(void)initlocal{
    [_counttf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if([_counttf.text intValue]>0)
        [_minusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else
        [_minusBtn setTitleColor:[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1.0] forState:UIControlStateNormal];
    switch (_type) {
        case homecell:{
            HomeTableViewCell *cell=(HomeTableViewCell *)_cell;
            _counttf.text=cell.countlab.text;
        }
            
            break;
        case goodslistcell:{
            GoodListTableViewCell *cell=(GoodListTableViewCell *)_cell;
            _counttf.text=cell.countlab.text;
        }
            break;
        case shopcarcell:{
            ShoppingCarTableViewCell *cell=(ShoppingCarTableViewCell *)_cell;
            _counttf.text=cell.countlab.text;
        }
            break;
        default:
            break;
    }
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    int i=[theTextField.text intValue];
    theTextField.text=[NSString stringWithFormat:@"%d",i];
    if(i>0)
        [_minusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else
        [_minusBtn setTitleColor:[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1.0] forState:UIControlStateNormal];
}
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    if(MAIN_HEIGHT-_containerview.height-_containerview.y<keyboardFrameBeginRect.size.height){
        CGFloat detlaHeight=keyboardFrameBeginRect.size.height-(MAIN_HEIGHT-_containerview.height-_containerview.y);
        
        self.view.y=-detlaHeight-5;
    }
    NSLog(@"键盘高度  %f",keyboardFrameBeginRect.size.height);
    
}

-(void)keyboardWillHide:(NSNotification*)notification{
    self.view.y=0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)minusBtnClicked:(id)sender {
    int i=[_counttf.text intValue];
    if(i>0)
    {
        if(i==1)
       [_minusBtn setTitleColor:[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1.0] forState:UIControlStateNormal];
        _counttf.text=[NSString stringWithFormat:@"%d",i-1];
    }
    
        

}

- (IBAction)addBtnClicked:(id)sender {
    int i=[_counttf.text intValue];
    if(i>=0)
        [_minusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _counttf.text=[NSString stringWithFormat:@"%d",i+1];
}
- (IBAction)sureBtnClicked:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        switch (_type) {
            case homecell:{
                HomeTableViewCell *cell=(HomeTableViewCell *)_cell;
                cell.count=_counttf.text;
                [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:[_counttf.text intValue] tabbar:self.tabBarController];
            }
                
                break;
            case goodslistcell:{
                GoodListTableViewCell *cell=(GoodListTableViewCell *)_cell;
                cell.count=_counttf.text;
                [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:[_counttf.text intValue] tabbar:self.tabBarController];
            }
                break;
            case shopcarcell:{
                ShoppingCarTableViewCell *cell=(ShoppingCarTableViewCell *)_cell;
                cell.currentcount=_counttf.text;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"donotrefresh" object:nil];
                [LocalAndOnlineFileTool addOrMinusBtnClickedToRefreshlocal:cell.goodsid withcount:[_counttf.text intValue] tabbar:self.tabBarController];
                
            }
                break;
            default:
                break;
        }
    }];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:^{
            }];
}
@end
