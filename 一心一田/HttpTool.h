//
//  HttpTool.h
//  广盐健康大厨房
//
//  Created by xipin on 15/11/25.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HttpTool : NSObject
+ (void)get:(NSString *)api params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *error))failure controler:(UIViewController *)vc;

+ (void)post:(NSString *)api params:(NSMutableDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure controler:(UIViewController *)vc;

@end
