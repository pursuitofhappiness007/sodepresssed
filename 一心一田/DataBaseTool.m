//
//  DataBaseTool.m
//  广盐健康大厨房
//
//  Created by xipin on 15/11/25.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "DataBaseTool.h"
#import "FMDatabase.h"

@implementation DataBaseTool
+(FMDatabase *)creatAdatabase:(NSString *)filename{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",filename]];
    // 创建一个数据库的实例,仅仅在创建一个实例，并会打开数据库
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
   
    // 打开数据库
    BOOL flag = [db open];
    if (flag) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
    
    // 创建数据库表
    // 数据库操作：插入，更新，删除都属于update
    // 参数：sqlite语句
    BOOL flag1 = [db executeUpdate:@"create table if not exists t_contact (id integer primary key autoincrement,name text,phone text);"];
    if (flag1) {
        NSLog(@"创建成功");
        return db;
    }else{
        NSLog(@"创建失败");
        return nil;
        
    }
}

-(BOOL)select:(NSString *)sqlstring database:(FMDatabase *)db{
    
    FMResultSet *result =  [db executeQuery:sqlstring];
    
    // 从结果集里面往下找
    while ([result next]) {
        NSString *name = [result stringForColumn:@"name"];
        NSString *phone = [result stringForColumn:@"phone"];
        NSLog(@"%@--%@",name,phone);
    }
    return YES;
}

-(BOOL)update:(NSString *)urlstring database:(FMDatabase *)db{
    BOOL flag = [db executeUpdate:urlstring];
    if (flag) {
        NSLog(@"success");
        return YES;
    }else{
        NSLog(@"failure");
        return NO;
    }

}

-(BOOL)insert:(NSString *)sqlstring database:(FMDatabase *)db{
    BOOL flag = [db executeUpdate:sqlstring];
    if (flag) {
        NSLog(@"success");
        return YES;
    }else{
        NSLog(@"failure");
        return NO;
    }
}

-(BOOL)deleteitem:(NSString *)sqlstring database:(FMDatabase *)db{
    BOOL flag = [db executeUpdate:sqlstring];
    if (flag) {
        NSLog(@"success");
        return YES;
    }else{
        NSLog(@"failure");
        return NO;
    }

}
@end
