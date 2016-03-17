//
//  WXPayTool.m
//  一心一田
//
//  Created by xipin on 16/3/7.
//  Copyright © 2016年 xipin. All rights reserved.
//

#import "WXPayTool.h"
#import "WXApiManager.h"
@implementation WXPayTool
static WXPayTool *_sigletonInstance=nil;
+(WXPayTool *)singletonInstance{
    @synchronized([DownLoadImageTool class])
    {
        if (!_sigletonInstance)
            _sigletonInstance = [[self alloc] init];
        return _sigletonInstance;
    }
    
    return nil;

}

+(id)alloc
{
    @synchronized([WXPayTool class])
    {
        NSAssert(_sigletonInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sigletonInstance = [super alloc];
        return _sigletonInstance;
    }
    
    return nil;
}

-(BOOL)wxpaywithdict:(NSDictionary *)dict{
    PayReq *request=[[PayReq alloc]init];
    
    request.partnerId=[dict stringForKey:@"prepayId"];
    request.package =@"Sign=WXPay";
    request.prepayId=[dict stringForKey:@"prepayid"];
    request.nonceStr=[dict stringForKey:@"noncestr"];
    request.timeStamp=[dict int64ForKey:@"timestamp"];
    request.sign=[dict stringForKey:@"sign"];
    
    if([WXApi sendReq:request])
        return YES;
    else
        return NO;

}

@end
