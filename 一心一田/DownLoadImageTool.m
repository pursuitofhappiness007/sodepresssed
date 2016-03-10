//
//  DownLoadImageTool.m
//  一心一田餐饮
//
//  Created by xipin on 15/9/18.
//  Copyright © 2015年 yose. All rights reserved.
//

#import "DownLoadImageTool.h"
#import <Foundation/Foundation.h>


@implementation DownLoadImageTool

static DownLoadImageTool  *_singletonInstance = nil;

+(DownLoadImageTool *)singletonInstance{
    @synchronized([DownLoadImageTool class])
    {
        if (!_singletonInstance)
            _singletonInstance = [[self alloc] init];
        return _singletonInstance;
    }
    
    return nil;
    
    
}
+(id)alloc
{
    @synchronized([DownLoadImageTool class])
    {
        NSAssert(_singletonInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _singletonInstance = [super alloc];
        return _singletonInstance;
    }
    
    return nil;
}


-(void)imageWithImage: (NSString *) urlstr scaledToWidth: (float) i_width imageview:(UIImageView *)imageview
{
   
    NSURL *url=[NSURL URLWithString:urlstr];
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        UIImage *originalimg=responseObject;
        imageview.userInteractionEnabled=YES;
        imageview.clipsToBounds=YES;
        imageview.contentMode=UIViewContentModeScaleAspectFill;
        float oldWidth =originalimg.size.width;
        float scaleFactor =i_width / oldWidth;
        
        float newHeight = originalimg.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [originalimg drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageview.image=newImage;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        imageview.image=[UIImage imageNamed:@"defaultimg"];
    }];
    [requestOperation start];
}
@end
