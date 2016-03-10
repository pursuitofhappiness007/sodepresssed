//
//  HttpTool.m
//  广盐健康大厨房
//
//  Created by xipin on 15/11/25.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool



+ (void)get:(NSString *)api params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    params[@"app_source"]=@6;
    
    // 2.发送GET请求
    [mgr GET:[NSString stringWithFormat:@"%@%@",HOST,api] parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if (success) {
             success(responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)post:(NSString *)api params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
     params[@"app_source"]=@"6";
    
    // 2.发送POST请求
    [mgr POST:[NSString stringWithFormat:@"%@%@",HOST,api] parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObj) {
          
          if (success) {
              success(responseObj);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

@end
