//
//  WXPayTool.h
//  一心一田
//
//  Created by xipin on 16/3/7.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WXPayTool : NSObject
+(WXPayTool *)singletonInstance;
-(BOOL)wxpaywithpartnerId:(NSString *)partnerId prepayId:(NSString *)prepayId noncestr:(NSString *)noncestr timestamp:(int64_t)timestamp sign:(NSString *)sign;
@end
