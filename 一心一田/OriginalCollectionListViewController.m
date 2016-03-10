//
//  OriginalCollectionListViewController.m
//  一心一田餐饮
//
//  Created by xipin on 15/10/30.
//  Copyright © 2015年 yose. All rights reserved.
//

#import "OriginalCollectionListViewController.h"
#import "CollectionListTableViewCell.h"
#import "SingleGoodOrderConfirmnationViewController.h"
#import "GoodsDetailViewController.h"

@interface OriginalCollectionListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *ids;
    AFHTTPRequestOperationManager *mgr;
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation OriginalCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mgr=[AFHTTPRequestOperationManager manager];
    ids=[NSMutableArray array];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.showsVerticalScrollIndicator=NO;
    page=1;
     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title=@"收藏";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor]}];
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"back" highImageName:nil target:self action:@selector(backBtnClicked)];
    [self refreshcollectionviewlist:1];
    
    
}

-(void)refreshcollectionviewlist:(int)page{
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    para[@"token"]=[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"][@"token"];
    para[@"page_no"]=[NSString stringWithFormat:@"%d",page];
    para[@"app_source"]=@"6";
    [mgr POST:[NSString stringWithFormat:@"%@get_favour_list",HOST] parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"count＝%lu responseobj=%@ ids.count=%d",[[[responseObject dictionaryForKey:@"data"] mutableArrayValueForKey:@"favour_list"] count],responseObject,ids.count);
        if([[[responseObject dictionaryForKey:@"data"] mutableArrayValueForKey:@"favour_list"] count]==0)
            return ;
       
            [ids addObjectsFromArray:[[responseObject dictionaryForKey:@"data"] mutableArrayValueForKey:@"favour_list"]];
            
        [_table reloadData];
        
       
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return ids.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (260.0/1334)*MAIN_HEIGHT;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (25.0/1334)*MAIN_HEIGHT;

}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"collectionlistcell";
    CollectionListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
       
        
        [_table registerNib:[UINib nibWithNibName:@"CollectionListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell=[_table dequeueReusableCellWithIdentifier:identifier];
        
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [[DownLoadImageTool singletonInstance]imageWithImage:ids[indexPath.section][@"goodsThumbnailImg"] scaledToWidth:cell.goodspic.width imageview:cell.goodspic];
    cell.goodsname.text=ids[indexPath.section][@"goodsName"];
    cell.price.text=[ids[indexPath.section][@"goodsSalePrice"] stringValue];
    cell.price.textColor=[UIColor redColor];
   
    

    cell.buySoon.tag=indexPath.section;
    [cell.buySoon addTarget:self action:@selector(buySoonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.heart.tag=indexPath.section;
    [cell.heart addTarget:self action:@selector(cancelCollection:) forControlEvents:UIControlEventTouchUpInside];
    cell.goodsDetailBtn.tag=indexPath.section;
    [cell.goodsDetailBtn addTarget:self action:@selector(goodsDetailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    page++;
    NSLog(@"page=%d",page);
     if((indexPath.section==ids.count-1)&&(ids.count>20))
        [self refreshcollectionviewlist:page];

}

-(void)goodsDetailBtnClicked:(UIButton *)sender{
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)buySoonClicked:(UIButton *)sender{
}

-(void)cancelCollection:(UIButton *)sender{
    NSLog(@"取消收藏");
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
   NSString *token=[[SaveFileAndWriteFileToSandBox singletonInstance]getfilefromsandbox:@"tokenfile.txt"][@"token"];
    NSArray *idsarray=@[ids[sender.tag][@"goodsId"]];
    para[@"favour_id_list"]=@[ids[sender.tag][@"goodsId"]];
    para[@"app_source"]=@"6";
    
    [mgr POST:[NSString stringWithFormat:@"%@batch_delete_favour?app_source=6&token=%@&favour_id_list=[%@]",HOST,token,ids[sender.tag][@"id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"取消收藏成功 %@",responseObject);
        [ids removeObjectAtIndex:sender.tag];
        [self.table reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"取消收藏失败 %@",error);
    }];
    

}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
